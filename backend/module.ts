import { logger } from "./services/logger.ts";
import { StatusService } from "./services/status.ts";

export enum ModuleStatus {
  pending = "pending",
  initializing = "initializing",
  ready = "ready",
  error = "error",
  stopped = "stopped",
}

export interface ModuleState {
  state: ModuleStatus;
  progress: number;
  message?: string;
  error?: string;
}

export abstract class ServiceModule {
  readonly id: string;
  readonly name: string;
  readonly dependencies: string[];

  protected status: ModuleState;
  protected started: boolean = false;
  protected statusService: StatusService;

  constructor(id: string, name: string, dependencies: string[] = [], statusService: StatusService) {
    this.id = id;
    this.name = name;
    this.dependencies = dependencies;
    this.statusService = statusService;
    this.status = { state: ModuleStatus.pending, progress: 0, message: 'Waiting to start' };
  }

  // Set status service after construction (injection)
  setStatusService(): void {
    // Status service injection
  }

  // Lifecycle hooks
  abstract init(): Promise<void>;
  abstract start(): Promise<void>;
  abstract stop(): Promise<void>;

  // Helper methods for common status transitions
  protected setInitializing(message?: string): void {
    this.status = { state: ModuleStatus.initializing, progress: 0, message: message || 'Initializing...' };
    logger.info(`${this.name} initializing${message ? ': ' + message : ''}`);
  }

  protected setProgress(percent: number, message?: string): void {
    this.status.progress = percent;
    if (message) this.status.message = message;
  }

  protected setReady(message?: string): void {
    this.status = { state: ModuleStatus.ready, progress: 100, message: message || 'Ready' };
    this.started = true;
    logger.success(`${this.name} ready${message ? ': ' + message : ''}`);
  }

  protected setStopped(message?: string): void {
    this.status = { state: ModuleStatus.stopped, progress: 0, message: message || 'Stopped' };
    this.started = false;
    logger.info(`${this.name} stopped${message ? ': ' + message : ''}`);
  }

  // Status getters
  getStatus(): ModuleState {
    return this.status;
  }

  isReady(): boolean {
    return this.status.state === ModuleStatus.ready;
  }

  isStarted(): boolean {
    return this.started;
  }

  hasDependency(moduleId: string): boolean {
    return this.dependencies.includes(moduleId);
  }

  // Error handling
  setError(error: Error | string, message?: string): void {
    const errorMsg = typeof error === 'string' ? error : error.message;
    this.status = {
      state: ModuleStatus.error,
      progress: 0,
      error: errorMsg,
      message: message || 'Module failed to start',
    };
    logger.error(`${this.name} failed: ${errorMsg}`);
  }
}
