export { SessionCapture } from "./session-capture";
export { DynamicNumberDisplay } from "./dynamic-number-display";
export type { ClickIdentifier, SessionData, Config } from "./types";

import { SessionCapture } from "./session-capture";
import { DynamicNumberDisplay } from "./dynamic-number-display";
import type { Config } from "./types";

export class CallAttributionTracker {
  private sessionCapture: SessionCapture;
  private dynamicNumberDisplay: DynamicNumberDisplay;

  constructor(config: Config) {
    this.sessionCapture = new SessionCapture(config);
    this.dynamicNumberDisplay = new DynamicNumberDisplay(config);
  }

  init(): void {
    this.sessionCapture.init();
    this.dynamicNumberDisplay.init();
  }
}

export default CallAttributionTracker;
