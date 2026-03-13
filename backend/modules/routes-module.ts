import { ServiceModule } from "../module.ts";
import { configService } from "../services/config-service.ts";
import { logger } from "../services/logger.ts";
import { Hono } from "hono";
import { AppRoutes } from "../routes/routes.ts";
import { graphqlService } from "../services/graphql.ts";
import type { AppConfig } from "../interfaces/config.ts";
import { StatusService } from "../services/status.ts";

export class RoutesModule extends ServiceModule {
  private honoApp: Hono | null = null;
  private config: AppConfig | null = null;
  private webSockets: Set<WebSocket> = new Set();
  private redisClient: any = null;

  constructor(statusService: StatusService) {
    super('routes', 'Routes (HTTP + WebSocket + GraphQL)', ['httpserver', 'redis', 'database', 'communications'], statusService);
  }

  setHonoApp(app: Hono): void {
    this.honoApp = app;
  }

  setConfig(config: AppConfig): void {
    this.config = config;
  }

  setRedisClient(client: any): void {
    this.redisClient = client;
  }

  async init(): Promise<void> {
    this.setInitializing('Initializing routes module...');

    try {
      if (!this.honoApp) {
        throw new Error('Hono app not set. HttpServerModule must be initialized first.');
      }

      // Initialize routes - creates its own Hono app
      const routes = new AppRoutes();
      await routes.setupRoutes();
      
      // Mount all routes from routes.app to the main honoApp
      // Use a wildcard route to forward all requests to the routes app
      this.honoApp.use('*', async (ctx) => {
        return await routes.app.fetch(ctx.req.raw);
      });

      this.setReady('Routes initialized');
      logger.info('Routes module ready');
    } catch (error) {
      this.setError(error as Error, 'Failed to initialize routes');
      throw error;
    }
  }

  async start(): Promise<void> {
    this.setInitializing('Starting routes (WebSocket + GraphQL)...');

    try {
      if (!this.honoApp) {
        throw new Error('Hono app not available');
      }

      // Setup WebSocket upgrade handling
      this.setupWebSocketHandling();

      // Setup GraphQL endpoint
      this.setupGraphQLEndpoint();

      this.setReady('Routes, WebSocket, and GraphQL active');
      logger.info('Routes module started (HTTP + WebSocket + GraphQL)');
    } catch (error) {
      this.setError(error as Error, 'Failed to start routes');
      throw error;
    }
  }

  private setupWebSocketHandling(): void {
    if (!this.honoApp) return;

    // WebSocket upgrade middleware
    this.honoApp.use(async (ctx, next) => {
      const upgrade = ctx.req.header('upgrade');
      if (upgrade?.toLowerCase() === 'websocket') {
        try {
          const { socket, response } = Deno.upgradeWebSocket(ctx.req.raw);
          this.webSockets.add(socket);

          logger.info(`WebSocket connection established`);

          socket.onmessage = (event) => {
            this.handleWebSocketMessage(socket, event.data);
          };

          socket.onclose = () => {
            this.webSockets.delete(socket);
            logger.info('WebSocket connection closed');
          };

          socket.onerror = (error) => {
            logger.error('WebSocket error', error);
            this.webSockets.delete(socket);
          };

          return response;
        } catch (error) {
          logger.error('WebSocket upgrade failed', error);
          return ctx.text('WebSocket upgrade failed', 400);
        }
      }
      await next();
    });

    // Subscribe to Redis for inter-service WebSocket broadcasts
    if (this.redisClient) {
      this.subscribeToRedisWebSocket();
    }
  }

  private handleWebSocketMessage(socket: WebSocket, data: string): void {
    try {
      const message = JSON.parse(data);
      
      switch (message.type) {
        case 'ping':
          socket.send(JSON.stringify({ type: 'pong', timestamp: Date.now() }));
          break;
        
        case 'graphql':
          this.handleGraphQLWebSocket(socket, message);
          break;
        
        case 'subscribe':
          // Handle GraphQL subscriptions
          this.handleGraphQLSubscription(socket, message);
          break;
        
        case 'broadcast':
          // Broadcast to all connected clients
          this.broadcastToAll(message.data);
          break;
        
        default:
          logger.warn(`Unknown WebSocket message type: ${message.type}`);
      }
    } catch (error) {
      logger.error('WebSocket message handling error', error);
    }
  }

  private async handleGraphQLWebSocket(socket: WebSocket, message: any): Promise<void> {
    try {
      const { query, variables, operationName } = message;
      const result = await graphqlService.execute(query, variables, { user: null });
      socket.send(JSON.stringify({
        type: 'graphql-response',
        id: message.id,
        payload: result
      }));
    } catch (error) {
      socket.send(JSON.stringify({
        type: 'graphql-error',
        id: message.id,
        payload: { errors: [{ message: error instanceof Error ? error.message : 'Unknown error' }] }
      }));
    }
  }

  private handleGraphQLSubscription(socket: WebSocket, message: any): void {
    // Store subscription info
    // In a real implementation, you'd set up Redis pub/sub here
    logger.info(`GraphQL subscription registered: ${message.id}`);
  }

  private async subscribeToRedisWebSocket(): Promise<void> {
    try {
      const subscriber = this.redisClient.subscribe('websocket:broadcast');
      
      for await (const message of subscriber) {
        try {
          const data = JSON.parse(message);
          this.broadcastToAll(data);
        } catch (error) {
          logger.error('Redis WebSocket broadcast error', error);
        }
      }
    } catch (error) {
      logger.error('Redis WebSocket subscription error', error);
    }
  }

  private broadcastToAll(data: any): void {
    const message = JSON.stringify(data);
    this.webSockets.forEach(socket => {
      if (socket.readyState === WebSocket.OPEN) {
        socket.send(message);
      }
    });
  }

  private setupGraphQLEndpoint(): void {
    if (!this.honoApp) return;

    // GraphQL endpoint
    this.honoApp.post('/graphql', async (ctx) => {
      try {
        const body = await ctx.req.json();
        const { query, variables, operationName } = body;

        const result = await graphqlService.execute(query, variables, {
          user: null,
          request: ctx.req.raw,
        });

        return ctx.json(result);
      } catch (error) {
        logger.error('GraphQL error', error);
        return ctx.json({ errors: [{ message: 'Internal server error' }] }, 500);
      }
    });

    // GraphQL playground (non-production)
    if (this.config?.environment !== 'production') {
      this.honoApp.get('/graphql', async (ctx) => {
        const html = `
          <!DOCTYPE html>
          <html>
          <head>
            <title>GraphQL Playground</title>
            <link href="https://cdn.jsdelivr.net/npm/graphql-playground-react@1.7.28/build/static/css/index.css" rel="stylesheet" />
          </head>
          <body>
            <div id="root"></div>
            <script>window.addEventListener('load', function (event) {
              GraphQLPlayground.init(document.getElementById('root'), {
                endpoint: '/graphql'
              })
            })</script>
            <script src="https://cdn.jsdelivr.net/npm/graphql-playground-react@1.7.28/build/static/js/middleware.js"></script>
          </body>
          </html>
        `;
        ctx.header('Content-Type', 'text/html');
        return ctx.html(html);
      });
    }
  }

  async stop(): Promise<void> {
    try {
      // Close all WebSocket connections
      this.webSockets.forEach(socket => {
        try {
          socket.close();
        } catch {
          // Ignore errors during close
        }
      });
      this.webSockets.clear();

      this.setStopped('Routes module stopped');
      logger.info('Routes module stopped');
    } catch (error) {
      logger.error('Error stopping routes module', error);
    }
  }

  public getWebSocketCount(): number {
    return this.webSockets.size;
  }

  public broadcast(data: any): void {
    this.broadcastToAll(data);
  }
}
