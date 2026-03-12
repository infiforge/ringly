import { MongoClient } from "mongodb";
import { connect } from "redis";
import configFile from "./config.json" with { type: "json" };
import { UploadPipelineService } from "./services/upload-pipeline/service.ts";

// Load configuration
const env = Deno.env.get("ENVIRONMENT") || "default";
const config = configFile[env as keyof typeof configFile] || configFile.default;

const UPLOAD_INTERVAL_MS = config.uploadPipeline?.intervalMs || 300000; // Default: 5 minutes

async function connectDatabases() {
  const mongoUri = config.environment === "local" ? config.mongodb?.uriLocal : config.mongodb?.uriCloud;
  const redisUrl = config.redis?.url;

  if (!mongoUri) {
    throw new Error("MongoDB URI not configured");
  }

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
}

async function runUploadPipeline() {
  const developerToken = config.googleAds?.developerToken;
  const customerId = config.googleAds?.customerId;
  const conversionAction = config.googleAds?.conversionAction;

  if (!developerToken || !customerId || !conversionAction) {
    console.error("Google Ads API credentials not configured");
    return;
  }

  try {
    const { mongo } = await connectDatabases();

    const uploadService = new UploadPipelineService(
      mongo,
      developerToken,
      customerId,
      conversionAction
    );

    console.log("Starting conversion upload pipeline...");
    const results = await uploadService.processPendingConversions();

    if (results.length === 0) {
      console.log("No pending conversions to upload");
    } else {
      console.log(`Processed ${results.length} batches`);
      for (const batch of results) {
        console.log(
          `  Batch ${batch.jobId}: ${batch.status} (${batch.conversions.length} conversions)`
        );
      }
    }
  } catch (error) {
    console.error("Upload pipeline failed:", error);
  }
}

async function main() {
  console.log("CallAttribution Upload Scheduler started");
  console.log(`Upload interval: ${UPLOAD_INTERVAL_MS}ms`);

  // Run immediately on startup
  await runUploadPipeline();

  // Then run on schedule
  setInterval(runUploadPipeline, UPLOAD_INTERVAL_MS);
}

if (import.meta.main) {
  main();
}
