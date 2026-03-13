import { logger } from "./logger.ts";
import type { AppConfig } from "../interfaces/config.ts";

// Deep merge utility
function deepMerge(target: any, source: any): any {
  const result = { ...target };
  for (const key in source) {
    if (source[key] !== null && typeof source[key] === 'object' && !Array.isArray(source[key])) {
      result[key] = deepMerge(target[key] || {}, source[key]);
    } else {
      result[key] = source[key];
    }
  }
  return result;
}

export class ConfigService {
  private static instance: ConfigService;
  private config: AppConfig | null = null;
  private configPath: string = './config.json';
  private watchInterval: number | null = null;
  private listeners: Array<() => void> = [];

  private constructor() {}

  public static getInstance(): ConfigService {
    if (!ConfigService.instance) {
      ConfigService.instance = new ConfigService();
    }
    return ConfigService.instance;
  }

  public async load(configPath?: string): Promise<AppConfig> {
    if (this.config) {
      return this.config;
    }

    if (configPath) {
      this.configPath = configPath;
    }

    // Start with empty config
    let mergedConfig: any = {};

    // 1. Load .env file (base values)
    try {
      const envConfig = await this.loadFromEnvFile();
      mergedConfig = deepMerge(mergedConfig, envConfig);
      logger.debug('Loaded configuration from .env file');
    } catch {
      logger.debug('No .env file found or error loading it');
    }

    // 2. Load config.json (overrides .env)
    try {
      const jsonConfig = await this.loadFromJsonFile('./config.json');
      mergedConfig = deepMerge(mergedConfig, jsonConfig);
      logger.debug('Loaded configuration from config.json');
    } catch {
      logger.debug('No config.json found or error loading it');
    }

    // 3. Load config.toml (overrides json)
    try {
      const tomlConfig = await this.loadFromTomlFile('./config.toml');
      mergedConfig = deepMerge(mergedConfig, tomlConfig);
      logger.debug('Loaded configuration from config.toml');
    } catch {
      logger.debug('No config.toml found or error loading it');
    }

    // 4. Apply environment variable overrides
    mergedConfig = this.applyEnvOverrides(mergedConfig);

    // 5. Apply CLI argument overrides
    mergedConfig = this.applyCliOverrides(mergedConfig);

    this.config = mergedConfig as AppConfig;
    logger.info(`Configuration loaded for environment: ${this.config.environment}`);

    // Export communication and other critical config values to env vars
    // so services like EmailService can read them via Deno.env.get()
    this.exportConfigToEnv(this.config);

    return this.config;
  }

  public getConfig(): AppConfig {
    if (!this.config) {
      throw new Error("Config not loaded. Call load() first.");
    }
    return this.config;
  }

  public async reload(): Promise<AppConfig> {
    this.config = null;
    const newConfig = await this.load();
    this.notifyListeners();
    return newConfig;
  }

  public onReload(listener: () => void): void {
    this.listeners.push(listener);
  }

  public startWatching(intervalMs: number = 5000): void {
    if (this.watchInterval) return;
    
    this.watchInterval = setInterval(async () => {
      // Simple reload on interval - could be enhanced with file watching
      try {
        await this.reload();
        logger.info('Configuration reloaded');
      } catch (error) {
        logger.error('Failed to reload configuration', error);
      }
    }, intervalMs);
  }

  public stopWatching(): void {
    if (this.watchInterval) {
      clearInterval(this.watchInterval);
      this.watchInterval = null;
    }
  }

  private notifyListeners(): void {
    this.listeners.forEach(listener => {
      try {
        listener();
      } catch (error) {
        logger.error('Config reload listener failed', error);
      }
    });
  }

  private async loadFromEnvFile(): Promise<any> {
    const envPath = './.env';
    try {
      const envContent = await Deno.readTextFile(envPath);
      const config: any = {};

      for (const line of envContent.split('\n')) {
        const trimmed = line.trim();
        if (!trimmed || trimmed.startsWith('#')) continue;
        
        const equalIndex = trimmed.indexOf('=');
        if (equalIndex === -1) continue;
        
        const key = trimmed.substring(0, equalIndex).trim();
        let value = trimmed.substring(equalIndex + 1).trim();
        
        // Remove quotes if present
        if ((value.startsWith('"') && value.endsWith('"')) || 
            (value.startsWith("'") && value.endsWith("'"))) {
          value = value.slice(1, -1);
        }

        // Parse nested keys (e.g., SMTP_HOST -> communications.email.host)
        this.parseNestedKey(config, key, value);
      }

      return config;
    } catch {
      return {};
    }
  }

  private parseNestedKey(config: any, key: string, value: string): void {
    // Map common env vars to config structure
    const mappings: Record<string, string[]> = {
      'PORT': ['port'],
      'HOST': ['host'],
      'ENVIRONMENT': ['environment'],
      'LOG_LEVEL': ['logLevel'],
      'MONGODB_URI_CLOUD': ['mongodb', 'uri'],
      'MONGODB_CERT_CLOUD': ['mongodb', 'cert'],
      'MONGO_USER': ['mongodb', 'user'],
      'MONGO_PASSWORD': ['mongodb', 'password'],
      'DB_RECONNECT_TIME_SECONDS': ['mongodb', 'reconnectTimeSeconds'],
      'REDIS_HOST': ['redis', 'host'],
      'REDIS_PORT': ['redis', 'port'],
      'JWT_SECRET': ['jwtSecret'],
      'SMTP_HOST': ['communications', 'email', 'host'],
      'SMTP_PORT': ['communications', 'email', 'port'],
      'SMTP_USER': ['communications', 'email', 'user'],
      'SMTP_PASS': ['communications', 'email', 'pass'],
      'SMTP_FROM': ['communications', 'email', 'from'],
      'SMTP_FROM_NAME': ['communications', 'email', 'fromName'],
      'MICROSOFT_CLIENT_ID': ['oauth', 'microsoft', 'clientId'],
      'MICROSOFT_TENANT_ID': ['oauth', 'microsoft', 'tenantId'],
      'MICROSOFT_CLIENT_SECRET': ['oauth', 'microsoft', 'clientSecret'],
      'GOOGLE_WEB_CLIENT_ID': ['oauth', 'google', 'webClientId'],
      'GOOGLE_WEB_CLIENT_SECRET': ['oauth', 'google', 'webClientSecret'],
    };

    const path = mappings[key] || [key.toLowerCase()];
    let current = config;
    
    for (let i = 0; i < path.length - 1; i++) {
      if (!current[path[i]]) {
        current[path[i]] = {};
      }
      current = current[path[i]];
    }
    
    // Try to parse as number or boolean
    const lastKey = path[path.length - 1];
    if (value === 'true') {
      current[lastKey] = true;
    } else if (value === 'false') {
      current[lastKey] = false;
    } else if (!isNaN(Number(value)) && value !== '') {
      current[lastKey] = Number(value);
    } else {
      current[lastKey] = value;
    }
  }

  private async loadFromJsonFile(path: string): Promise<any> {
    const content = await Deno.readTextFile(path);
    const parsed = JSON.parse(content);
    
    // Get current environment
    const env = Deno.env.get("ENVIRONMENT") || parsed.default?.environment || "local";
    
    // Merge default with environment-specific config
    let merged = { ...parsed.default };
    if (parsed[env] && env !== 'default') {
      merged = deepMerge(merged, parsed[env]);
    }
    
    return merged;
  }

  private async loadFromTomlFile(path: string): Promise<any> {
    // Simple TOML parser for our use case
    const content = await Deno.readTextFile(path);
    const parsed = this.parseToml(content);
    
    const env = Deno.env.get("ENVIRONMENT") || parsed.default?.environment || "local";
    
    let merged = { ...parsed.default };
    if (parsed[env] && env !== 'default') {
      merged = deepMerge(merged, parsed[env]);
    }
    
    return merged;
  }

  private parseToml(content: string): any {
    const result: any = { default: {} };
    let currentSection = 'default';
    let currentTable: any = result.default;
    const tableStack: string[] = [];

    for (const line of content.split('\n')) {
      const trimmed = line.trim();
      if (!trimmed || trimmed.startsWith('#')) continue;

      // Table header [section] or [section.subsection]
      if (trimmed.startsWith('[') && trimmed.endsWith(']')) {
        const tablePath = trimmed.slice(1, -1);
        const parts = tablePath.split('.');
        
        if (tablePath.startsWith('default.')) {
          // Nested table under default
          currentSection = 'default';
          currentTable = result.default;
          const subParts = parts.slice(1);
          for (const part of subParts) {
            if (!currentTable[part]) {
              currentTable[part] = {};
            }
            currentTable = currentTable[part];
          }
        } else {
          // Top-level section
          currentSection = parts[0];
          if (!result[currentSection]) {
            result[currentSection] = {};
          }
          currentTable = result[currentSection];
        }
        continue;
      }

      // Key = value
      const equalIndex = trimmed.indexOf('=');
      if (equalIndex === -1) continue;

      const key = trimmed.substring(0, equalIndex).trim();
      let value = trimmed.substring(equalIndex + 1).trim();

      // Parse value
      if (value.startsWith('"') && value.endsWith('"')) {
        value = value.slice(1, -1);
      } else if (value === 'true') {
        value = true as any;
      } else if (value === 'false') {
        value = false as any;
      } else if (!isNaN(Number(value)) && value !== '') {
        value = Number(value) as any;
      }

      currentTable[key] = value;
    }

    return result;
  }

  private applyEnvOverrides(config: any): any {
    const overrides: any = {};

    if (Deno.env.get("PORT")) overrides.port = parseInt(Deno.env.get("PORT")!, 10);
    if (Deno.env.get("HOST")) overrides.host = Deno.env.get("HOST");
    if (Deno.env.get("LOG_LEVEL")) overrides.logLevel = Deno.env.get("LOG_LEVEL");
    if (Deno.env.get("ENVIRONMENT")) overrides.environment = Deno.env.get("ENVIRONMENT");

    return deepMerge(config, overrides);
  }

  private applyCliOverrides(config: any): any {
    const overrides: any = {};

    for (let i = 0; i < Deno.args.length; i++) {
      const arg = Deno.args[i];
      
      if ((arg === '--port' || arg === '-p') && i + 1 < Deno.args.length) {
        overrides.port = parseInt(Deno.args[i + 1], 10);
        i++;
      } else if (arg.startsWith('--port=')) {
        overrides.port = parseInt(arg.split('=')[1], 10);
      } else if ((arg === '--host' || arg === '-h') && i + 1 < Deno.args.length) {
        overrides.host = Deno.args[i + 1];
        i++;
      } else if (arg.startsWith('--host=')) {
        overrides.host = arg.split('=')[1];
      }
    }

    return deepMerge(config, overrides);
  }

  private exportConfigToEnv(config: AppConfig): void {
    try {
      // Export communications config to env vars for services that read them
      if (config.communications?.email) {
        const email = config.communications.email;
        if (email.host) Deno.env.set("SMTP_HOST", email.host);
        if (email.port) Deno.env.set("SMTP_PORT", String(email.port));
        if (email.user) Deno.env.set("SMTP_USER", email.user);
        if (email.pass) Deno.env.set("SMTP_PASS", email.pass);
        if (email.from) Deno.env.set("SMTP_FROM", email.from);
        if (email.fromName) Deno.env.set("SMTP_FROM_NAME", email.fromName);
        logger.debug("Exported email configuration to environment variables");
      }

      // Export other critical configs that services might expect from env
      if (config.jwtSecret) Deno.env.set("JWT_SECRET", config.jwtSecret);
      if (config.environment) Deno.env.set("ENVIRONMENT", config.environment);
    } catch (error) {
      logger.error("Failed to export config to environment variables", error);
    }
  }
}

export const configService = ConfigService.getInstance();
