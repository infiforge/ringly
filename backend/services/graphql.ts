import {
    buildSchema,
    graphql,
    GraphQLSchema,
    GraphQLObjectType,
    GraphQLString,
    GraphQLBoolean,
    GraphQLList,
    GraphQLNonNull,
    GraphQLID,
} from "https://deno.land/x/graphql_deno@v15.0.0/mod.ts";

import { database, UserDocument } from "./database.ts";
import { logger } from "./logger.ts";
import type { GraphQLContext } from "../interfaces/graphql.ts";

// Define GraphQL types
const UserType = new GraphQLObjectType({
    name: "User",
    fields: {
        id: { type: new GraphQLNonNull(GraphQLID) },
        email: { type: new GraphQLNonNull(GraphQLString) },
        firstName: { type: new GraphQLNonNull(GraphQLString) },
        lastName: { type: new GraphQLNonNull(GraphQLString) },
        fullName: { type: new GraphQLNonNull(GraphQLString) },
        username: { type: new GraphQLNonNull(GraphQLString) },
        role: { type: new GraphQLNonNull(GraphQLString) },
        provider: { type: GraphQLString },
        providerId: { type: GraphQLString },
        photoUrl: { type: GraphQLString },
    },
});

const AuthResponseType = new GraphQLObjectType({
    name: "AuthResponse",
    fields: {
        success: { type: new GraphQLNonNull(GraphQLBoolean) },
        user: { type: UserType },
        token: { type: GraphQLString },
        error: { type: GraphQLString },
        details: { type: GraphQLString },
    },
});

const LogEntryType = new GraphQLObjectType({
    name: "LogEntry",
    fields: {
        id: { type: new GraphQLNonNull(GraphQLID) },
        timestamp: { type: new GraphQLNonNull(GraphQLString) },
        level: { type: new GraphQLNonNull(GraphQLString) },
        message: { type: new GraphQLNonNull(GraphQLString) },
        source: { type: GraphQLString },
        service: { type: GraphQLString },
    },
});

const LogsResponseType = new GraphQLObjectType({
    name: "LogsResponse",
    fields: {
        success: { type: new GraphQLNonNull(GraphQLBoolean) },
        logs: { type: new GraphQLList(LogEntryType) },
        error: { type: GraphQLString },
    },
});

// Query resolvers
const QueryType = new GraphQLObjectType({
    name: "Query",
    fields: {
        health: {
            type: GraphQLString,
            resolve: () => "OK",
        },
        me: {
            type: UserType,
            resolve: async (_parent: any, _args: any, context: GraphQLContext) => {
                if (!context.user) {
                    throw new Error("Not authenticated");
                }
                return context.user;
            },
        },
        logs: {
            type: LogsResponseType,
            args: {
                level: { type: GraphQLString },
            },
            resolve: async (_parent: any, args: { level?: string }) => {
                try {
                    const { logger } = await import("./logger.ts");
                    const level = args.level as any || 'all';
                    const logs = await logger.getLogs(level);

                    return {
                        success: true,
                        logs: logs.map(log => ({
                            id: log.id,
                            timestamp: log.timestamp.toISOString(),
                            level: log.level,
                            message: log.message,
                            source: log.source || 'backend',
                            service: log.service || 'infiforge',
                        })),
                    };
                } catch (error) {
                    logger.error("Failed to retrieve logs", error);
                    return {
                        success: false,
                        error: "Failed to retrieve logs",
                    };
                }
            },
        },
    },
});

// Mutation resolvers
const MutationType = new GraphQLObjectType({
    name: "Mutation",
    fields: {
        login: {
            type: AuthResponseType,
            args: {
                email: { type: new GraphQLNonNull(GraphQLString) },
                password: { type: new GraphQLNonNull(GraphQLString) },
            },
            resolve: async (_parent: any, args: any) => {
                const { email, password } = args as { email: string; password: string };
                try {
                    // Basic login implementation
                    const user = await database.findUserByEmail(email);
                    if (!user) {
                        return {
                            success: false,
                            error: "User not found",
                        };
                    }

                    // TODO: Add password verification with Argon2
                    const { create } = await import("djwt");

                    const jwtSecret = Deno.env.get("JWT_SECRET") || 'changeme';
                    const key = await crypto.subtle.importKey(
                        "raw",
                        new TextEncoder().encode(jwtSecret),
                        { name: "HMAC", hash: "SHA-256" },
                        false,
                        ["sign", "verify"]
                    );

                    const token = await create(
                        { alg: "HS256", typ: "JWT" },
                        {
                            id: user._id?.toString(),
                            email: user.email,
                            exp: Math.floor(Date.now() / 1000) + (7 * 24 * 60 * 60) // 7 days
                        },
                        key
                    );

                    return {
                        success: true,
                        user: {
                            id: user._id,
                            email: user.email,
                            firstName: user.firstName,
                            lastName: user.lastName,
                            fullName: user.fullName,
                            username: user.username,
                            role: user.role,
                            provider: user.provider,
                            providerId: user.providerId,
                            photoUrl: user.photoUrl,
                        },
                        token,
                    };
                } catch (error) {
                    logger.error("Login error", error);
                    return {
                        success: false,
                        error: "Login failed",
                    };
                }
            },
        },
    },
});

// Create the schema
export const schema = new GraphQLSchema({
    query: QueryType,
    mutation: MutationType,
});

export class GraphQLService {
    private static instance: GraphQLService;
    public schema: GraphQLSchema;

    private constructor() {
        this.schema = schema;
    }

    public static getInstance(): GraphQLService {
        if (!GraphQLService.instance) {
            GraphQLService.instance = new GraphQLService();
        }
        return GraphQLService.instance;
    }

    public async execute(
        query: string,
        variables?: Record<string, any>,
        context?: GraphQLContext
    ): Promise<any> {
        try {
            const result = await graphql({
                schema: this.schema,
                source: query,
                variableValues: variables,
                contextValue: context,
            });
            return result;
        } catch (error) {
            logger.error("GraphQL execution error", error);
            return {
                errors: [{ message: "Internal server error" }],
            };
        }
    }
}

export const graphqlService = GraphQLService.getInstance();
