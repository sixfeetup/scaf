import { expect, test } from 'vitest'
import AboutPage from '../pages/about'
import { GET_ME } from '@/pages'
import { render, screen } from '@/utils/test-utils'

const mocks = [
  {
    request: {
      query: GET_ME
    },
    result: {
      data: {
        me: { id: '1', name: 'John Doe' }
      }
    }
  }
]

test('AboutPage', async () => {
  render(<AboutPage />, { mocks })
  expect(await screen.findByRole('heading', { level: 1, name: 'About Page' })).toBeInTheDocument()
  expect(await screen.findByText('John Doe')).toBeInTheDocument()
})
