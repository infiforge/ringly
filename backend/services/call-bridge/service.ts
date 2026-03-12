import type { Database } from "mongodb";

export interface CallEvent {
  id: string;
  phoneNumber: string;
  callerNumber: string;
  sessionToken: string;
  startTime: Date;
  endTime?: Date;
  duration?: number;
  dtmfInput?: string;
  status: "ringing" | "answered" | "completed" | "missed" | "failed";
  recordingUrl?: string;
  direction: "inbound" | "outbound";
}

export interface CallBridgeRequest {
  phoneNumber: string;
  callerNumber: string;
  sessionToken?: string;
  dtmfInput?: string;
  timestamp: Date;
}

export class CallBridgeService {
  constructor(private mongo: Database) {}

  async createCallEvent(request: CallBridgeRequest): Promise<CallEvent> {
    const callEvent: CallEvent = {
      id: this.generateCallId(),
      phoneNumber: request.phoneNumber,
      callerNumber: request.callerNumber,
      sessionToken: request.sessionToken || "",
      startTime: request.timestamp,
      status: "ringing",
      direction: "inbound",
      dtmfInput: request.dtmfInput || "",
    };

    const calls = this.mongo.collection("calls");
    await calls.insertOne(callEvent);

    console.log(`Call event created: ${callEvent.id}`);
    return callEvent;
  }

  async updateCallStatus(
    callId: string,
    status: CallEvent["status"],
    endTime?: Date
  ): Promise<void> {
    const calls = this.mongo.collection("calls");
    const update: Partial<CallEvent> = { status };

    if (endTime) {
      update.endTime = endTime;
      const call = await calls.findOne({ id: callId });
      if (call && call.startTime) {
        update.duration = Math.floor(
          (endTime.getTime() - new Date(call.startTime).getTime()) / 1000
        );
      }
    }

    await calls.updateOne({ id: callId }, { $set: update });
    console.log(`Call ${callId} status updated to: ${status}`);
  }

  async updateCallDtmf(callId: string, dtmfInput: string): Promise<void> {
    const calls = this.mongo.collection("calls");
    await calls.updateOne(
      { id: callId },
      { $set: { dtmfInput, updatedAt: new Date() } }
    );
    console.log(`Call ${callId} DTMF updated: ${dtmfInput}`);
  }

  async linkSessionToCall(callId: string, sessionToken: string): Promise<void> {
    const calls = this.mongo.collection("calls");
    await calls.updateOne(
      { id: callId },
      { $set: { sessionToken, updatedAt: new Date() } }
    );
    console.log(`Call ${callId} linked to session: ${sessionToken}`);
  }

  async getCallById(callId: string): Promise<CallEvent | null> {
    const calls = this.mongo.collection("calls");
    const call = await calls.findOne({ id: callId });
    if (!call) return null;

    return {
      id: call.id,
      phoneNumber: call.phoneNumber,
      callerNumber: call.callerNumber,
      sessionToken: call.sessionToken,
      startTime: call.startTime,
      endTime: call.endTime,
      duration: call.duration,
      dtmfInput: call.dtmfInput,
      status: call.status,
      recordingUrl: call.recordingUrl,
      direction: call.direction,
    };
  }

  private generateCallId(): string {
    const chars = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789";
    let result = "CA-";
    for (let i = 0; i < 12; i++) {
      result += chars.charAt(Math.floor(Math.random() * chars.length));
    }
    return result;
  }
}
