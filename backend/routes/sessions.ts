import { AllowedRouteTypes, UniversalRoute, UniversalRouteMethod } from "../interfaces/route.ts";

// Sessions routes using UniversalRoute pattern
export const sessionsRoutes: UniversalRoute[] = [
  // Register session
  new UniversalRoute({
    accepts: AllowedRouteTypes.http,
    paths: { http: "/api/sessions/register" },
    method: UniversalRouteMethod.post,
    description: "Register a new session",
    func: async (input: any, context: any) => {
      return { message: "Session registered", token: input.token };
    },
  }),
  // Get session
  new UniversalRoute({
    accepts: AllowedRouteTypes.http,
    paths: { http: "/api/sessions/:token" },
    method: UniversalRouteMethod.get,
    description: "Get session by token",
    func: async (input: any, context: any) => {
      return { session: { token: input.token } };
    },
  }),
];
