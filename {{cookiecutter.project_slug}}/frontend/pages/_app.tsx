import { ApolloProvider } from '@apollo/client'
import type { AppProps } from 'next/app'

import { useApollo } from '../lib/apolloClient'

import ErrorBoundary from '@/components/ErrorBoundary'
import Layout from '@/components/Layout'
import '@/styles/globals.css'

export default function App({ Component, pageProps }: AppProps) {
  const apolloClient = useApollo(pageProps)
  return (
    <ErrorBoundary>
      <ApolloProvider client={apolloClient}>
        <Layout>
          <Component {...pageProps} />
        </Layout>
      </ApolloProvider>
    </ErrorBoundary>
  )
}
