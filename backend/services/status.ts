import { ServiceModule, ModuleState } from "../module.ts";
import { logger } from "./logger.ts";

export class StatusService {
  private modules: Map<string, ServiceModule> = new Map();
  private abortController: AbortController = new AbortController();

  registerModule(module: ServiceModule): void {
    this.modules.set(module.id, module);
    logger.info(`Module registered: ${module.name} (${module.id})`);
  }

  getModule(id: string): ServiceModule | undefined {
    return this.modules.get(id);
  }

  getAllModules(): ServiceModule[] {
    return Array.from(this.modules.values());
  }

  getModuleStatus(id: string): ModuleState | undefined {
    const module = this.modules.get(id);
    return module?.getStatus();
  }

  getAllStatuses(): Map<string, ModuleState> {
    const statuses = new Map<string, ModuleState>();
    for (const [id, module] of this.modules) {
      statuses.set(id, module.getStatus());
    }
    return statuses;
  }

  getAbortSignal(): AbortSignal {
    return this.abortController.signal;
  }

  triggerShutdown(): void {
    logger.info("Shutdown signal triggered");
    this.abortController.abort();
  }

  isShutdown(): boolean {
    return this.abortController.signal.aborted;
  }
}
