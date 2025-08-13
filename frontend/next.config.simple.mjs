/** @type {import('next').NextConfig} */
const nextConfig = {
  // Basic production settings
  // output: 'standalone', // Disabled for now to fix start issues
  poweredByHeader: false,
  compress: true,
  
  // Image optimization
  images: {
    domains: ['localhost', '192.168.0.94', '192.168.0.93'],
    formats: ['image/webp', 'image/avif'],
  },
  
  // Security headers
  async headers() {
    return [
      {
        source: '/(.*)',
        headers: [
          {
            key: 'X-Frame-Options',
            value: 'DENY',
          },
          {
            key: 'X-Content-Type-Options',
            value: 'nosniff',
          },
          {
            key: 'Referrer-Policy',
            value: 'origin-when-cross-origin',
          },
        ],
      },
    ]
  },
  
  // Environment variables
  env: {
    CUSTOM_KEY: process.env.CUSTOM_KEY,
  },
}

export default nextConfig
