import { ServiceModule } from "../module.ts";
import { StatusService } from "../services/status.ts";
import { database } from "../services/database.ts";

export class DatabaseModule extends ServiceModule {
  constructor(statusService: StatusService) {
    super('database', 'Database', ['logger'], statusService);
  }

  async init(): Promise<void> {
    this.setInitializing('Connecting to database...');

    try {
      // Update database max retries to 50
      if (database && typeof (database as any).maxReconnectAttempts !== 'undefined') {
        (database as any).maxReconnectAttempts = 50;
      }

      let attempts = 0;
      const maxAttempts = 50;
      let connected = false;

      while (!connected && attempts < maxAttempts) {
        // Check for shutdown signal
        if (this.statusService.getAbortSignal().aborted) {
          this.setStopped('Database init aborted due to shutdown');
          return;
        }

        attempts++;
        this.setProgress(Math.round((attempts / maxAttempts) * 100), `Connection attempt ${attempts}/${maxAttempts}...`);

        connected = await database.connect();
        if (!connected) {
          if (attempts < maxAttempts) {
            // Wait but check abort during wait (we'll break next loop iteration)
            await new Promise(resolve => setTimeout(resolve, 5000)); // 5s retry
          }
        }
      }

      if (connected) {
        this.setReady(`Connected after ${attempts} attempt(s)`);
      } else {
        this.setError(new Error('Database connection failed after 50 attempts'), 'Database unavailable');
      }
    } catch (error) {
      this.setError(error as Error, 'Database connection error');
      throw error;
    }
  }

  async start(): Promise<void> {
    // Database is passive after connection
  }

  async stop(): Promise<void> {
    await database.close();
  }

  async reconnect(): Promise<void> {
    this.setInitializing('Reconnecting to database...');
    await database.close();
    const connected = await database.connect();
    if (connected) {
      this.setReady('Reconnected');
    } else {
      this.setError(new Error('Reconnection failed'), 'Database reconnect failed');
    }
  }
}
