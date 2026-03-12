import { AllowedRouteTypes, UniversalRoute, UniversalRouteMethod } from "../interfaces/route.ts";

// Numbers routes using UniversalRoute pattern
export const numbersRoutes: UniversalRoute[] = [
  // Get available numbers
  new UniversalRoute({
    accepts: AllowedRouteTypes.http,
    paths: { http: "/api/numbers" },
    method: UniversalRouteMethod.get,
    description: "Get phone numbers",
    func: async (input: any, context: any) => {
      return { numbers: [] };
    },
  }),
  // Assign number
  new UniversalRoute({
    accepts: AllowedRouteTypes.http,
    paths: { http: "/api/numbers/assign" },
    method: UniversalRouteMethod.post,
    description: "Assign a phone number",
    func: async (input: any, context: any) => {
      return { message: "Number assigned" };
    },
  }),
];
