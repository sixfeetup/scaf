import React from 'react'
import ReactDOM from 'react-dom/client'
import App from './App'
import './index.css'
import { QueryClient, QueryClientProvider } from '@tanstack/react-query'

import * as Sentry from '@sentry/react';
import { BrowserTracing } from "@sentry/tracing";

Sentry.init({
  dsn: `https://${process.env.SENTRY_DSN_FRONTEND}`,
  environment: `${process.env.ENVIRONMENT}`,
  release: `${process.env.RELEASE}`,
  integrations: [new BrowserTracing()],

  tracesSampleRate: 1.0
});

const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      staleTime: Number.POSITIVE_INFINITY,
      retry: 1
    }
  }
})

ReactDOM.createRoot(document.getElementById('root') as HTMLElement).render(
  <React.StrictMode>
    <QueryClientProvider client={queryClient}>
      <App />
    </QueryClientProvider>
  </React.StrictMode>
)
