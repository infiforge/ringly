import { type Database } from "mongodb";
import {
  AllowedRouteTypes,
  UniversalRoute,
  UniversalRouteMethod,
} from "../interfaces/route.ts";

export interface Campaign {
  id: string;
  name: string;
  clientId: string;
  status: "active" | "paused" | "archived";
  conversionAction: string;
  conversionValue: number;
  currencyCode: string;
  phoneNumberPool: string[];
  createdAt: Date;
  updatedAt?: Date;
}

function generateCampaignId(): string {
  const chars = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789";
  let result = "CMP-";
  for (let i = 0; i < 10; i++) {
    result += chars.charAt(Math.floor(Math.random() * chars.length));
  }
  return result;
}

// Campaigns routes using UniversalRoute pattern
export const campaignsRoutes: UniversalRoute[] = [

  // Get all campaigns
  new UniversalRoute({
    accepts: AllowedRouteTypes.http,
    paths: { http: "/api/campaigns" },
    method: UniversalRouteMethod.get,
    description: "Get all campaigns with pagination",
    func: async (input: any, context: any) => {
      const mongo = context.db as Database | null;

      if (!mongo) {
        throw new Error("Database not connected");
      }

      const limit = parseInt(input.limit || "50");
      const offset = parseInt(input.offset || "0");
      const status = input.status;

      const campaigns = mongo.collection("campaigns");
      const query: { status?: string } = {};
      if (status) query.status = status;

      const items = await campaigns
        .find(query)
        .sort({ createdAt: -1 })
        .skip(offset)
        .limit(limit)
        .toArray();

      const total = await campaigns.countDocuments(query);

      return {
        campaigns: items,
        pagination: {
          total,
          limit,
          offset,
          hasMore: offset + limit < total,
        },
      };
    },
  }),
];
