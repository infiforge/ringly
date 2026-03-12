import {
  AllowedRouteTypes,
  UniversalRoute,
  UniversalRouteMethod,
} from "../interfaces/route.ts";

// Auth routes using UniversalRoute pattern
export const authRoutes: UniversalRoute[] = [
  // Google OAuth exchange
  new UniversalRoute({
    accepts: AllowedRouteTypes.http,
    paths: { http: "/api/auth/google/exchange" },
    method: UniversalRouteMethod.post,
    description: "Exchange Google OAuth code for tokens",
    func: async (input: any, context: any) => {
      const { code, codeVerifier, redirectUri, platform } = input;
      
      // Get Google credentials from environment
      const clientId = Deno.env.get("GOOGLE_WEB_CLIENT_ID") || 
                       Deno.env.get("GOOGLE_CLIENT_ID") || "";
      const clientSecret = Deno.env.get("GOOGLE_WEB_CLIENT_SECRET") || 
                           Deno.env.get("GOOGLE_CLIENT_SECRET") || "";
      
      if (!clientId || !clientSecret) {
        throw new Error("Google OAuth credentials not configured");
      }

      // Exchange code for tokens with Google
      const tokenResponse = await fetch("https://oauth2.googleapis.com/token", {
        method: "POST",
        headers: { "Content-Type": "application/x-www-form-urlencoded" },
        body: new URLSearchParams({
          code,
          client_id: clientId,
          client_secret: clientSecret,
          redirect_uri: redirectUri,
          grant_type: "authorization_code",
          code_verifier: codeVerifier,
        }),
      });

      if (!tokenResponse.ok) {
        const errorData = await tokenResponse.text();
        throw new Error(`Google token exchange failed: ${errorData}`);
      }

      const tokenData = await tokenResponse.json();
      
      // Get user info from Google
      const userResponse = await fetch("https://www.googleapis.com/oauth2/v2/userinfo", {
        headers: { Authorization: `Bearer ${tokenData.access_token}` },
      });

      if (!userResponse.ok) {
        throw new Error("Failed to fetch user info from Google");
      }

      const googleUser = await userResponse.json();

      // Create JWT token
      const jwtSecret = Deno.env.get("JWT_SECRET") || "ringly_secret_key";
      const jwt = await createJWT({
        email: googleUser.email,
        name: googleUser.name,
        picture: googleUser.picture,
        provider: "google",
      }, jwtSecret);

      return {
        token: jwt,
        user: {
          email: googleUser.email,
          name: googleUser.name,
          photoUrl: googleUser.picture,
          provider: "google",
        },
      };
    },
  }),

  // Microsoft OAuth exchange
  new UniversalRoute({
    accepts: AllowedRouteTypes.http,
    paths: { http: "/api/auth/microsoft/exchange" },
    method: UniversalRouteMethod.post,
    description: "Exchange Microsoft OAuth code for tokens",
    func: async (input: any, context: any) => {
      const { code, codeVerifier, redirectUri, state } = input;
      
      const clientId = Deno.env.get("MICROSOFT_CLIENT_ID") || "";
      const clientSecret = Deno.env.get("MICROSOFT_CLIENT_SECRET") || "";
      const tenantId = Deno.env.get("MICROSOFT_TENANT_ID") || "common";
      
      if (!clientId || !clientSecret) {
        throw new Error("Microsoft OAuth credentials not configured");
      }

      const tokenEndpoint = `https://login.microsoftonline.com/${tenantId}/oauth2/v2.0/token`;

      // Exchange code for tokens
      const tokenResponse = await fetch(tokenEndpoint, {
        method: "POST",
        headers: { "Content-Type": "application/x-www-form-urlencoded" },
        body: new URLSearchParams({
          code,
          client_id: clientId,
          client_secret: clientSecret,
          redirect_uri: redirectUri,
          grant_type: "authorization_code",
          code_verifier: codeVerifier,
        }),
      });

      if (!tokenResponse.ok) {
        const errorData = await tokenResponse.text();
        throw new Error(`Microsoft token exchange failed: ${errorData}`);
      }

      const tokenData = await tokenResponse.json();

      // Get user info from Microsoft Graph
      const userResponse = await fetch("https://graph.microsoft.com/v1.0/me", {
        headers: { Authorization: `Bearer ${tokenData.access_token}` },
      });

      if (!userResponse.ok) {
        throw new Error("Failed to fetch user info from Microsoft");
      }

      const msUser = await userResponse.json();

      // Create JWT
      const jwtSecret = Deno.env.get("JWT_SECRET") || "ringly_secret_key";
      const jwt = await createJWT({
        email: msUser.mail || msUser.userPrincipalName,
        name: msUser.displayName,
        provider: "microsoft",
      }, jwtSecret);

      return {
        token: jwt,
        user: {
          email: msUser.mail || msUser.userPrincipalName,
          name: msUser.displayName,
          photoUrl: null,
          provider: "microsoft",
        },
      };
    },
  }),

  // Native Google Sign-In (for mobile/desktop)
  new UniversalRoute({
    accepts: AllowedRouteTypes.http,
    paths: { http: "/api/auth/google/native" },
    method: UniversalRouteMethod.post,
    description: "Handle native Google Sign-In with ID token",
    func: async (input: any, context: any) => {
      const { idToken, platform } = input;
      
      // Verify the ID token with Google
      const verifyResponse = await fetch(
        `https://oauth2.googleapis.com/tokeninfo?id_token=${idToken}`
      );

      if (!verifyResponse.ok) {
        throw new Error("Invalid Google ID token");
      }

      const googleUser = await verifyResponse.json();

      // Check if the token's aud matches our client ID
      const expectedClientId = Deno.env.get("GOOGLE_WEB_CLIENT_ID") || "";
      if (googleUser.aud !== expectedClientId) {
        throw new Error("Token audience mismatch");
      }

      // Create JWT
      const jwtSecret = Deno.env.get("JWT_SECRET") || "ringly_secret_key";
      const jwt = await createJWT({
        email: googleUser.email,
        name: googleUser.name,
        picture: googleUser.picture,
        provider: "google",
      }, jwtSecret);

      return {
        token: jwt,
        user: {
          email: googleUser.email,
          name: googleUser.name,
          photoUrl: googleUser.picture,
          provider: "google",
        },
      };
    },
  }),

  // Verify token
  new UniversalRoute({
    accepts: AllowedRouteTypes.http,
    paths: { http: "/api/auth/verify" },
    method: UniversalRouteMethod.get,
    description: "Verify JWT token validity",
    func: async (input: any, context: any) => {
      const authHeader = context.req.header("Authorization");
      if (!authHeader || !authHeader.startsWith("Bearer ")) {
        throw new Error("No valid authorization header");
      }

      const token = authHeader.substring(7);
      const jwtSecret = Deno.env.get("JWT_SECRET") || "ringly_secret_key";
      
      try {
        const payload = await verifyJWT(token, jwtSecret);
        return { valid: true, user: payload };
      } catch {
        return { valid: false };
      }
    },
  }),
];

// Simple JWT creation (placeholder - should use proper JWT library like djwt)
async function createJWT(payload: any, secret: string): Promise<string> {
  // In a real implementation, use djwt or similar
  // This is a simplified placeholder
  const header = btoa(JSON.stringify({ alg: "HS256", typ: "JWT" }));
  const body = btoa(JSON.stringify({ ...payload, iat: Date.now(), exp: Date.now() + 7 * 24 * 60 * 60 * 1000 }));
  const signature = btoa(`${header}.${body}.${secret}`);
  return `${header}.${body}.${signature}`;
}

async function verifyJWT(token: string, secret: string): Promise<any> {
  // In a real implementation, use djwt or similar
  const parts = token.split(".");
  if (parts.length !== 3) {
    throw new Error("Invalid token format");
  }
  const payload = JSON.parse(atob(parts[1]));
  if (payload.exp && payload.exp < Date.now()) {
    throw new Error("Token expired");
  }
  return payload;
}
