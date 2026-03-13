export interface MongoDBConfig {
  uri?: string;
  cert?: string;
  user?: string;
  password?: string;
  reconnectTimeSeconds?: number;
}

export interface RedisConfig {
  host?: string;
  port?: number;
}

export interface EmailConfig {
  host?: string;
  port?: number;
  user?: string;
  pass?: string;
  from?: string;
  fromName?: string;
}

export interface CommunicationsConfig {
  email?: EmailConfig;
  sms?: {
    provider?: string;
    apiKey?: string;
  };
  push?: {
    provider?: string;
    apiKey?: string;
  };
}

export interface OAuthProviderConfig {
  clientId?: string;
  clientSecret?: string;
  tenantId?: string;
  webClientId?: string;
  webClientSecret?: string;
}

export interface OAuthConfig {
  microsoft?: OAuthProviderConfig;
  google?: OAuthProviderConfig;
  facebook?: OAuthProviderConfig;
  apple?: OAuthProviderConfig;
  twitter?: OAuthProviderConfig;
}

export interface AppConfig {
  environment: string;
  port: number;
  host: string;
  logLevel?: string;
  jwtSecret?: string;
  mongodb?: MongoDBConfig;
  redis?: RedisConfig;
  communications?: CommunicationsConfig;
  oauth?: OAuthConfig;
}
