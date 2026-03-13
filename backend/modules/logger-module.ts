import { ServiceModule } from "../module.ts";
import { StatusService } from "../services/status.ts";
import { logger } from "../services/logger.ts";

export class LoggerModule extends ServiceModule {
  constructor(statusService: StatusService) {
    super('logger', 'Logger', [], statusService);
  }

  async init(): Promise<void> {
    this.setInitializing('Initializing logger...');

    try {
      // Logger is already instantiated; just verify it works
      logger.info('Logger module initializing');

      this.setReady('Logger initialized');
    } catch (error) {
      this.setError(error as Error, 'Logger initialization failed');
      throw error;
    }
  }

  async start(): Promise<void> {
    // Logger is always running
  }

  async stop(): Promise<void> {
    // No stop needed
  }
}
