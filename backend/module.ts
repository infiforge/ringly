import type { MiddlewareHandler } from "hono";
// StatusService defined below

export enum ModuleStatus {
  pending = "pending",
  initializing = "initializing",
  ready = "ready",
  error = "error",
  stopped = "stopped",
}

export abstract class ServiceModule {
  readonly id: string;
  readonly name: string;
  readonly dependencies: string[];

  protected status: ModuleStatus = ModuleStatus.pending;
  protected started: boolean = false;

  constructor(id: string, name: string, dependencies: string[] = []) {
    this.id = id;
    this.name = name;
    this.dependencies = dependencies;
  }

  // Set status service after construction (injection)
  setStatusService(): void {
    // Status service injection
  }

  // Lifecycle hooks
  async init(): Promise<void> {
    this.status = ModuleStatus.initializing;
  }

  async start(): Promise<void> {
    this.started = true;
    this.status = ModuleStatus.ready;
  }

  async stop(): Promise<void> {
    this.started = false;
    this.status = ModuleStatus.stopped;
  }

  // Status getters
  getStatus(): ModuleStatus {
    return this.status;
  }

  isReady(): boolean {
    return this.status === ModuleStatus.ready;
  }

  isStarted(): boolean {
    return this.started;
  }

  hasDependency(moduleId: string): boolean {
    return this.dependencies.includes(moduleId);
  }

  // Error handling
  setError(error: Error): void {
    this.status = ModuleStatus.error;
    console.error(`Module ${this.name} (${this.id}) error:`, error);
  }
}

// Simple status service implementation
export class StatusService {
  private modules: Map<string, ServiceModule> = new Map();

  registerModule(module: ServiceModule): void {
    this.modules.set(module.id, module);
  }

  getModule(id: string): ServiceModule | undefined {
    return this.modules.get(id);
  }

  getAllModules(): ServiceModule[] {
    return Array.from(this.modules.values());
  }

  getReadyModules(): ServiceModule[] {
    return this.getAllModules().filter((m) => m.isReady());
  }

  areAllReady(): boolean {
    return this.getAllModules().every((m) => m.isReady());
  }
}
