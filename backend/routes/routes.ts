import { Hono } from "hono";
import { logger } from "../services/logger.ts";
import {
  AllowedRouteTypes,
  UniversalRoute,
  UniversalRouteMethod,
} from "../interfaces/route.ts";
import { authRoutes } from "./auth.ts";
import { callsRoutes } from "./calls.ts";
import { campaignsRoutes } from "./campaigns.ts";
import { conversionsRoutes } from "./conversions.ts";
import { numbersRoutes } from "./numbers.ts";
import { sessionsRoutes } from "./sessions.ts";

export class AppRoutes {
  public routes!: Map<string, Array<UniversalRoute>>;
  public app!: Hono;
  private routeCounts!: { http: number; graphql: number; websocket: number };

  constructor() {
    this.routeCounts = { http: 0, graphql: 0, websocket: 0 };
    this.initialize();
  }

  private async initialize() {
    this.app = new Hono();
    this.routes = new Map<string, Array<UniversalRoute>>();
    this.routes.set("auth", authRoutes);
    this.routes.set("calls", callsRoutes);
    this.routes.set("campaigns", campaignsRoutes);
    this.routes.set("conversions", conversionsRoutes);
    this.routes.set("numbers", numbersRoutes);
    this.routes.set("sessions", sessionsRoutes);
  }

  public async setupRoutes() {
    // CORS middleware
    this.app.use("*", async (c: any, next: any) => {
      const origin = c.req.header("origin") || "*";
      const acrHeaders = c.req.header("access-control-request-headers") ||
        "Content-Type, Authorization";

      if (c.req.method === "OPTIONS") {
        const h = new Headers();
        h.set("Access-Control-Allow-Origin", origin);
        h.set("Vary", "Origin");
        h.set(
          "Access-Control-Allow-Methods",
          "GET,POST,PUT,PATCH,DELETE,OPTIONS",
        );
        h.set("Access-Control-Allow-Headers", acrHeaders);
        return new Response(null, { status: 204, headers: h });
      }

      await next();

      c.res.headers.set("Access-Control-Allow-Origin", origin);
      c.res.headers.set("Vary", "Origin");
      c.res.headers.set(
        "Access-Control-Allow-Methods",
        "GET,POST,PUT,PATCH,DELETE,OPTIONS",
      );
      c.res.headers.set("Access-Control-Allow-Headers", acrHeaders);
    });

    // Request logging
    this.app.use("*", async (c: any, next: any) => {
      const p = new URL(c.req.url).pathname;
      logger.info(`Request: ${c.req.method} ${p}`);
      await next();
    });

    // Register universal routes
    for (const [, routeArr] of this.routes.entries()) {
      routeArr.forEach((rt) => this.registerUniversalRoute(rt));
    }

    // Health check endpoint
    this.app.get("/health", (c: any) => {
      return c.json({
        status: "ok",
        timestamp: new Date().toISOString(),
        service: "ringly",
      });
    });

    // Root endpoint
    this.app.get("/", (c: any) => {
      return c.json({
        name: "Ringly API",
        version: "1.0.0",
        status: "running",
      });
    });

    // Log route summary
    const summary = `Routes configured: ${this.routeCounts.http} HTTP, ${this.routeCounts.graphql} GraphQL, ${this.routeCounts.websocket} WebSocket`;
    logger.info(summary);
  }

  private registerUniversalRoute(route: UniversalRoute) {
    if (!this.app) {
      this.app = new Hono();
    }

    const acceptsHttp =
      route.accepts === AllowedRouteTypes.http ||
      (Array.isArray(route.accepts) && route.accepts.includes(AllowedRouteTypes.http)) ||
      (Array.isArray(route.accepts) && route.accepts.includes(AllowedRouteTypes.all));

    if (acceptsHttp && route.paths.http) {
      const method = route.method || UniversalRouteMethod.get;
      const path = route.paths.http;

      const handler = async (c: any) => {
        try {
          let payload: any = {};
          if (c.req.method === "GET") {
            const url = new URL(c.req.url);
            payload = Object.fromEntries(url.searchParams.entries());
          } else {
            try { payload = await c.req.json(); } catch { payload = {}; }
          }

          try {
            const params = c.req.param?.() ?? {};
            payload = { ...payload, ...params };
          } catch {
            // ignore
          }

          const ctx: any = {
            user: null,
            http: c,
            request: c.req.raw,
          };

          ctx.req = c.req;
          ctx.url = new URL(c.req.url);
          ctx.params = (() => {
            try {
              return c.req.param?.() ?? {};
            } catch {
              return {};
            }
          })();
          ctx.json = (body: any, status?: number) => c.json(body, status);
          ctx.redirect = (location: string, status?: number) =>
            c.redirect(location, status);

          if (route.middlewares && Array.isArray(route.middlewares)) {
            for (const mw of route.middlewares) {
              if (!mw) continue;
              if (typeof mw.parse === "function") {
                await mw.parse(payload, ctx);
              }
              if (typeof mw.execute === "function") {
                await mw.execute(payload, ctx);
              }
              if (typeof mw.process === "function") {
                await mw.process(payload, ctx);
              }
            }
          }

          const result = await route.func(payload, ctx);
          if (result instanceof Response) {
            return result;
          }
          if (result && typeof result === 'object' && result.__rawResponse instanceof Response) {
            return result.__rawResponse;
          }
          return c.json(result);
        } catch (err) {
          const errorMessage = err instanceof Error ? err.message : String(err);
          logger.error(`Route ${path} error: ${errorMessage}`);
          const status = (err as any)?.status || 500;
          return c.json({ success: false, error: errorMessage }, status);
        }
      };

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
    }

    if (route.paths.ws) {
      this.routeCounts.websocket++;
    }
    if (route.paths.graphql) {
      this.routeCounts.graphql++;
    }
  }
}
