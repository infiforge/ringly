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

app.get("/", (c) => {
  return c.json({
    name: "Ringly API",
    version: "1.0.0",
    description: "Self-hosted call attribution system for Google Ads campaigns",
    documentation: "/api/docs",
    health: "/health",
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
    const app = appRoutes.app;
    
    // Add database context middleware
    app.use(async (c, next) => {
      c.set("db", mongo);
      c.set("redis", redis);
      await next();
    });

    // Health check endpoint
    app.get("/health", (c) => {
      return c.json({
        status: "healthy",
        timestamp: new Date().toISOString(),
        service: "Ringly API",
      });
    });

    // Root endpoint
    app.get("/", (c) => {
      return c.json({
        name: "Ringly API",
        version: "1.0.0",
        status: "running",
      });
    });

    const port = config.port || 8800;
    Deno.serve({ port }, app.fetch);
    console.log(`Ringly API running on port ${port}`);
    console.log(`Route counts:`, appRoutes.getRouteCounts());
  } catch (error) {
    console.error("Failed to start server:", error);
    Deno.exit(1);
  }
}

export default app;
