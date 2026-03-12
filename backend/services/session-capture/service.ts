import type { Redis } from "redis";
import type { Database } from "mongodb";

export interface SessionData {
  token: string;
  clientId: string;
  clickId: ClickIdentifier | null;
  landingPage: string;
  referrer: string;
  userAgent: string;
  timestamp: number;
  phoneNumber?: string;
}

export interface ClickIdentifier {
  type: "gclid" | "gbraid" | "wbraid" | "fbclid";
  value: string;
  timestamp: number;
}

export interface SessionRegistrationRequest {
  token: string;
  clientId: string;
  clickId?: ClickIdentifier;
  landingPage: string;
  referrer: string;
  userAgent: string;
}

export class SessionCaptureService {
  private readonly SESSION_PREFIX = "session:";
  private readonly SESSION_TTL_SECONDS = 1800; // 30 minutes

  constructor(private redis: Redis, private mongo: Database) {}

  async registerSession(request: SessionRegistrationRequest): Promise<SessionData> {
    const sessionData: SessionData = {
      token: request.token,
      clientId: request.clientId,
      clickId: request.clickId || null,
      landingPage: request.landingPage,
      referrer: request.referrer,
      userAgent: request.userAgent,
      timestamp: Date.now(),
    };

    await this.redis.setex(
      `${this.SESSION_PREFIX}${request.token}`,
      this.SESSION_TTL_SECONDS,
      JSON.stringify(sessionData)
    );

    const sessions = this.mongo.collection("sessions");
    await sessions.insertOne({
      ...sessionData,
      createdAt: new Date(),
    });

    console.log(`Session registered: ${request.token} for client ${request.clientId}`);
    return sessionData;
  }

  async getSession(token: string): Promise<SessionData | null> {
    const cached = await this.redis.get(`${this.SESSION_PREFIX}${token}`);
    if (cached) {
      return JSON.parse(cached);
    }

    const sessions = this.mongo.collection("sessions");
    const session = await sessions.findOne({ token });
    if (session) {
      const data: SessionData = {
        token: session.token,
        clientId: session.clientId,
        clickId: session.clickId,
        landingPage: session.landingPage,
        referrer: session.referrer,
        userAgent: session.userAgent,
        timestamp: session.timestamp,
        phoneNumber: session.phoneNumber,
      };
      return data;
    }

    return null;
  }

  async refreshSession(token: string): Promise<void> {
    const session = await this.getSession(token);
    if (session) {
      await this.redis.setex(
        `${this.SESSION_PREFIX}${token}`,
        this.SESSION_TTL_SECONDS,
        JSON.stringify(session)
      );
    }
  }

  async assignPhoneNumber(token: string, phoneNumber: string): Promise<void> {
    const session = await this.getSession(token);
    if (session) {
      session.phoneNumber = phoneNumber;
      await this.redis.setex(
        `${this.SESSION_PREFIX}${token}`,
        this.SESSION_TTL_SECONDS,
        JSON.stringify(session)
      );

      const sessions = this.mongo.collection("sessions");
      await sessions.updateOne(
        { token },
        { $set: { phoneNumber, updatedAt: new Date() } }
      );
    }
  }

  async deleteSession(token: string): Promise<void> {
    await this.redis.del(`${this.SESSION_PREFIX}${token}`);
    const sessions = this.mongo.collection("sessions");
    await sessions.updateOne(
      { token },
      { $set: { deletedAt: new Date() } }
    );
  }
}
