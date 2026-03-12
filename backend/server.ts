import { Hono } from "hono";
import { logger } from "hono/logger";
import { cors } from "hono/cors";
import { MongoClient } from "mongodb";
import { connect } from "redis";
import configFile from "./config.json" with { type: "json" };
import { AppRoutes } from "./routes.ts";
import { StatusService } from "./module.ts";

// Load configuration
const env = Deno.env.get("ENVIRONMENT") || "default";
const config = configFile[env as keyof typeof configFile] || configFile.default;

// Helper to serve static files from www folder
async function serveStaticFile(pathname: string): Promise<Response | null> {
  // Remove leading slash
  const filePath = pathname.replace(/^\//, "");
  const targetPath = filePath || "index.html";

  try {
    const fullUrl = new URL(`./www/${targetPath}`, import.meta.url);
    const file = await Deno.readFile(fullUrl);

    // Determine content type
    const ext = targetPath.split('.').pop()?.toLowerCase() || '';
    const contentTypes: Record<string, string> = {
      html: "text/html; charset=utf-8",
      css: "text/css",
      js: "application/javascript",
      json: "application/json",
      png: "image/png",
      jpg: "image/jpeg",
      jpeg: "image/jpeg",
      gif: "image/gif",
      svg: "image/svg+xml",
      ico: "image/x-icon",
      wasm: "application/wasm",
      otf: "font/otf",
      ttf: "font/ttf",
      woff: "font/woff",
      woff2: "font/woff2",
    };
    const contentType = contentTypes[ext] || "application/octet-stream";

    return new Response(file, {
      headers: {
        "content-type": contentType,
        "cache-control": ext === "html" ? "no-cache" : "public, max-age=86400"
      }
    });
  } catch {
    return null;
  }
}

// Load config values into environment variables for auth/oauth
if (config.jwtSecret) {
  Deno.env.set("JWT_SECRET", config.jwtSecret);
}
// Google OAuth - all platforms
if (config.oauth?.google?.androidClientId) {
  Deno.env.set("GOOGLE_ANDROID_CLIENT_ID", config.oauth.google.androidClientId);
}
if (config.oauth?.google?.iosClientId) {
  Deno.env.set("GOOGLE_IOS_CLIENT_ID", config.oauth.google.iosClientId);
}
if (config.oauth?.google?.webClientId) {
  Deno.env.set("GOOGLE_WEB_CLIENT_ID", config.oauth.google.webClientId);
  Deno.env.set("GOOGLE_CLIENT_ID", config.oauth.google.webClientId);
}
if (config.oauth?.google?.webClientSecret) {
  Deno.env.set("GOOGLE_WEB_CLIENT_SECRET", config.oauth.google.webClientSecret);
}
if (config.oauth?.google?.desktopClientId) {
  Deno.env.set("GOOGLE_DESKTOP_CLIENT_ID", config.oauth.google.desktopClientId);
  Deno.env.set("GOOGLE_CLIENT_ID", config.oauth.google.desktopClientId);
}
if (config.oauth?.google?.desktopClientSecret) {
  Deno.env.set("GOOGLE_DESKTOP_CLIENT_SECRET", config.oauth.google.desktopClientSecret);
  Deno.env.set("GOOGLE_CLIENT_SECRET", config.oauth.google.desktopClientSecret);
}
// Microsoft OAuth
if (config.oauth?.microsoft?.clientId) {
  Deno.env.set("MICROSOFT_CLIENT_ID", config.oauth.microsoft.clientId);
}
if (config.oauth?.microsoft?.tenantId) {
  Deno.env.set("MICROSOFT_TENANT_ID", config.oauth.microsoft.tenantId);
}
if (config.oauth?.microsoft?.clientSecret) {
  Deno.env.set("MICROSOFT_CLIENT_SECRET", config.oauth.microsoft.clientSecret);
}

const app = new Hono();
const port = config.port || 8800;
const appEnv = config.appEnv || "development";

app.use(logger());
app.use(cors({
  origin: appEnv === "production" ? Deno.env.get("ALLOWED_ORIGINS")?.split(",") || [] : "*",
  allowMethods: ["GET", "POST", "PUT", "DELETE", "OPTIONS"],
  allowHeaders: ["Content-Type", "Authorization"],
  credentials: true,
}));

app.get("/health", (c) => {
  return c.json({
    status: "healthy",
    timestamp: new Date().toISOString(),
    environment: appEnv,
  });
});

async function connectDatabases() {
  const mongoUri = config.environment === "local" ? config.mongodb?.uriLocal : config.mongodb?.uriCloud;
  const redisUrl = config.redis?.url;

  if (!mongoUri) {
    console.warn("Warning: MongoDB URI not configured. Running without database connection.");
    return { mongo: null, redis: null };
  }

  try {
    const mongoClient = new MongoClient();
    await mongoClient.connect(mongoUri);
    const dbName = config.mongodb?.database || "ringly";
    const db = mongoClient.database(dbName);
    console.log(`MongoDB connected: ${dbName}`);

    let redisClient = null;
    if (redisUrl) {
      redisClient = await connect({
        hostname: redisUrl.replace("redis://", "").split(":")[0] || "localhost",
        port: parseInt(redisUrl.split(":")[1]) || 6379,
      });
      console.log("Redis connected");
    }

    return { mongo: db, redis: redisClient };
  } catch (error) {
    console.error("Database connection error:", error);
    throw error;
  }
}

if (import.meta.main) {
  try {
    const { mongo, redis } = await connectDatabases();

    // Create AppRoutes - it creates its own Hono instance
    const statusService = new StatusService();
    const appRoutes = new AppRoutes(statusService);

    // Get the Hono app from AppRoutes
    const honoApp = appRoutes.app;

    // Add database context middleware
    honoApp.use(async (c, next) => {
      c.set("db", mongo);
      c.set("redis", redis);
      await next();
    });

    const port = config.port || 8800;
    const hostname = config.host || "0.0.0.0";

    // Use Deno.serve directly for static file serving
    Deno.serve({ port, hostname }, (req: Request) => {
      const url = new URL(req.url);
      const pathname = url.pathname;

      // API routes should be handled by Hono first
      // These include: /graphql, /api/*, /auth/, /health, etc.
      const apiPrefixes = ["/graphql", "/api/", "/auth/", "/ws", "/health"];
      const isApiRoute = apiPrefixes.some(prefix => pathname.startsWith(prefix));

      if (isApiRoute) {
        return honoApp.fetch(req);
      }

      // Static file serving for root path, file-like paths, and non-API routes
      // This handles Flutter web assets: /, /index.html, /assets/, /flutter.js, etc.
      if (pathname === "/" || pathname.match(/\.[a-zA-Z0-9]+$/) || !pathname.startsWith("/api")) {
        return serveStaticFile(pathname).then((staticResponse) => {
          if (staticResponse) {
            return staticResponse;
          }
          // If no static file found and it's not a file-like path, serve index.html (SPA fallback)
          if (!pathname.match(/\.[a-zA-Z0-9]+$/)) {
            return serveStaticFile("index.html").then((indexResponse) => {
              if (indexResponse) {
                return indexResponse;
              }
              // Final fallback to Hono (shouldn't reach here for SPAs)
              return honoApp.fetch(req);
            });
          }
          // Delegate to Hono app if no static file for file-like paths
          return honoApp.fetch(req);
        });
      }

      // Delegate to Hono app for all other requests
      return honoApp.fetch(req);
    });

    console.log(`Ringly server running on http://${hostname}:${port}`);
    console.log(`API endpoints available at /graphql, /api/*, /auth/*`);
    console.log(`Flutter web app served from /www folder`);
    console.log(`Route counts:`, appRoutes.getRouteCounts());
  } catch (error) {
    console.error("Failed to start server:", error);
    Deno.exit(1);
  }
}

export default app;
