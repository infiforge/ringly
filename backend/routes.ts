import { Hono, type Context as HonoContext } from "hono";
import { cors } from "hono/cors";
import { logger as honoLogger } from "hono/logger";
import {
  AllowedRouteTypes,
  type UniversalRoute,
  UniversalRouteMethod,
} from "./interfaces/route.ts";
import { StatusService } from "./module.ts";
import { authRoutes } from "./routes/auth.ts";
import { campaignsRoutes } from "./routes/campaigns.ts";
import { callsRoutes } from "./routes/calls.ts";
import { conversionsRoutes } from "./routes/conversions.ts";
import { numbersRoutes } from "./routes/numbers.ts";
import { sessionsRoutes } from "./routes/sessions.ts";

export class AppRoutes {
  public routes!: Map<string, Array<UniversalRoute>>;
  public app!: Hono;
  private statusService: StatusService;
  private routeCounts!: { http: number; graphql: number; websocket: number };

  constructor(statusService: StatusService) {
    this.statusService = statusService;
    this.routeCounts = { http: 0, graphql: 0, websocket: 0 };
    this.initialize();
  }

  private async initialize() {
    this.app = new Hono();
    this.routes = new Map<string, Array<UniversalRoute>>();
    
    // Register route modules
    this.routes.set("auth", authRoutes);
    this.routes.set("campaigns", campaignsRoutes);
    this.routes.set("calls", callsRoutes);
    this.routes.set("conversions", conversionsRoutes);
    this.routes.set("numbers", numbersRoutes);
    this.routes.set("sessions", sessionsRoutes);
    
    // Register all routes
    this.registerAllRoutes();
  }

  private registerAllRoutes() {
    // CORS middleware
    this.app.use("/*", cors({
      origin: ["*"],
      allowMethods: ["GET", "POST", "PUT", "DELETE", "PATCH", "OPTIONS"],
      allowHeaders: ["Content-Type", "Authorization", "Accept"],
      credentials: true,
    }));

    // Logger middleware
    this.app.use(honoLogger());

    // Register all route modules
    for (const [moduleName, routes] of this.routes.entries()) {
      for (const route of routes) {
        this.registerUniversalRoute(route);
      }
    }
  }

  private registerUniversalRoute(route: UniversalRoute) {
    // Ensure app exists
    if (!this.app) {
      this.app = new Hono();
    }

    // ---- HTTP ----
    const acceptsHttp =
      route.accepts === AllowedRouteTypes.http ||
      (Array.isArray(route.accepts) && route.accepts.includes(AllowedRouteTypes.http)) ||
      (Array.isArray(route.accepts) && route.accepts.includes(AllowedRouteTypes.all));

    if (acceptsHttp && route.paths.http) {
      const method = route.method || UniversalRouteMethod.get;
      const path = route.paths.http;

      // Build handler
      const handler = async (c: HonoContext) => {
        try {
          // Extract input from request
          let input: any = {};
          if (method === UniversalRouteMethod.get || method === UniversalRouteMethod.delete) {
            input = c.req.query() || {};
          } else {
            try {
              input = await c.req.json();
            } catch {
              input = c.req.query() || {};
            }
          }

          // Build context
          const context = {
            req: c.req,
            res: c.res,
            user: c.get("user"),
            db: c.get("db"),
            redis: c.get("redis"),
          };

          // Execute middlewares if any
          if (route.middlewares && route.middlewares.length > 0) {
            for (const mw of route.middlewares) {
              if (mw.parse) await mw.parse(input, context);
              if (mw.execute) await mw.execute(input, context);
            }
          }

          // Execute handler
          const result = await route.func(input, context);

          // Process middlewares if any
          if (route.middlewares && route.middlewares.length > 0) {
            for (const mw of route.middlewares) {
              if (mw.process) await mw.process(input, context);
            }
          }

          return c.json({ success: true, data: result });
        } catch (error: any) {
          console.error(`Error in route ${path}:`, error);
          return c.json(
            { success: false, error: error.message || "Internal server error" },
            500
          );
        }
      };

      // Register route
      switch (method) {
        case UniversalRouteMethod.get:
          this.app.get(path, handler);
          break;
        case UniversalRouteMethod.post:
          this.app.post(path, handler);
          break;
        case UniversalRouteMethod.put:
          this.app.put(path, handler);
          break;
        case UniversalRouteMethod.delete:
          this.app.delete(path, handler);
          break;
        case UniversalRouteMethod.patch:
          this.app.patch(path, handler);
          break;
      }

      this.routeCounts.http++;
      console.log(`[HTTP] ${method.toUpperCase()} ${path} - ${route.description}`);
    }
  }

  getRouteCounts() {
    return { ...this.routeCounts };
  }
}
