import type { Database } from "mongodb";
import type { ConversionEvent } from "../attribution-engine/service.ts";

export interface UploadBatch {
  jobId: number;
  conversions: ConversionEvent[];
  status: "pending" | "uploading" | "completed" | "partial" | "failed";
  results?: UploadResult[];
  errorMessage?: string;
  createdAt: Date;
  completedAt?: Date;
}

export interface UploadResult {
  conversionId: string;
  success: boolean;
  errorCode?: string;
  errorMessage?: string;
}

export interface GoogleAdsConversion {
  conversionAction: string;
  gclid: string;
  conversionDateTime: string;
  conversionValue: number;
  currencyCode: string;
  orderId: string;
  consent?: { adUserData: string };
}

export class UploadPipelineService {
  private readonly MAX_BATCH_SIZE = 500;
  private readonly MAX_RETRIES = 5;
  private readonly GOOGLE_ADS_API_VERSION = "v23";

  constructor(
    private mongo: Database,
    private developerToken: string,
    private customerId: string,
    private conversionAction: string
  ) {}

  async processPendingConversions(): Promise<UploadBatch[]> {
    const conversions = this.mongo.collection<ConversionEvent>("conversions");

    const pending = await conversions
      .find({
        status: "pending",
        uploadAttempts: { $lt: this.MAX_RETRIES },
      })
      .limit(this.MAX_BATCH_SIZE)
      .toArray();

    if (pending.length === 0) {
      return [];
    }

    const batches: ConversionEvent[][] = [];
    for (let i = 0; i < pending.length; i += this.MAX_BATCH_SIZE) {
      batches.push(pending.slice(i, i + this.MAX_BATCH_SIZE));
    }

    const results: UploadBatch[] = [];
    for (const batch of batches) {
      const uploadBatch = await this.uploadBatch(batch);
      results.push(uploadBatch);
    }

    return results;
  }

  private async uploadBatch(conversions: ConversionEvent[]): Promise<UploadBatch> {
    const jobId = this.generateJobId();
    const batch: UploadBatch = {
      jobId,
      conversions,
      status: "uploading",
      createdAt: new Date(),
    };

    const batches = this.mongo.collection("upload_batches");
    await batches.insertOne(batch);

    const googleAdsConversions = conversions.map((c) =>
      this.toGoogleAdsFormat(c)
    );

    try {
      const response = await this.callGoogleAdsApi(googleAdsConversions);
      batch.results = response.results;
      batch.status = response.partialFailure ? "partial" : "completed";
      batch.completedAt = new Date();

      await this.updateConversionStatuses(response.results);
    } catch (error) {
      batch.status = "failed";
      batch.errorMessage = error instanceof Error ? error.message : "Unknown error";
      batch.completedAt = new Date();

      await this.markConversionsForRetry(conversions);
    }

    await batches.updateOne(
      { jobId },
      {
        $set: {
          status: batch.status,
          results: batch.results,
          errorMessage: batch.errorMessage,
          completedAt: batch.completedAt,
        },
      }
    );

    return batch;
  }

  private toGoogleAdsFormat(conversion: ConversionEvent): GoogleAdsConversion {
    const date = conversion.conversionDateTime;
    const formattedDate = this.formatDateForGoogleAds(date);

    return {
      conversionAction: this.conversionAction,
      gclid: conversion.gclid || "",
      conversionDateTime: formattedDate,
      conversionValue: conversion.conversionValue,
      currencyCode: conversion.currencyCode,
      orderId: conversion.orderId,
      consent: { adUserData: "GRANTED" },
    };
  }

  private formatDateForGoogleAds(date: Date): string {
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, "0");
    const day = String(date.getDate()).padStart(2, "0");
    const hours = String(date.getHours()).padStart(2, "0");
    const minutes = String(date.getMinutes()).padStart(2, "0");
    const seconds = String(date.getSeconds()).padStart(2, "0");
    const timezoneOffset = "+03:00";

    return `${year}-${month}-${day} ${hours}:${minutes}:${seconds}${timezoneOffset}`;
  }

  private async callGoogleAdsApi(
    conversions: GoogleAdsConversion[]
  ): Promise<{ results: UploadResult[]; partialFailure: boolean }> {
    const url = `https://googleads.googleapis.com/${this.GOOGLE_ADS_API_VERSION}/customers/${this.customerId}:uploadClickConversions`;

    const response = await fetch(url, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${await this.getOAuthToken()}`,
        "developer-token": this.developerToken,
      },
      body: JSON.stringify({
        conversions,
        partialFailure: true,
        jobId: Date.now(),
      }),
    });

    if (!response.ok) {
      throw new Error(`Google Ads API error: ${response.status} ${response.statusText}`);
    }

    const data = await response.json();

    return {
      results: data.results || [],
      partialFailure: !!data.partialFailureError,
    };
  }

  private async getOAuthToken(): Promise<string> {
    return "mock-oauth-token";
  }

  private async updateConversionStatuses(results: UploadResult[]): Promise<void> {
    const conversions = this.mongo.collection("conversions");

    for (const result of results) {
      await conversions.updateOne(
        { id: result.conversionId },
        {
          $set: {
            status: result.success ? "uploaded" : "failed",
            errorMessage: result.errorMessage,
            uploadedAt: result.success ? new Date() : undefined,
          },
          $inc: { uploadAttempts: 1 },
        }
      );
    }
  }

  private async markConversionsForRetry(
    conversions: ConversionEvent[]
  ): Promise<void> {
    const collection = this.mongo.collection("conversions");

    for (const conversion of conversions) {
      await collection.updateOne(
        { id: conversion.id },
        {
          $inc: { uploadAttempts: 1 },
          $set: {
            status: conversion.uploadAttempts >= this.MAX_RETRIES - 1
              ? "failed"
              : "pending",
            lastRetryAt: new Date(),
          },
        }
      );
    }
  }

  private generateJobId(): number {
    return Date.now() + Math.floor(Math.random() * 1000);
  }
}
