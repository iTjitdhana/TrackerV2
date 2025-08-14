const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const rateLimit = require('express-rate-limit');
const compression = require('compression');
const path = require('path');

// Load environment variables
require('dotenv').config({ path: './production.env' });

const app = express();
const PORT = process.env.PORT || 3101;

// Performance optimizations
app.use(compression()); // Enable gzip compression
app.use(helmet({
  contentSecurityPolicy: false,
  crossOriginEmbedderPolicy: false,
}));

// Rate limiting for API protection (very relaxed for development)
const limiter = rateLimit({
  windowMs: 1 * 60 * 1000, // 1 minute (reduced from 15 minutes)
  max: 10000, // limit each IP to 10000 requests per minute (increased from 1000)
  message: 'Too many requests from this IP, please try again later.',
  standardHeaders: true,
  legacyHeaders: false,
  skipSuccessfulRequests: true, // Don't count successful requests
  skipFailedRequests: false, // Count failed requests
  keyGenerator: (req) => {
    // Use a more specific key to avoid conflicts
    return req.ip + ':' + req.path;
  }
});

// Rate limiting disabled for development
// app.use('/api/work-plans', limiter); // Disabled
// app.use('/api/users', limiter); // Disabled
// app.use('/api/machines', limiter); // Disabled
// app.use('/api/production-rooms', limiter); // Disabled
// Don't apply rate limiting to logs and other read-only endpoints

// CORS configuration
app.use(cors({
  origin: process.env.NODE_ENV === 'production' 
    ? ['http://192.168.0.222:3012', 'http://localhost:3012', 'http://127.0.0.1:3012']
    : true,
  credentials: true,
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization'],
}));

// Body parsing middleware
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true, limit: '10mb' }));

// Static file serving with caching
app.use('/static', express.static(path.join(__dirname, 'public'), {
  maxAge: '1y',
  etag: true,
  lastModified: true,
}));

// Health check endpoint
app.get('/health', (req, res) => {
  res.status(200).json({ 
    status: 'OK', 
    timestamp: new Date().toISOString(),
    uptime: process.uptime(),
    memory: process.memoryUsage(),
  });
});

// API routes
app.use('/api/logs', require('./routes/logRoutes'));
app.use('/api/machines', require('./routes/machineRoutes'));
app.use('/api/new-jobs', require('./routes/newJobsRoutes'));
app.use('/api/production-rooms', require('./routes/productionRoomRoutes'));
app.use('/api/production-status', require('./routes/productionStatusRoutes'));
app.use('/api/work-plans', require('./routes/workPlanRoutes'));
app.use('/api/users', require('./routes/userRoutes'));
app.use('/api/reports', require('./routes/reportRoutes'));
app.use('/api/settings', require('./routes/settingsRoutes'));
app.use('/api/monitoring', require('./routes/monitoringRoutes'));
app.use('/api/process-steps', require('./routes/processStepRoutes'));
app.use('/api/send-to-google-sheet', require('./routes/googleSheetProxy'));

// Error handling middleware
app.use((err, req, res, next) => {
  console.error('Error:', err);
  res.status(500).json({ 
    error: 'Internal Server Error',
    message: process.env.NODE_ENV === 'development' ? err.message : 'Something went wrong'
  });
});

// 404 handler
app.use('*', (req, res) => {
  res.status(404).json({ error: 'Route not found' });
});

// Graceful shutdown
process.on('SIGTERM', () => {
  console.log('SIGTERM received, shutting down gracefully');
  server.close(() => {
    console.log('Process terminated');
    process.exit(0);
  });
});

const server = app.listen(PORT, '0.0.0.0', () => {
  console.log(`🚀 Server running on port ${PORT}`);
  console.log(`📊 Health check: http://localhost:${PORT}/health`);
  console.log(`🌍 External access: http://192.168.0.222:${PORT}/health`);
  console.log(`🌍 Environment: ${process.env.NODE_ENV || 'development'}`);
});

// Keep-alive timeout
server.keepAliveTimeout = 65000;
server.headersTimeout = 66000;

module.exports = app;
