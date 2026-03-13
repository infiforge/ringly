import { ServiceModule } from "../module.ts";
import { StatusService } from "../services/status.ts";
import { Hono } from "hono";
import { logger } from "../services/logger.ts";
import { AppRoutes } from "../routes/routes.ts";
import { serve } from "std/http/server.ts";

export class HttpServerModule extends ServiceModule {
  private app: Hono | null = null;
  private controller: AbortController | null = null;
  private port: number = 0;

  constructor(statusService: StatusService) {
    super('httpserver', 'HTTP Server (Hono)', ['logger'], statusService);
  }

  setPort(port: number): void {
    this.port = port;
  }

  getApp(): Hono | null {
    return this.app;
  }

  async init(): Promise<void> {
    this.setInitializing('Creating Hono application...');

    try {
      this.app = new Hono();
      // Routes will be set up by RoutesModule
      this.setReady('Hono application created');
    } catch (error) {
      this.setError(error as Error, 'Failed to create Hono application');
      throw error;
    }
  }

  async start(): Promise<void> {
    if (!this.app) {
      throw new Error('Application not initialized');
    }

    this.setInitializing(`Starting HTTP server on port ${this.port}...`);

    try {
      this.controller = new AbortController();
      
      // Use Deno's serve with the Hono app's fetch handler
      serve(
        this.app.fetch.bind(this.app),
        {
          port: this.port,
          hostname: '0.0.0.0',
          signal: this.controller.signal,
        }
      );

      this.setReady(`HTTP server listening on :${this.port}`);
    } catch (error) {
      this.setError(error as Error, 'Failed to start HTTP server');
      throw error;
    }
  }

  async stop(): Promise<void> {
    if (this.controller) {
      this.controller.abort();
      this.controller = null;
    }
  }
}
