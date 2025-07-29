module.exports = {
  apps: [
    {
      name: 'workplan-backend',
      script: 'server.js',
      cwd: './backend',
      instances: 'max', // หรือระบุจำนวน เช่น 2
      exec_mode: 'cluster',
      env: {
        NODE_ENV: 'development',
        PORT: 3101
      },
      env_production: {
        NODE_ENV: 'production',
        PORT: 3101,
        DB_HOST: 'localhost',
        DB_USER: 'root',
        DB_PASSWORD: 'your_production_password',
        DB_NAME: 'workplan',
        DB_PORT: 3306,
        API_RATE_LIMIT: 100,
        CORS_ORIGINS: 'http://localhost:3011,http://your-domain.com'
      },
      error_file: './logs/err.log',
      out_file: './logs/out.log',
      log_file: './logs/combined.log',
      time: true,
      max_memory_restart: '1G',
      node_args: '--max-old-space-size=1024'
    },
    {
      name: 'workplan-frontend',
      script: 'npm',
      args: 'start',
      cwd: './frontend',
      env: {
        NODE_ENV: 'development',
        PORT: 3011
      },
      env_production: {
        NODE_ENV: 'production',
        PORT: 3011,
        NEXT_PUBLIC_API_URL: 'http://localhost:3101',
        NEXT_PUBLIC_APP_ENV: 'production',
        NEXT_PUBLIC_APP_VERSION: '1.0.0'
      },
      error_file: './logs/frontend-err.log',
      out_file: './logs/frontend-out.log',
      log_file: './logs/frontend-combined.log',
      time: true,
      max_memory_restart: '1G'
    }
  ],

  deploy: {
    production: {
      user: 'your-username',
      host: 'your-server-ip',
      ref: 'origin/main',
      repo: 'https://github.com/iTjitdhana/WorkplanV5.git',
      path: '/var/www/workplan',
      'pre-deploy-local': '',
      'post-deploy': 'npm install && pm2 reload ecosystem.config.js --env production',
      'pre-setup': ''
    }
  }
}; 