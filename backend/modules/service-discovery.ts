import { logger } from "../services/logger.ts";

/**
 * Service manifest interface matching config.json service section schema
 */
export interface ServiceManifest {
  name: string;
  displayName: string;
  description: string;
  location: "internal" | "external";
  portRange: {
    start: number;
    end: number;
  };
  systemd: {
    serviceName: string;
    serviceTemplate: string;
  };
  healthEndpoint: string;
  apiEndpoints: {
    metrics: string;
    shutdown: string;
    logs?: string;
  };
  logging?: {
    level: string;
    bufferSize: number;
    fileRotation: {
      maxFileSizeMB: number;
      maxFiles: number;
      retentionDays: number;
    };
    redis: {
      enabled: boolean;
      channelPattern: string;
    };
    outputs: string[];
  };
}

/**
 * ServiceDiscovery module - dynamically discovers services from backend/config.json manifests
 */
class ServiceDiscovery {
  private services: Map<string, ServiceManifest> = new Map();
  private discoveryPaths: string[] = [];

  constructor() {
    // Default discovery paths
    this.discoveryPaths = [
      "/home/dave/work/services/internal",
      "/home/dave/work/services/external",
    ];
  }

  /**
   * Initialize with custom discovery paths from config
   */
  initialize(paths?: string[]): void {
    if (paths && paths.length > 0) {
      this.discoveryPaths = paths;
    }
    logger.info("[ServiceDiscovery] Initialized with paths:", {
      metadata: { paths: this.discoveryPaths },
    });
  }

  /**
   * Discover all services by scanning service directories
   */
  async discoverServices(): Promise<void> {
    logger.info("[ServiceDiscovery] Starting service discovery...");
    this.services.clear();

    for (const basePath of this.discoveryPaths) {
      try {
        await this.scanDirectory(basePath);
      } catch (error) {
        logger.error(`[ServiceDiscovery] Error scanning ${basePath}:`, error);
      }
    }

    logger.info(
      `[ServiceDiscovery] Discovery complete. Found ${this.services.size} services`,
      {
        metadata: {
          serviceCount: this.services.size,
          services: Array.from(this.services.keys()),
        },
      }
    );
  }

  /**
   * Scan a directory for service subdirectories containing backend/config.json
   */
  private async scanDirectory(basePath: string): Promise<void> {
    try {
      for await (const entry of Deno.readDir(basePath)) {
        if (entry.isDirectory) {
          const configPath = `${basePath}/${entry.name}/backend/config.json`;
          try {
            const manifest = await this.loadManifest(configPath);
            if (this.validateManifest(manifest)) {
              this.services.set(manifest.name, manifest);
              logger.debug(
                `[ServiceDiscovery] Loaded service: ${manifest.name}`,
                {
                  metadata: {
                    name: manifest.name,
                    location: manifest.location,
                    portRange: manifest.portRange,
                  },
                }
              );
            }
          } catch (error) {
            // Skip directories without valid backend/config.json
            if (!(error instanceof Deno.errors.NotFound)) {
              logger.warn(
                `[ServiceDiscovery] Failed to load ${configPath}:`,
                error
              );
            }
          }
        }
      }
    } catch (error) {
      if (error instanceof Deno.errors.NotFound) {
        logger.warn(`[ServiceDiscovery] Directory not found: ${basePath}`);
      } else {
        throw error;
      }
    }
  }

  /**
   * Load and parse a backend/config.json manifest file
   * Extracts the service section from the default environment profile
   */
  private async loadManifest(path: string): Promise<ServiceManifest> {
    const content = await Deno.readTextFile(path);
    const config = JSON.parse(content);
    
    // Extract service section from default profile, or first available profile
    const defaultProfile = config.default || config.local || config.production;
    if (!defaultProfile || !defaultProfile.service) {
      throw new Error(`No service configuration found in ${path}`);
    }
    
    const manifest = defaultProfile.service as ServiceManifest;
    
    // Merge logging config if available
    if (defaultProfile.logging) {
      manifest.logging = defaultProfile.logging;
    }
    
    return manifest;
  }

  /**
   * Validate that a manifest has all required fields
   */
  private validateManifest(manifest: any): manifest is ServiceManifest {
    const required = [
      "name",
      "displayName",
      "description",
      "location",
      "portRange",
      "systemd",
      "healthEndpoint",
      "apiEndpoints",
    ];

    for (const field of required) {
      if (!(field in manifest)) {
        logger.warn(
          `[ServiceDiscovery] Invalid manifest: missing field '${field}'`
        );
        return false;
      }
    }

    // Validate location enum
    if (!["internal", "external"].includes(manifest.location)) {
      logger.warn(
        `[ServiceDiscovery] Invalid manifest: location must be 'internal' or 'external'`
      );
      return false;
    }

    // Validate port range
    if (
      typeof manifest.portRange.start !== "number" ||
      typeof manifest.portRange.end !== "number" ||
      manifest.portRange.start >= manifest.portRange.end
    ) {
      logger.warn(`[ServiceDiscovery] Invalid manifest: invalid portRange`);
      return false;
    }

    return true;
  }

  /**
   * Get a service by name
   */
  getService(name: string): ServiceManifest | undefined {
    return this.services.get(name);
  }

  /**
   * Get all discovered services
   */
  getAllServices(): ServiceManifest[] {
    return Array.from(this.services.values());
  }

  /**
   * Get internal services only
   */
  getInternalServices(): ServiceManifest[] {
    return this.getAllServices().filter((s) => s.location === "internal");
  }

  /**
   * Get external services only
   */
  getExternalServices(): ServiceManifest[] {
    return this.getAllServices().filter((s) => s.location === "external");
  }

  /**
   * Check if a service exists
   */
  hasService(name: string): boolean {
    return this.services.has(name);
  }

  /**
   * Get total count of discovered services
   */
  getServiceCount(): number {
    return this.services.size;
  }

  /**
   * Reload all services (useful for hot-reload scenarios)
   */
  async reload(): Promise<void> {
    logger.info("[ServiceDiscovery] Reloading services...");
    await this.discoverServices();
  }
}

// Singleton instance
const serviceDiscovery = new ServiceDiscovery();

export { serviceDiscovery, ServiceDiscovery };
export default serviceDiscovery;
