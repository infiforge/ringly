import type { Database } from "mongodb";
import type { CallEvent } from "../call-bridge/service.ts";

export interface ConversionEvent {
  id: string;
  callId: string;
  gclid?: string;
  conversionAction: string;
  conversionDateTime: Date;
  conversionValue: number;
  currencyCode: string;
  orderId: string;
  status: "pending" | "uploaded" | "failed" | "duplicate";
  errorMessage?: string;
  uploadAttempts: number;
  uploadedAt?: Date;
}

export interface AttributionResult {
  callId: string;
  gclid?: string;
  attributed: boolean;
  reason?: string;
  conversionEvent?: ConversionEvent;
}

export class AttributionEngineService {
  private readonly MIN_CALL_DURATION_SECONDS = 10;
  private readonly DEDUPLICATION_WINDOW_MINUTES = 60;

  constructor(private mongo: Database) {}

  async attributeCall(callEvent: CallEvent): Promise<AttributionResult> {
    const result: AttributionResult = {
      callId: callEvent.id,
      attributed: false,
    };

    if (!callEvent.sessionToken) {
      result.reason = "No session token associated with call";
      return result;
    }

    const sessions = this.mongo.collection("sessions");
    const session = await sessions.findOne({ token: callEvent.sessionToken });

    if (!session) {
      result.reason = "Session not found";
      return result;
    }

    if (!session.clickId || !session.clickId.value) {
      result.reason = "No GCLID found in session";
      return result;
    }

    const clickId = session.clickId.value;

    if (!callEvent.duration || callEvent.duration < this.MIN_CALL_DURATION_SECONDS) {
      result.reason = `Call duration too short (${callEvent.duration}s < ${this.MIN_CALL_DURATION_SECONDS}s)`;
      return result;
    }

    const isDuplicate = await this.checkForDuplicate(
      clickId,
      callEvent.callerNumber
    );
    if (isDuplicate) {
      result.reason = "Duplicate call within deduplication window";
      return result;
    }

    result.gclid = clickId;
    result.attributed = true;

    const conversionEvent = await this.createConversionEvent(
      callEvent,
      session.clickId
    );
    result.conversionEvent = conversionEvent;

    console.log(`Call ${callEvent.id} attributed to GCLID: ${clickId}`);
    return result;
  }

  private async createConversionEvent(
    callEvent: CallEvent,
    clickId: { type: string; value: string; timestamp: number }
  ): Promise<ConversionEvent> {
    const conversionId = this.generateConversionId();

    const conversionEvent: ConversionEvent = {
      id: conversionId,
      callId: callEvent.id,
      gclid: clickId.value,
      conversionAction: "",
      conversionDateTime: callEvent.endTime || new Date(),
      conversionValue: 0,
      currencyCode: "KES",
      orderId: `call_${callEvent.id}`,
      status: "pending",
      uploadAttempts: 0,
    };

    const conversions = this.mongo.collection("conversions");
    await conversions.insertOne({
      ...conversionEvent,
      createdAt: new Date(),
    });

    return conversionEvent;
  }

  private async checkForDuplicate(
    gclid: string,
    callerNumber: string
  ): Promise<boolean> {
    const conversions = this.mongo.collection("conversions");

    const cutoffTime = new Date(
      Date.now() - this.DEDUPLICATION_WINDOW_MINUTES * 60 * 1000
    );

    const existing = await conversions.findOne({
      gclid,
      "callerNumber": callerNumber,
      createdAt: { $gte: cutoffTime },
    });

    return !!existing;
  }

  async updateConversionAction(
    conversionId: string,
    conversionAction: string,
    conversionValue: number
  ): Promise<void> {
    const conversions = this.mongo.collection("conversions");
    await conversions.updateOne(
      { id: conversionId },
      {
        $set: {
          conversionAction,
          conversionValue,
          updatedAt: new Date(),
        },
      }
    );
  }

  async markConversionUploaded(
    conversionId: string,
    success: boolean,
    errorMessage?: string
  ): Promise<void> {
    const conversions = this.mongo.collection("conversions");
    const update: Partial<ConversionEvent> = {
      status: success ? "uploaded" : "failed",
      uploadAttempts: { $inc: 1 },
    } as unknown as Partial<ConversionEvent>;

    if (success) {
      update.uploadedAt = new Date();
    }
    if (errorMessage) {
      update.errorMessage = errorMessage;
    }

    await conversions.updateOne({ id: conversionId }, { $set: update });
  }

  private generateConversionId(): string {
    const chars = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789";
    let result = "CONV-";
    for (let i = 0; i < 12; i++) {
      result += chars.charAt(Math.floor(Math.random() * chars.length));
    }
    return result;
  }
}
