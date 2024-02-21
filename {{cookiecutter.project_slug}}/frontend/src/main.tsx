import React from 'react'
import ReactDOM from 'react-dom/client'
import App from './App'
import './index.css'
import { QueryClient, QueryClientProvider } from '@tanstack/react-query'

{% if cookiecutter.use_sentry == 'y' %}
import * as Sentry from '@sentry/react';
import { BrowserTracing } from "@sentry/tracing";
{% endif %}

{% if cookiecutter.use_sentry == 'y' %}
const sentry_dsn = `https://${import.meta.env?.VITE_SENTRY_DSN_FRONTEND}`;
Sentry.init({
  dsn: import.meta.env?.VITE_SENTRY_DSN_FRONTEND ? sentry_dsn : '',
  environment: import.meta.env?.VITE_ENVIRONMENT ? import.meta.env?.VITE_ENVIRONMENT : 'production',
  release: import.meta.env?.VITE_RELEASE ? import.meta.env?.VITE_RELEASE : 'dev',
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
