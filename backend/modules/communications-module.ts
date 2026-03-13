import { ServiceModule } from "../module.ts";
import { configService } from "../services/config-service.ts";
import { logger } from "../services/logger.ts";
import { communicationsService } from "../services/communications.ts";
import type { AppConfig } from "../interfaces/config.ts";
import { StatusService } from "../services/status.ts";

export class CommunicationsModule extends ServiceModule {
  private config: AppConfig | null = null;
  private redisClient: any = null;

  constructor(statusService: StatusService) {
    super('communications', 'Communications', ['logger', 'redis', 'database'], statusService);
  }

  public setConfig(config: AppConfig): void {
    this.config = config;
  }

  public setRedisClient(client: any): void {
    this.redisClient = client;
  }

  async init(): Promise<void> {
    this.setInitializing('Initializing communications service...');

    try {
      if (!this.config) {
        throw new Error('Configuration not set for communications module');
      }

      // Initialize communications service
      communicationsService.initialize(this.config);
      
      // Set Redis client if available
      if (this.redisClient) {
        communicationsService.setRedisClient(this.redisClient);
        logger.info('Communications module connected to Redis for async processing');
      }

      this.setReady('Communications service initialized');
      logger.info('Communications module ready (email, SMS, push notifications)');
    } catch (error) {
      this.setError(error as Error, 'Failed to initialize communications service');
      throw error;
    }
  }

  async start(): Promise<void> {
    this.setInitializing('Starting communications queue processor...');
    
    try {
      // Queue processor is already started in initialize
      // This is where we could start additional workers if needed
      
      this.setReady('Communications queue processor running');
      logger.info('Communications module started');
    } catch (error) {
      this.setError(error as Error, 'Failed to start communications service');
      throw error;
    }
  }

  async stop(): Promise<void> {
    try {
      communicationsService.stop();
      this.setStopped('Communications service stopped');
      logger.info('Communications module stopped');
    } catch (error) {
      logger.error('Error stopping communications module', error);
    }
  }

  public getService(): typeof communicationsService {
    return communicationsService;
  }

  public getQueueStatus(): { queued: number; processing: boolean } {
    return communicationsService.getQueueStatus();
  }
}
