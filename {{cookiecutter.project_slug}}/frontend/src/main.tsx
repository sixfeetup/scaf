import React from 'react'
import ReactDOM from 'react-dom/client'
import App from './App'
import './index.css'
import { QueryClient, QueryClientProvider } from '@tanstack/react-query'

{% if cookiecutter.use_sentry == 'y' %}
import * as Sentry from '@sentry/react';
{% endif %}
import { BrowserTracing } from "@sentry/tracing";

{% if cookiecutter.use_sentry == 'y' %}
Sentry.init({
  dsn: `https://${process.env.SENTRY_DSN_FRONTEND}`,
  environment: `${process.env.ENVIRONMENT}`,
  release: `${process.env.RELEASE}`,
  integrations: [new BrowserTracing()],
  tracesSampleRate: 1.0
});
{% endif %}

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
