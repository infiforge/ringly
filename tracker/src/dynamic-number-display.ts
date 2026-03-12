import type { Config } from "./types";

export class DynamicNumberDisplay {
  private config: Config;
  private debug: boolean;
  private currentPhoneNumber: string | null = null;

  constructor(config: Config) {
    this.config = config;
    this.debug = config.debug || false;
  }

  init(): void {
    if (typeof window === "undefined") {
      this.log("DynamicNumberDisplay: window not available");
      return;
    }

    const selectors = this.config.numberSelectors || [
      "[data-phone-number]",
      ".phone-number",
      "#phone-number",
    ];

    this.fetchNumber().then((number) => {
      if (number) {
        this.currentPhoneNumber = number;
        this.replaceNumbers(selectors, number);
        this.observeDOMChanges(selectors);
      }
    });
  }

  private async fetchNumber(): Promise<string | null> {
    try {
      const token = this.getSessionToken();
      if (!token) {
        this.log("No session token available for number fetch");
        return null;
      }

      const response = await fetch(
        `${this.config.apiBaseUrl}/numbers/assign?clientId=${this.config.clientId}&token=${token}`,
        {
          method: "GET",
          headers: {
            "Content-Type": "application/json",
          },
        }
      );

      if (response.ok) {
        const data = await response.json();
        this.log("Number assigned:", data.phoneNumber);
        return data.phoneNumber;
      } else {
        this.log("Failed to fetch number:", response.status);
        return null;
      }
    } catch (error) {
      this.log("Error fetching number:", error);
      return null;
    }
  }

  private getSessionToken(): string | null {
    if (typeof window === "undefined") return null;

    const localToken = localStorage.getItem("ca_token");
    if (localToken) return localToken;

    const cookieMatch = document.cookie.match(/ca_session_token=([^;]+)/);
    if (cookieMatch) return decodeURIComponent(cookieMatch[1]);

    return null;
  }

  private replaceNumbers(selectors: string[], number: string): void {
    if (typeof document === "undefined") return;

    for (const selector of selectors) {
      const elements = document.querySelectorAll(selector);
      elements.forEach((element) => {
        const originalNumber = element.textContent || "";
        element.textContent = this.formatNumber(number);
        element.setAttribute("data-original-number", originalNumber);
        element.setAttribute("data-ca-number", number);
      });
    }
  }

  private formatNumber(number: string): string {
    if (number.startsWith("+254") && number.length === 13) {
      return number.replace(
        /(\+254)(\d{3})(\d{3})(\d{3})/,
        "$1 $2 $3 $4"
      );
    }
    if (number.startsWith("0") && number.length === 10) {
      return number.replace(/(\d{3})(\d{3})(\d{4})/, "$1 $2 $3");
    }
    return number;
  }

  private observeDOMChanges(selectors: string[]): void {
    if (typeof window === "undefined" || typeof MutationObserver === "undefined") {
      return;
    }

    if (!this.currentPhoneNumber) return;

    const observer = new MutationObserver((mutations) => {
      let shouldUpdate = false;

      for (const mutation of mutations) {
        if (mutation.type === "childList") {
          for (const node of mutation.addedNodes) {
            if (node.nodeType === Node.ELEMENT_NODE) {
              const element = node as Element;
              for (const selector of selectors) {
                if (element.matches(selector) || element.querySelector(selector)) {
                  shouldUpdate = true;
                  break;
                }
              }
            }
          }
        }
      }

      if (shouldUpdate && this.currentPhoneNumber) {
        this.replaceNumbers(selectors, this.currentPhoneNumber);
      }
    });

    observer.observe(document.body, {
      childList: true,
      subtree: true,
    });

    this.log("DOM observer started for number replacement");
  }

  private log(...args: unknown[]): void {
    if (this.debug && typeof console !== "undefined") {
      console.log("[CallAttribution:DND]", ...args);
    }
  }
}
