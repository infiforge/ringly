import { configService } from "./services/config-service.ts";
import type { AppConfig } from "./interfaces/config.ts";
import { StatusService } from "./services/status.ts";

// Import modules
import { LoggerModule } from "./modules/logger-module.ts";
import { DatabaseModule } from "./modules/database-module.ts";
import { RoutesModule } from "./modules/routes-module.ts";
import { HttpServerModule } from "./modules/hono-module.ts";
import { logger } from "./services/logger.ts";

// Server initialization
async function main() {
  // Load configuration first
  await configService.load();
  const config = configService.getConfig();

  logger.info("🚀 Starting Ringly Server...");
  logger.info(`📋 Environment: ${config.environment}`);

  const statusService = new StatusService();

  // Initialize modules in order
  const loggerModule = new LoggerModule(statusService);
  statusService.registerModule(loggerModule);
  await loggerModule.init();
  await loggerModule.start();

  const databaseModule = new DatabaseModule(statusService);
  statusService.registerModule(databaseModule);
  await databaseModule.init();
  await databaseModule.start();

  const port = config.port || 8800;
  const hostname = config.host || "0.0.0.0";

  const honoModule = new HttpServerModule(statusService);
  honoModule.setPort(port);
  statusService.registerModule(honoModule);
  await honoModule.init();
  await honoModule.start();

  const routesModule = new RoutesModule(statusService);
  routesModule.setHonoApp(honoModule.getApp()!);
  statusService.registerModule(routesModule);
  await routesModule.init();
  await routesModule.start();

  logger.info(`✅ Ringly server fully initialized`);
  logger.info(`🌐 Server running on http://${hostname}:${port}`);
  logger.info(`🔍 Health check: http://${hostname}:${port}/health`);

  // Handle shutdown
  const shutdown = async () => {
    logger.info("🛑 Shutting down server...");
    await honoModule.stop();
    await routesModule.stop();
    await databaseModule.stop();
    await loggerModule.stop();
    Deno.exit(0);
  };

  Deno.addSignalListener("SIGINT", shutdown);
  Deno.addSignalListener("SIGTERM", shutdown);
}

if (import.meta.main) {
  main().catch((error) => {
    console.error("Failed to start server:", error);
    Deno.exit(1);
  });
}
