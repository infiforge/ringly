import type { ClickIdentifier, Config, SessionData } from "./types";

export class SessionCapture {
  private readonly GCLID_PARAM = "gclid";
  private readonly GBRAID_PARAM = "gbraid";
  private readonly WBRAID_PARAM = "wbraid";
  private readonly FBCLID_PARAM = "fbclid";
  private readonly SESSION_KEY = "ca_session";
  private readonly TOKEN_KEY = "ca_token";
  private readonly SESSION_COOKIE = "ca_session_token";

  private config: Config;
  private debug: boolean;

  constructor(config: Config) {
    this.config = config;
    this.debug = config.debug || false;
  }

  init(): void {
    if (typeof window === "undefined") {
      this.log("SessionCapture: window not available, skipping initialization");
      return;
    }

    const clickId = this.extractClickId();
    const existingToken = this.getExistingToken();

    if (clickId) {
      this.log("Click identifier detected:", clickId);
      const token = this.generateSessionToken();
      const sessionData = this.createSessionData(token, clickId);
      this.storeSession(token, sessionData);
      this.registerSession(token, sessionData);
    } else if (existingToken) {
      this.log("Existing session found:", existingToken);
      this.refreshSession(existingToken);
    } else {
      this.log("No click identifier or existing session");
      const token = this.generateSessionToken();
      const sessionData = this.createSessionData(token, null);
      this.storeSession(token, sessionData);
    }
  }

  extractClickId(): ClickIdentifier | null {
    if (typeof window === "undefined") return null;

    const urlParams = new URLSearchParams(window.location.search);

    const gclid = urlParams.get(this.GCLID_PARAM);
    if (gclid) {
      return { type: "gclid", value: gclid, timestamp: Date.now() };
    }

    const gbraid = urlParams.get(this.GBRAID_PARAM);
    if (gbraid) {
      return { type: "gbraid", value: gbraid, timestamp: Date.now() };
    }

    const wbraid = urlParams.get(this.WBRAID_PARAM);
    if (wbraid) {
      return { type: "wbraid", value: wbraid, timestamp: Date.now() };
    }

    const fbclid = urlParams.get(this.FBCLID_PARAM);
    if (fbclid) {
      return { type: "fbclid", value: fbclid, timestamp: Date.now() };
    }

    return null;
  }

  private getExistingToken(): string | null {
    if (typeof window === "undefined") return null;

    const token = localStorage.getItem(this.TOKEN_KEY);
    if (token) return token;

    const cookieValue = this.getCookie(this.SESSION_COOKIE);
    if (cookieValue) return cookieValue;

    const session = sessionStorage.getItem(this.SESSION_KEY);
    if (session) {
      try {
        const data = JSON.parse(session);
        return data.token;
      } catch {
        return null;
      }
    }

    return null;
  }

  private generateSessionToken(): string {
    const chars = "ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnpqrstuvwxyz23456789";
    let result = "";
    for (let i = 0; i < 6; i++) {
      result += chars.charAt(Math.floor(Math.random() * chars.length));
    }
    return result;
  }

  private createSessionData(
    token: string,
    clickId: ClickIdentifier | null
  ): SessionData {
    return {
      token,
      clickId,
      landingPage: typeof window !== "undefined" ? window.location.href : "",
      referrer: typeof document !== "undefined" ? document.referrer : "",
      userAgent: typeof navigator !== "undefined" ? navigator.userAgent : "",
      timestamp: Date.now(),
    };
  }

  private storeSession(token: string, data: SessionData): void {
    if (typeof window === "undefined") return;

    localStorage.setItem(this.TOKEN_KEY, token);
    localStorage.setItem(this.SESSION_KEY, JSON.stringify(data));

    this.setCookie(this.SESSION_COOKIE, token, 30);

    sessionStorage.setItem(this.SESSION_KEY, JSON.stringify(data));

    this.log("Session stored:", token);
  }

  private async registerSession(token: string, data: SessionData): Promise<void> {
    try {
      const response = await fetch(`${this.config.apiBaseUrl}/sessions/register`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          token,
          clientId: this.config.clientId,
          clickId: data.clickId,
          landingPage: data.landingPage,
          referrer: data.referrer,
          userAgent: data.userAgent,
        }),
      });

      if (response.ok) {
        this.log("Session registered with backend");
      } else {
        this.log("Failed to register session:", response.status);
      }
    } catch (error) {
      this.log("Error registering session:", error);
    }
  }

  private refreshSession(token: string): void {
    this.setCookie(this.SESSION_COOKIE, token, 30);

    const sessionData = localStorage.getItem(this.SESSION_KEY);
    if (sessionData) {
      sessionStorage.setItem(this.SESSION_KEY, sessionData);
    }
  }

  private getCookie(name: string): string | null {
    if (typeof document === "undefined") return null;

    const match = document.cookie.match(new RegExp("(^| )" + name + "=([^;]+)"));
    return match ? decodeURIComponent(match[2]) : null;
  }

  private setCookie(name: string, value: string, days: number): void {
    if (typeof document === "undefined") return;

    const expires = new Date();
    expires.setTime(expires.getTime() + days * 24 * 60 * 60 * 1000);
    document.cookie = `${name}=${encodeURIComponent(value)};expires=${expires.toUTCString()};path=/;SameSite=Lax`;
  }

  private log(...args: unknown[]): void {
    if (this.debug && typeof console !== "undefined") {
      console.log("[CallAttribution]", ...args);
    }
  }
}
