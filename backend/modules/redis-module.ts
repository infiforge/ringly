import { ServiceModule } from "../module.ts";
import { StatusService } from "../services/status.ts";
import { logger } from "../services/logger.ts";

export class RedisModule extends ServiceModule {
  private redisClient: any = null;

  constructor(statusService: StatusService) {
    super('redis', 'Redis', ['logger'], statusService);
  }

  async init(): Promise<void> {
    this.setInitializing('Connecting to Redis...');

    try {
      const { connect } = await import("https://deno.land/x/redis@v0.32.3/mod.ts");

      const redisHost = Deno.env.get("REDIS_HOST") || "127.0.0.1";
      const redisPort = parseInt(Deno.env.get("REDIS_PORT") || "6379", 10);

      this.redisClient = await connect({
        hostname: redisHost,
        port: redisPort,
      });

      // Test connection
      await this.redisClient.ping();

      this.setReady(`Connected to ${redisHost}:${redisPort}`);
    } catch (error) {
      this.setError(error as Error, 'Redis connection failed - continuing without Redis');
      // Redis is optional, so we don't throw
    }
  }

  async start(): Promise<void> {
    if (this.redisClient) {
      try {
        const sub = this.redisClient.subscribe('services:status');
        await sub.ready();
        sub.on('message', (channel: string, message: string) => {
          // Handle messages
        });
      } catch (e) {
        logger.warn('Failed to subscribe to Redis channels');
      }
    }
  }

  async stop(): Promise<void> {
    if (this.redisClient) {
      await this.redisClient.close();
    }
  }

  getClient(): any {
    return this.redisClient;
  }
}
