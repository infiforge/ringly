export interface Config {
  apiBaseUrl: string;
  clientId: string;
  sessionTtlMinutes?: number;
  numberSelectors?: string[];
  debug?: boolean;
}

export interface ClickIdentifier {
  type: "gclid" | "gbraid" | "wbraid" | "fbclid";
  value: string;
  timestamp: number;
}

export interface SessionData {
  token: string;
  clickId: ClickIdentifier | null;
  landingPage: string;
  referrer: string;
  userAgent: string;
  timestamp: number;
  phoneNumber?: string;
}

export interface GclidData {
  gclid: string;
  campaignId?: string;
  timestamp: number;
}
