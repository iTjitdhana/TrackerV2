// Configuration file for environment variables and constants

export const config = {
  // API Configuration
  api: {
    baseUrl: process.env.NEXT_PUBLIC_API_URL || 'http://localhost:3102',
    timeout: 30000, // 30 seconds
    retryAttempts: 3,
  },
  
  // Development Configuration
  development: {
    enableDebugLogs: process.env.NODE_ENV === 'development',
    enablePerformanceMonitoring: process.env.NODE_ENV === 'development',
  },
  
  // Production Configuration
  production: {
    enableErrorReporting: true,
    enableAnalytics: true,
  },
  
  // UI Configuration
  ui: {
    debounceDelay: 150, // milliseconds
    throttleDelay: 100, // milliseconds
    maxSearchResults: 20,
    maxCacheSize: 50,
  },
  
  // Time Configuration
  time: {
    defaultStartTime: '08:00',
    defaultEndTime: '18:00',
    timeStep: 15, // minutes
    dateFormat: 'YYYY-MM-DD',
    timeFormat: 'HH:mm',
  },
  
  // Validation Configuration
  validation: {
    minJobNameLength: 2,
    maxJobNameLength: 100,
    maxNoteLength: 500,
    maxOperators: 4,
  },
} as const;

// Helper functions
export const getApiUrl = (endpoint: string): string => {
  const baseUrl = config.api.baseUrl.replace(/\/$/, ''); // Remove trailing slash
  const cleanEndpoint = endpoint.replace(/^\//, ''); // Remove leading slash
  return `${baseUrl}/${cleanEndpoint}`;
};

export const isDevelopment = (): boolean => {
  return process.env.NODE_ENV === 'development';
};

export const isProduction = (): boolean => {
  return process.env.NODE_ENV === 'production';
};

// Debug logging utility
export const debugLog = (message: string, data?: any): void => {
  if (config.development.enableDebugLogs) {
    console.log(`[DEBUG] ${message}`, data || '');
  }
};

export const debugError = (message: string, error?: any): void => {
  if (config.development.enableDebugLogs) {
    console.error(`[ERROR] ${message}`, error || '');
  }
};
