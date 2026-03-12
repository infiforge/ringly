import { AllowedRouteTypes, UniversalRoute, UniversalRouteMethod } from "../interfaces/route.ts";

// Calls routes using UniversalRoute pattern
export const callsRoutes: UniversalRoute[] = [
  // Placeholder - calls webhook endpoint
  new UniversalRoute({
    accepts: AllowedRouteTypes.http,
    paths: { http: "/api/calls/webhook" },
    method: UniversalRouteMethod.post,
    description: "Receive call webhook events",
    func: async (input: any, context: any) => {
      return { message: "Call webhook received", input };
    },
  }),
  // Get calls list
  new UniversalRoute({
    accepts: AllowedRouteTypes.http,
    paths: { http: "/api/calls" },
    method: UniversalRouteMethod.get,
    description: "Get call logs",
    func: async (input: any, context: any) => {
      return { calls: [] };
    },
  }),
];

