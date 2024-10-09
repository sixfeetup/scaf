import React from 'react'
import { render } from '@testing-library/react'
import { MockedProvider, MockedResponse } from '@apollo/client/testing'

type Options = {
  mocks?: MockedResponse[]
}
const renderWithProviders = (ui: React.ReactElement, options: Options = {}) => {
  render(
    <MockedProvider mocks={options.mocks} addTypename={false}>
      {ui}
    </MockedProvider>
  )
}

export * from '@testing-library/react'
export { renderWithProviders as render }
export { userEvent } from '@testing-library/user-event'
