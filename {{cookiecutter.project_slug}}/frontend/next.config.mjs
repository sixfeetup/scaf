import { withSentryConfig } from '@sentry/nextjs'

/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  output: 'standalone'
}

export default withSentryConfig(nextConfig, {
  sourcemaps: {
    disable: true
  },
  hideSourceMaps: true
})
