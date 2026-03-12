export enum AllowedRouteTypes {
  all = 'all',
  graphql = 'graphql',
  http = 'http',
  ws = 'ws',
}

export enum UniversalRouteMethod {
  get = 'get',
  post = 'post',
  put = 'put',
  delete = 'delete',
  patch = 'patch',
}

export interface UniversalRoutePaths {
  /** HTTP path e.g. '/api/logs' */
  http?: string;
  /** GraphQL operation name or path */
  graphql?: string;
  /** WebSocket event or namespace */
  ws?: string;
}

export interface UniversalRouteOptions {
  /** Which server types this route can be registered to */
  accepts: AllowedRouteTypes | AllowedRouteTypes[];
  /** Per-protocol paths */
  paths: UniversalRoutePaths;
  /** HTTP/GraphQL verb (ignored for WS) */
  method: UniversalRouteMethod;
  /** Human-readable summary */
  description: string;
  /** Optional middleware stack executed before handler */
  middlewares?: Array<Middleware>;
  /** GraphQL type definitions for this route */
  graphqlTypeDefs?: string;
  /** Main handler */
  func: (input: any, context: any) => Promise<any>;
  /** Optional handler */
  handle?: (input: any, context: any) => Promise<any>;
}

export interface Middleware {
  execute?: (input: any, context: any) => Promise<void> | void;
  parse?: (input: any, context: any) => Promise<void> | void;
  process?: (input: any, context: any) => Promise<void> | void;
}

export class UniversalRoute implements UniversalRouteOptions {
  accepts: AllowedRouteTypes | AllowedRouteTypes[];
  paths: UniversalRoutePaths;
  method: UniversalRouteMethod;
  description: string;
  graphqlTypeDefs: string;
  middlewares: Middleware[] | undefined;
  func: (input: any, context: any) => Promise<any>;
  listen: ((input: any, context: any) => Promise<any>) | undefined;

  constructor(options: UniversalRouteOptions) {
    this.accepts = options.accepts;
    this.paths = options.paths;
    this.method = options.method;
    this.description = options.description;
    this.graphqlTypeDefs = options.graphqlTypeDefs || '';
    this.middlewares = options.middlewares;
    this.func = options.func;
    this.listen = options.handle;
  }
}
