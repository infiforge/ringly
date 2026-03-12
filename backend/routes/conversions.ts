import { AllowedRouteTypes, UniversalRoute, UniversalRouteMethod } from "../interfaces/route.ts";

// Conversions routes using UniversalRoute pattern
export const conversionsRoutes: UniversalRoute[] = [
  // Upload conversion
  new UniversalRoute({
    accepts: AllowedRouteTypes.http,
    paths: { http: "/api/conversions" },
    method: UniversalRouteMethod.post,
    description: "Upload a conversion",
    func: async (input: any, context: any) => {
      return { message: "Conversion uploaded" };
    },
  }),
  // Get conversions
  new UniversalRoute({
    accepts: AllowedRouteTypes.http,
    paths: { http: "/api/conversions" },
    method: UniversalRouteMethod.get,
    description: "Get conversions list",
    func: async (input: any, context: any) => {
      return { conversions: [] };
    },
  }),
];
