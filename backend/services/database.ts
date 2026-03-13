import { MongoClient, Database, ObjectId, Collection } from "mongo";
import { logger } from "./logger.ts";
import type { TorrentDocument } from "../models/torrent.ts";
import { resolve } from "jsr:@std/path";
import { configService } from "./config-service.ts";

export class DatabaseService {
  private static instance: DatabaseService;
  private client: MongoClient | null = null;
  private database: Database | null = null;
  private isConnected = false;
  private reconnectInterval: number;
  private maxReconnectAttempts = 5;
  private runtimeEnvironment: "cloud" | "local";

  /**
   * Sanitizes a MongoDB URI by removing the password for safe logging
   */
  private sanitizeUri(uri: string): string {
    try {
      const url = new URL(uri);
      if (url.password) {
        url.password = "***REDACTED***";
      }
      return url.toString();
    } catch {
      return "[invalid URI]";
    }
  }

  /**
   * Logs detailed connection configuration for debugging
   */
  private logConnectionConfig(params: {
    environment: string;
    targetUri: string;
    dbName: string;
    user?: string;
    hasPassword: boolean;
    authSource?: string;
    certPath?: string;
    useCert: boolean;
  }): void {
    logger.info("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
    logger.info("📋 MongoDB Connection Configuration:");
    logger.info("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
    logger.info(`   Environment: ${params.environment}`);
    logger.info(`   Database: ${params.dbName}`);
    logger.info(
      `   Authentication Method: ${
        params.useCert ? "X.509 Certificate" : "Username/Password"
      }`,
    );
    if (params.useCert) {
      logger.info(`   Certificate Path: ${params.certPath || "(not set)"}`);
      if (params.certPath) {
        try {
          const certExists = Deno.statSync(params.certPath).isFile;
          logger.info(
            `   Certificate Exists: ${certExists ? "✅ Yes" : "❌ No"}`,
          );
        } catch {
          logger.info(`   Certificate Exists: ❌ No (file not found)`);
        }
      }
    } else {
      logger.info(`   User: ${params.user || "(none)"}`);
      logger.info(`   Password: ${params.hasPassword ? "(set)" : "(not set)"}`);
      logger.info(`   Auth Source: ${params.authSource || "(default)"}`);
    }
    logger.info(`   URI: ${this.sanitizeUri(params.targetUri)}`);
    logger.info("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
  }

  /**
   * Logs detailed error information when connection fails
   */
  private logConnectionError(error: unknown, context: {
    attempt: number;
    maxAttempts: number;
    environment: string;
    dbName: string;
    targetUri: string;
    user?: string;
    certPath?: string;
    useCert: boolean;
  }): void {
    logger.error("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
    logger.error(
      `❌ DATABASE CONNECTION FAILED (Attempt ${context.attempt}/${context.maxAttempts})`,
    );
    logger.error("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");

    // Extract error message
    const errorMessage = error instanceof Error ? error.message : String(error);
    const errorName = error instanceof Error ? error.name : "Error";

    // Detect specific error types and provide actionable guidance
    if (
      errorMessage.includes("received fatal alert: InternalError") ||
      errorMessage.includes("InvalidData") ||
      errorMessage.includes("TLS alert")
    ) {
      logger.error("\n🔐 TLS/CONNECTION ERROR DETECTED");
      logger.error("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
      logger.error(`Error: ${errorMessage}`);
      logger.error("");
      logger.error("💡 POSSIBLE CAUSES (in order of likelihood):");
      logger.error("   1. ⚠️  IP address NOT whitelisted in MongoDB Atlas");
      logger.error("   2. Certificate file is invalid or expired");
      logger.error(
        "   3. Certificate format is incorrect (should be PEM format)",
      );
      logger.error("   4. TLS version mismatch between client and server");
      logger.error("");
      logger.error("🔧 SUGGESTED FIXES:");
      logger.error("   PRIMARY: Check IP Whitelist in MongoDB Atlas");
      logger.error("     1. Go to: https://cloud.mongodb.com/v2");
      logger.error("     2. Navigate to: Security → Network Access");
      logger.error("     3. Verify your IP address is in the whitelist");
      logger.error(
        "     4. If missing, add it or use 0.0.0.0/0 for development",
      );
      logger.error("");
      logger.error("   SECONDARY: Verify Certificate (if using X.509)");
      if (context.useCert && context.certPath) {
        logger.error(`     • Certificate path: ${context.certPath}`);
        logger.error("     • Ensure certificate is in PEM format");
        logger.error(
          "     • Try downloading a fresh certificate from MongoDB Atlas",
        );
        logger.error("     • Verify certificate file is readable");
      }
    } else if (
      errorMessage.includes("Authentication failed") ||
      errorMessage.includes("auth failed")
    ) {
      logger.error("\n🔑 AUTHENTICATION ERROR");
      logger.error("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
      logger.error(`Error: ${errorMessage}`);
      logger.error("");
      logger.error("💡 POSSIBLE CAUSES:");
      logger.error("   1. Incorrect username or password");
      logger.error(
        "   2. User doesn't exist in the specified authSource database",
      );
      logger.error(
        "   3. User doesn't have permissions for the target database",
      );
      logger.error("");
      logger.error("🔧 SUGGESTED FIXES:");
      logger.error("   • Verify MONGO_USER and MONGO_PASS in .env file");
      logger.error(
        "   • Ensure user exists in admin database (authSource=admin)",
      );
      logger.error("   • Check user has dbOwner role for target database");
    } else if (
      errorMessage.includes("ECONNREFUSED") ||
      errorMessage.includes("connection refused")
    ) {
      logger.error("\n🔌 CONNECTION REFUSED");
      logger.error("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
      logger.error(`Error: ${errorMessage}`);
      logger.error("");
      logger.error("💡 POSSIBLE CAUSES:");
      logger.error("   1. MongoDB server is not running");
      logger.error("   2. Wrong host or port in connection string");
      logger.error("   3. Firewall blocking the connection");
      logger.error("");
      logger.error("🔧 SUGGESTED FIXES:");
      logger.error("   • Start MongoDB service");
      logger.error("   • Verify MONGO_URI or MONGO_HOST/MONGO_PORT in .env");
      logger.error("   • Check firewall settings");
    } else if (
      errorMessage.includes("failed to lookup address") ||
      errorMessage.includes("name resolution") ||
      errorMessage.includes("ENOTFOUND")
    ) {
      logger.error("\n🌐 DNS RESOLUTION ERROR");
      logger.error("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
      logger.error(`Error: ${errorMessage}`);
      logger.error("");
      logger.error("💡 POSSIBLE CAUSES:");
      logger.error("   1. No internet connection");
      logger.error("   2. Invalid hostname in connection string");
      logger.error("   3. DNS server issues");
      logger.error("");
      logger.error("🔧 SUGGESTED FIXES:");
      logger.error("   • Check internet connection");
      logger.error("   • Verify hostname in MONGO_URI or CLOUD_MONGO_URI");
      logger.error("   • Try using IP address instead of hostname");
    } else if (
      errorMessage.includes("not allowed") ||
      errorMessage.includes("IP address") ||
      errorMessage.includes("whitelist")
    ) {
      logger.error("\n🔒 IP WHITELISTING ERROR (MongoDB Atlas)");
      logger.error("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
      logger.error(`Error: ${errorMessage}`);
      logger.error("");
      logger.error("💡 PROBLEM:");
      logger.error("   Your IP address is not whitelisted in MongoDB Atlas");
      logger.error("");
      logger.error("🔧 SOLUTION:");
      logger.error("   1. Go to MongoDB Atlas Dashboard");
      logger.error("   2. Navigate to: Network Access > IP Whitelist");
      logger.error("   3. Click 'Add IP Address'");
      logger.error(
        "   4. Add your current IP address or use 0.0.0.0/0 for all IPs",
      );
      logger.error("   5. Retry the connection");
      logger.error("");
      logger.error("⚠️  SECURITY NOTE:");
      logger.error(
        "   Using 0.0.0.0/0 opens access to anyone - only use for development!",
      );
      logger.error(
        "   For production, whitelist specific IP addresses or CIDR ranges",
      );
    } else {
      // Generic error logging
      logger.error("\n❌ ERROR DETAILS:");
      logger.error(`   Name: ${errorName}`);
      logger.error(`   Message: ${errorMessage}`);
      if (error instanceof Error && error.stack) {
        logger.error("\n📚 Stack Trace:");
        error.stack.split("\n").slice(0, 5).forEach((line) =>
          logger.error(`   ${line}`)
        );
      }
    }

    // Log connection context
    logger.error("\n📊 Connection Context:");
    logger.error(`   Environment: ${context.environment}`);
    logger.error(`   Target Database: ${context.dbName}`);
    logger.error(`   Target URI: ${this.sanitizeUri(context.targetUri)}`);
    logger.error(`   Username: ${context.user || "(none)"}`);

    // Log environment variables
    logger.error("\n🔧 Environment Variables:");
    logger.error(
      `   ENVIRONMENT: ${Deno.env.get("ENVIRONMENT") || "(not set)"}`,
    );
    logger.error(
      `   MONGODB_DATABASE: ${
        Deno.env.get("MONGODB_DATABASE") || Deno.env.get("MONGO_DB") ||
        "(not set)"
      }`,
    );
    logger.error(
      `   Authentication Method: ${
        context.useCert ? "Certificate" : "Username/Password"
      }`,
    );
    if (context.useCert) {
      logger.error(
        `   MONGODB_CERT_LOCAL: ${
          Deno.env.get("MONGODB_CERT_LOCAL") ||
          Deno.env.get("MONGO_DB_CERT_LOCAL") || "(not set)"
        }`,
      );
      logger.error(
        `   MONGODB_CERT_CLOUD: ${
          Deno.env.get("MONGODB_CERT_CLOUD") ||
          Deno.env.get("MONGO_DB_CERT_CLOUD") || "(not set)"
        }`,
      );
      logger.error(`   Certificate Path Used: ${context.certPath || "(none)"}`);
    } else {
      logger.error(
        `   MONGODB_USER: ${
          Deno.env.get("MONGODB_USER") || Deno.env.get("MONGO_USER") ||
          "(not set)"
        }`,
      );
      logger.error(
        `   MONGODB_PASSWORD: ${
          Deno.env.get("MONGODB_PASSWORD") || Deno.env.get("MONGO_PASSWORD")
            ? "(set)"
            : "(not set)"
        }`,
      );
    }
    logger.error(
      `   MONGODB_URI_LOCAL: ${
        Deno.env.get("MONGODB_URI_LOCAL") || "(not set)"
      }`,
    );
    logger.error(
      `   MONGODB_URI_CLOUD: ${
        Deno.env.get("MONGODB_URI_CLOUD") ? "(set)" : "(not set)"
      }`,
    );

    // Provide diagnostic hints
    logger.error("\n💡 Diagnostic Hints:");
    if (context.useCert) {
      if (!context.certPath) {
        logger.error("   ⚠️  Certificate path not configured");
        logger.error(
          "   💡 Set MONGODB_CERT_CLOUD in .env for cloud environment",
        );
        logger.error(
          "   💡 Set MONGODB_CERT_LOCAL in .env for local environment",
        );
      } else {
        try {
          const certStat = Deno.statSync(context.certPath);
          logger.error(`   ✅ Certificate file found (${certStat.size} bytes)`);
        } catch {
          logger.error(
            `   ⚠️  Certificate file not found: ${context.certPath}`,
          );
          logger.error("   💡 Verify the certificate path is correct");
          logger.error("   💡 Use absolute path instead of relative path");
        }
      }
      if (error instanceof Error && error.message.includes("certificate")) {
        logger.error("   ⚠️  Certificate validation failed");
        logger.error("   💡 Ensure certificate is in PEM format");
        logger.error("   💡 Verify certificate is not expired");
      }
    } else {
      const hasUser = Deno.env.get("MONGODB_USER") ||
        Deno.env.get("MONGO_USER");
      const hasPass = Deno.env.get("MONGODB_PASSWORD") ||
        Deno.env.get("MONGO_PASSWORD");
      if (!hasUser || !hasPass) {
        logger.error(
          "   ⚠️  MongoDB credentials not set (MONGODB_USER/MONGODB_PASSWORD)",
        );
        if (context.environment === "cloud") {
          logger.error(
            "   💡 For cloud: Use certificate authentication (MONGODB_CERT_CLOUD)",
          );
        }
      }
    }
    if (
      error instanceof Error && error.message.includes("Authentication failed")
    ) {
      logger.error("   ⚠️  Authentication failed - check username/password");
      logger.error(
        "   ⚠️  Verify user exists in MongoDB with correct permissions",
      );
      logger.error("   ⚠️  Verify authSource is correct (current: admin)");
      logger.error(
        "   ⚠️  User should be created in 'admin' database, not '" +
          context.dbName + "'",
      );
    }
    if (error instanceof Error && error.message.includes("ECONNREFUSED")) {
      logger.error(
        "   ⚠️  Connection refused - MongoDB service may not be running",
      );
      logger.error(
        "   ⚠️  Check if MongoDB is started: sudo systemctl status mongod",
      );
    }
    if (error instanceof Error && error.message.includes("ENOTFOUND")) {
      logger.error("   ⚠️  Hostname not found - check MongoDB host address");
    }
    if (error instanceof Error && error.message.includes("ETIMEDOUT")) {
      logger.error("   ⚠️  Connection timeout - MongoDB may be unreachable");
      logger.error("   ⚠️  Check firewall settings and network connectivity");
    }
    logger.error("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n");
  }

  private constructor() {
    // Defer reading environment variables until initializeFromEnv() is called by server
    this.reconnectInterval = 5000; // default 5 seconds
    this.runtimeEnvironment = "local";
  }

  /**
   * Initialize environment-dependent settings. Should be called after Deno.env is populated.
   */
  public initializeFromEnv(): void {
    this.reconnectInterval =
      parseInt(Deno.env.get("DB_RECONNECT_TIME_SECONDS") || "5", 10) * 1000;
    const env = Deno.env.get("ENVIRONMENT")?.toLowerCase();
    this.runtimeEnvironment = env === "cloud" ? "cloud" : "local";
    logger.info(`Database runtime environment: ${this.runtimeEnvironment}`);
  }

  public static getInstance(): DatabaseService {
    if (!DatabaseService.instance) {
      DatabaseService.instance = new DatabaseService();
    }
    return DatabaseService.instance;
  }

  public async connect(): Promise<boolean> {
    let attempts = 0;
    let connected = false;
    let lastError: Error | null = null;
    let connectionMethodUsed: string = "none";

    // Print a clear header for the connection attempt
    logger.info("");
    logger.info("╔══════════════════════════════════════════════════════════════╗");
    logger.info("║           DATABASE CONNECTION INITIALIZATION                 ║");
    logger.info("╚══════════════════════════════════════════════════════════════╝");

    while (!connected && attempts < this.maxReconnectAttempts) {
      if (attempts > 0) {
        logger.info(
          `Database reconnection attempt ${attempts} of ${this.maxReconnectAttempts}...`,
        );
        await new Promise((resolve) =>
          setTimeout(resolve, this.reconnectInterval)
        );
      }

      // Resolve runtime environment at connection time (after .env load)
      const env = Deno.env.get("ENVIRONMENT")?.toLowerCase();
      this.runtimeEnvironment = env === "cloud" ? "cloud" : "local";

      // Get config from configService
      const config = configService.getConfig();
      const mongoConfig = config.mongodb;

      // Single attempt body - read from config instead of env vars
      const cloudDbUri = mongoConfig?.uri;
      const localDbUri = "mongodb://127.0.0.1:27017";

      // Certificate paths from config
      const cloudCertPath = mongoConfig?.cert || undefined;
      const localCertPath = undefined; // Local typically doesn't use certs

      // Username/password for local authentication (from config)
      const user = mongoConfig?.user;
      const pass = mongoConfig?.password;

      // Extract database name from URI or use default
      let dbName = "ringly";
      try {
        const uriToParse = this.runtimeEnvironment === "cloud" ? cloudDbUri : localDbUri;
        if (uriToParse) {
          const url = new URL(uriToParse);
          const pathDb = url.pathname.replace(/^\//, "");
          if (pathDb) dbName = pathDb;
        }
      } catch {
        // Use default
      }

      let targetUri: string | undefined;
      if (this.runtimeEnvironment === "cloud") {
        targetUri = cloudDbUri;
        if (!targetUri) {
          logger.error(
            "MONGODB_URI_CLOUD is not set for cloud environment. Cannot connect.",
          );
          attempts++;
          continue;
        }
      } else if (this.runtimeEnvironment === "local") {
        targetUri = localDbUri;
        if (!targetUri) {
          logger.error(
            "MONGODB_URI_LOCAL is not set for local environment. Cannot connect.",
          );
          attempts++;
          continue;
        }
      } else {
        // This case should ideally not be reached if runtimeEnvironment is strictly 'local' or 'cloud'
        logger.error(
          `Unknown runtime environment: ${this.runtimeEnvironment}. Cannot connect.`,
        );
        attempts++;
        continue;
      }

      try {
        logger.info(`🔌 Attempting MongoDB connection...`);

        // Determine authentication method and certificate path
        let certPath: string | undefined;
        let useCert = false;

        if (this.runtimeEnvironment === "cloud") {
          // Cloud: ONLY use certificate authentication
          certPath = cloudCertPath;
          useCert = !!certPath;

          if (!certPath) {
            logger.error("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
            logger.error("❌ CLOUD ENVIRONMENT: Certificate Required");
            logger.error("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
            logger.error("   MONGODB_CERT_CLOUD is not set in .env");
            logger.error(
              "   Cloud connections require certificate authentication",
            );
            logger.error(
              "   Please set: MONGODB_CERT_CLOUD=/path/to/cloud-db-cert.pem",
            );
            logger.error("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
            attempts++;
            continue;
          }

          // Resolve relative path to absolute (relative to backend directory where .env is)
          if (certPath.startsWith("./") || certPath.startsWith("../")) {
            const backendDir = Deno.cwd();
            certPath = resolve(backendDir, certPath);
            logger.info(
              `📍 Resolved relative certificate path to: ${certPath}`,
            );
            logger.info(`   (relative to: ${backendDir})`);
          }
        } else {
          // Local: Use certificate if available, otherwise username/password
          certPath = localCertPath;
          useCert = !!certPath;

          if (
            certPath &&
            (certPath.startsWith("./") || certPath.startsWith("../"))
          ) {
            const backendDir = Deno.cwd();
            certPath = resolve(backendDir, certPath);
            logger.info(
              `📍 Resolved relative certificate path to: ${certPath}`,
            );
            logger.info(`   (relative to: ${backendDir})`);
          }
        }

        // Log connection configuration
        this.logConnectionConfig({
          environment: this.runtimeEnvironment,
          targetUri: targetUri || "unknown",
          dbName,
          user,
          hasPassword: !!pass,
          authSource: "admin",
          certPath,
          useCert,
        });

        // Build connection options for Deno Mongo driver
        let clientOptions: { tls?: boolean; tlsCertificateKeyFile?: string } = {};

        // Use connection string format with certificate or credentials
        if (this.runtimeEnvironment === "cloud") {
          // For cloud (Atlas), use connection string format
          if (!targetUri) {
            logger.error(
              "No valid MongoDB URI found for cloud environment. Cannot connect.",
            );
            attempts++;
            continue;
          }

          if (useCert && certPath) {
            logger.info(
              "🔐 Using X.509 certificate authentication for cloud...",
            );

            // Verify certificate file exists
            try {
              const certStat = await Deno.stat(certPath);
              logger.info(
                `✅ Certificate found: ${certPath} (${certStat.size} bytes)`,
              );
            } catch (certError) {
              logger.error(`❌ Failed to read certificate: ${certError}`);
              throw new Error(
                `Certificate file not found or unreadable: ${certPath}`,
              );
            }

            // For MongoDB Atlas with npm driver, use tlsCertificateKeyFile option
            // This is the standard way MongoDB Compass and other tools use
            clientOptions = {
              tls: true,
              tlsCertificateKeyFile: certPath,
            };

            logger.info("🔗 Connecting to MongoDB Atlas with TLS...");
            this.client = new MongoClient();
            try {
              await this.client.connect(targetUri);
            } catch (connectError) {
              const errMsg = connectError instanceof Error
                ? connectError.message
                : String(connectError);
              logger.error(`❌ Connection failed: ${errMsg}`);
              throw connectError;
            }
          } else {
            logger.info(
              "🔑 Using connection string authentication for cloud...",
            );
            this.client = new MongoClient();
            try {
              await this.client.connect(targetUri);
            } catch (connectError) {
              const errMsg = connectError instanceof Error
                ? connectError.message
                : String(connectError);
              logger.error(`❌ Connection failed: ${errMsg}`);
              throw connectError;
            }
          }
        } else {
          // For local, build connection string with certificate or credentials
          const url = new URL(targetUri || "mongodb://localhost:27017");
          const host = url.hostname;
          const port = url.port ? parseInt(url.port, 10) : 27017;

          if (useCert && certPath) {
            logger.info(
              "🔐 Using X.509 certificate authentication for local...",
            );

            // Verify certificate file exists
            try {
              const certStat = await Deno.stat(certPath);
              logger.info(
                `✅ Certificate found: ${certPath} (${certStat.size} bytes)`,
              );
            } catch (certError) {
              logger.error(`❌ Failed to read certificate: ${certError}`);
              throw new Error(
                `Certificate file not found or unreadable: ${certPath}`,
              );
            }

            // For local MongoDB with certificate, use connection string with TLS options
            const connectionString =
              `mongodb://${host}:${port}/${dbName}`;
            clientOptions = {
              tls: true,
              tlsCertificateKeyFile: certPath,
            };

            logger.info(
              "🔗 Connecting to local MongoDB with TLS certificate...",
            );
            this.client = new MongoClient();
            await this.client.connect(connectionString);
          } else if (user && pass) {
            logger.info(
              "🔑 Using username/password authentication for local...",
            );

            // URL encode the username and password to handle special characters
            const encodedUser = encodeURIComponent(user);
            const encodedPass = encodeURIComponent(pass);

            // Build connection string with credentials and authSource=admin
            const connectionString =
              `mongodb://${encodedUser}:${encodedPass}@${host}:${port}/${dbName}?authSource=admin`;

            // Log the connection string (with password obfuscated)
            const sanitizedConnectionString = connectionString.replace(
              /:([^@]+)@/,
              ":***@",
            );
            logger.info(
              `📝 Final Connection String: ${sanitizedConnectionString}`,
            );

            this.client = new MongoClient();
            await this.client.connect(connectionString);
          } else {
            logger.info(
              "🔓 Connecting without authentication (local development)...",
            );
            logger.info("   No certificate or username/password provided");
            logger.info("   Attempting direct connection to MongoDB...");

            // For local without auth, use the targetUri directly
            // The database name will be specified when getting the database object
            // Parse the URI to ensure it's valid, but use it as-is for connection
            let connectionString: string;
            try {
              // Validate the URI format
              const uriObj = new URL(targetUri);
              // Use the original targetUri to preserve any existing path/query params
              connectionString = targetUri;
            } catch {
              // If URI parsing fails, build a simple connection string
              connectionString = `mongodb://${host}:${port}`;
            }
            logger.info(`📝 Final Connection String: ${connectionString}`);

            this.client = new MongoClient();
            await this.client.connect(connectionString);
          }
        }

        this.database = this.client.database(dbName);
        this.isConnected = true;

        // Ensure required collections exist
        await this.initializeCollections();

        // Set connection method for summary
        if (useCert) {
          connectionMethodUsed = "X.509 Certificate";
        } else if (user) {
          connectionMethodUsed = "Username/Password";
        } else {
          connectionMethodUsed = "No Authentication (Local Dev)";
        }

        logger.info("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
        logger.info(`✅ Successfully connected to MongoDB database: ${dbName}`);
        logger.info(`   Environment: ${this.runtimeEnvironment}`);
        logger.info(
          `   Auth Method: ${
            useCert
              ? "X.509 Certificate"
              : (user ? "Username/Password" : "None")
          }`,
        );
        logger.info("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
        connected = true;
      } catch (error) {
        lastError = error instanceof Error ? error : new Error(String(error));
        const certPath = this.runtimeEnvironment === "cloud"
          ? cloudCertPath
          : localCertPath;
        this.logConnectionError(error, {
          attempt: attempts + 1,
          maxAttempts: this.maxReconnectAttempts,
          environment: this.runtimeEnvironment,
          dbName,
          targetUri: targetUri || "unknown",
          user,
          certPath,
          useCert: !!certPath,
        });
        this.isConnected = false;
        attempts++;

        // Wait before retrying (exponential backoff)
        if (attempts < this.maxReconnectAttempts) {
          const waitTime = Math.min(1000 * Math.pow(2, attempts), 10000);
          logger.info(`⏳ Waiting ${waitTime}ms before retry...`);
          await new Promise((resolve) => setTimeout(resolve, waitTime));
        }
      }
    }

    if (!connected) {
      logger.error("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
      logger.error(`❌ ALL CONNECTION ATTEMPTS EXHAUSTED`);
      logger.error(`   Failed after ${this.maxReconnectAttempts} attempts`);
      logger.error(
        `   Server will continue but database features are disabled`,
      );
      logger.error("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n");
    }

    // Print final summary
    logger.info("");
    logger.info("╔══════════════════════════════════════════════════════════════╗");
    if (connected) {
      const finalDbName = this.database?.databaseName || "unknown";
      logger.info("║  ✅ DATABASE CONNECTION: SUCCESS                            ║");
      logger.info("╠══════════════════════════════════════════════════════════════╣");
      logger.info(`║  Database:    ${(finalDbName).padEnd(45)}║`);
      logger.info(`║  Environment:  ${(this.runtimeEnvironment || "unknown").padEnd(45)}║`);
      logger.info(`║  Auth Method:  ${connectionMethodUsed.padEnd(45)}║`);
      logger.info(`║  Status:       ${"Connected and ready for operations".padEnd(45)}║`);
    } else {
      const errorMsg = lastError?.message?.substring(0, 40) || "Unknown error";
      logger.info("║  ❌ DATABASE CONNECTION: FAILED                             ║");
      logger.info("╠══════════════════════════════════════════════════════════════╣");
      logger.info(`║  Attempts:    ${String(attempts).padEnd(45)}║`);
      logger.info(`║  Last Error:   ${errorMsg.padEnd(45)}║`);
      logger.info(`║  Status:       ${"Running without database features".padEnd(45)}║`);
    }
    logger.info("╚══════════════════════════════════════════════════════════════╝");
    logger.info("");

    return connected;
  }

  /**
   * Alias for connect() - provides the same functionality with retries
   * This method exists for backward compatibility with services that call connectWithRetries
   */
  public async connectWithRetries(): Promise<boolean> {
    return this.connect();
  }

  public getConnectionStatus(): boolean {
    return this.isConnected;
  }

  public getDatabase(): Database | null {
    return this.database;
  }

  public isDBConnected(): boolean {
    return this.isConnected;
  }

  /**
   * Get the user activities collection
   */
  public getUserActivitiesCollection(): Collection<any> | null {
    if (!this.database) {
      logger.warn("Database not connected when accessing user-activities collection");
      return null;
    }
    return this.database.collection("user-activities");
  }

  /**
   * Initialize required database collections
   * Ensures collections exist for activity tracking and other features
   */
  private async initializeCollections(): Promise<void> {
    if (!this.database) return;

    try {
      // List existing collections
      const collections = await this.database.listCollections().toArray();
      const collectionNames = collections.map((c) => c.name);

      // Create user-activities collection if it doesn't exist
      if (!collectionNames.includes("user-activities")) {
        await this.database.createCollection("user-activities");
        logger.info("📁 Created user-activities collection");

        // Create indexes for user-activities
        await this.database.collection("user-activities").createIndex(
          { userId: 1 },
        );
        await this.database.collection("user-activities").createIndex(
          { timestamp: -1 },
        );
        await this.database.collection("user-activities").createIndex(
          { activityType: 1 },
        );
        logger.info("📇 Created indexes for user-activities collection");
      }
    } catch (error) {
      logger.error("Failed to initialize collections:", error);
    }
  }

  public async saveCloudProviderTokens(
    userId: string,
    provider: string,
    tokens: Record<string, any>,
  ): Promise<boolean> {
    try {
      if (!this.database) {
        logger.error("Database not connected");
        return false;
      }
      const usersCollection = this.database.collection("users");
      const result = await usersCollection.updateOne(
        { _id: new ObjectId(userId) },
        {
          $set: {
            [`connectedProviders.${provider}.tokens`]: tokens,
            [`connectedProviders.${provider}.connected`]: true,
          },
        },
      );
      return result > 0 || result !== undefined;
    } catch (error) {
      logger.error(
        `Error saving cloud provider tokens for user ${userId}:`,
        error,
      );
      return false;
    }
  }

  public async getCloudProviderTokens(
    userId: string,
    provider: string,
  ): Promise<Record<string, any> | null> {
    try {
      if (!this.database) {
        logger.error("Database not connected");
        return null;
      }
      const usersCollection = this.database.collection("users");
      const user = await usersCollection.findOne({ _id: new ObjectId(userId) });
      if (!user) {
        logger.warn(`User ${userId} not found`);
        return null;
      }
      const connectedProviders = (user as any).connectedProviders || {};
      const providerEntry = connectedProviders[provider];
      if (!providerEntry) return null;

      // Multi-account shape: connectedProviders[provider].accounts + activeAccount
      const activeAccount = (providerEntry as any).activeAccount as string | undefined;
      const accounts = (providerEntry as any).accounts as Record<string, any> | undefined;
      if (accounts && typeof accounts === 'object') {
        const active = activeAccount && accounts[activeAccount]
          ? accounts[activeAccount]
          : null;
        const first = !active
          ? (Object.values(accounts)[0] as any | undefined)
          : undefined;
        const selected = active ?? first;
        if (selected?.tokens) return selected.tokens as Record<string, any>;
      }

      // Legacy shape: connectedProviders[provider].tokens
      return (providerEntry as any)?.tokens || null;
    } catch (error) {
      logger.error(
        `Error retrieving cloud provider tokens for user ${userId}:`,
        error,
      );
      return null;
    }
  }

  public async upsertOAuthUser(profile: {
    email: string;
    firstName?: string;
    lastName?: string;
    fullName?: string;
    provider: string;
    providerId: string;
    photoUrl?: string;
  }): Promise<{ _id: ObjectId; email: string; firstName?: string; lastName?: string; fullName?: string; photoUrl?: string; provider?: string; providerId?: string; } | null> {
    try {
      if (!this.database) {
        logger.error("Database not connected");
        return null;
      }
      const usersCollection = this.database.collection("users");
      
      // Find existing user by email
      const existingUser = await usersCollection.findOne({ email: profile.email });
      
      if (existingUser) {
        // Update existing user with OAuth info
        const updateResult = await usersCollection.updateOne(
          { _id: existingUser._id },
          {
            $set: {
              firstName: profile.firstName || existingUser.firstName,
              lastName: profile.lastName || existingUser.lastName,
              fullName: profile.fullName || existingUser.fullName,
              photoUrl: profile.photoUrl || existingUser.photoUrl,
              provider: profile.provider,
              providerId: profile.providerId,
              updatedAt: new Date(),
            },
          }
        );
        
        if (updateResult > 0) {
          const updated = await usersCollection.findOne({ _id: existingUser._id });
          if (updated) {
            return {
              _id: updated._id as ObjectId,
              email: updated.email as string,
              firstName: updated.firstName as string,
              lastName: updated.lastName as string,
              fullName: updated.fullName as string,
              photoUrl: updated.photoUrl as string,
              provider: updated.provider as string,
              providerId: updated.providerId as string,
            };
          }
        }
        return null;
      } else {
        // Create new user with admin role and allowed by default
        const newUser = {
          email: profile.email,
          firstName: profile.firstName,
          lastName: profile.lastName,
          fullName: profile.fullName,
          photoUrl: profile.photoUrl,
          provider: profile.provider,
          providerId: profile.providerId,
          role: "admin",
          allowed: true, // All users are admins and allowed by default
          createdAt: new Date(),
          updatedAt: new Date(),
        };
        
        const insertResult = await usersCollection.insertOne(newUser);
        
        if (insertResult) {
          return {
            _id: insertResult,
            email: profile.email,
            firstName: profile.firstName,
            lastName: profile.lastName,
            fullName: profile.fullName,
            photoUrl: profile.photoUrl,
            provider: profile.provider,
            providerId: profile.providerId,
          };
        }
        return null;
      }
    } catch (error) {
      logger.error("Error upserting OAuth user:", error);
      return null;
    }
  }

  public async close(): Promise<void> {
    if (this.client) {
      await this.client.close();
      this.client = null;
      this.database = null;
      this.isConnected = false;
      logger.info("Database connection closed");
    }
  }

  /**
   * Find a user by email and return with allowed status
   */
  public async findUserByEmail(email: string): Promise<{ _id: ObjectId; email: string; firstName?: string; lastName?: string; fullName?: string; photoUrl?: string; provider?: string; providerId?: string; allowed?: boolean } | null> {
    try {
      if (!this.database) {
        logger.error("Database not connected");
        return null;
      }
      const usersCollection = this.database.collection("users");
      const user = await usersCollection.findOne({ email });
      
      if (!user) return null;
      
      return {
        _id: user._id as ObjectId,
        email: user.email as string,
        firstName: user.firstName as string,
        lastName: user.lastName as string,
        fullName: user.fullName as string,
        photoUrl: user.photoUrl as string,
        provider: user.provider as string,
        providerId: user.providerId as string,
        allowed: user.allowed as boolean,
      };
    } catch (error) {
      logger.error(`Error finding user by email ${email}:`, error);
      return null;
    }
  }

  /**
   * Find a user by ID and return with allowed status
   */
  public async findUserById(userId: string): Promise<{ _id: ObjectId; email: string; firstName?: string; lastName?: string; fullName?: string; photoUrl?: string; provider?: string; providerId?: string; allowed?: boolean; role?: string } | null> {
    try {
      if (!this.database) {
        logger.error("Database not connected");
        return null;
      }
      const usersCollection = this.database.collection("users");
      const user = await usersCollection.findOne({ _id: new ObjectId(userId) });
      
      if (!user) return null;
      
      return {
        _id: user._id as ObjectId,
        email: user.email as string,
        firstName: user.firstName as string,
        lastName: user.lastName as string,
        fullName: user.fullName as string,
        photoUrl: user.photoUrl as string,
        provider: user.provider as string,
        providerId: user.providerId as string,
        allowed: user.allowed as boolean,
        role: user.role as string,
      };
    } catch (error) {
      logger.error(`Error finding user by id ${userId}:`, error);
      return null;
    }
  }

  /**
   * Create an access request for a new user
   */
  public async createAccessRequest(requestData: {
    email: string;
    firstName?: string;
    lastName?: string;
    fullName?: string;
    photoUrl?: string;
    provider: string;
    providerId: string;
  }): Promise<{ _id: ObjectId } | null> {
    try {
      if (!this.database) {
        logger.error("Database not connected");
        return null;
      }
      const accessRequestsCollection = this.database.collection("access_requests");
      
      // Check if there's already a pending request
      const existingRequest = await accessRequestsCollection.findOne({
        email: requestData.email,
        status: "pending",
      });
      
      if (existingRequest) {
        return { _id: existingRequest._id as ObjectId };
      }
      
      const newRequest = {
        ...requestData,
        status: "pending",
        requestedAt: new Date(),
      };
      
      const result = await accessRequestsCollection.insertOne(newRequest);
      
      if (result) {
        logger.info(`Access request created for ${requestData.email}`);
        return { _id: result };
      }
      return null;
    } catch (error) {
      logger.error("Error creating access request:", error);
      return null;
    }
  }

  /**
   * Check if there's a pending access request for an email
   */
  public async hasPendingAccessRequest(email: string): Promise<boolean> {
    try {
      if (!this.database) {
        logger.error("Database not connected");
        return false;
      }
      const accessRequestsCollection = this.database.collection("access_requests");
      const existingRequest = await accessRequestsCollection.findOne({
        email,
        status: "pending",
      });
      return !!existingRequest;
    } catch (error) {
      logger.error(`Error checking access request for ${email}:`, error);
      return false;
    }
  }
}

export const database = DatabaseService.getInstance();

export type { TorrentDocument };
