import { expect, test } from 'vitest'
import { render, screen } from '@testing-library/react'
import AboutPage from '../pages/about'
 
test('AboutPage', () => {
  render(<AboutPage />)
  expect(screen.getByRole('heading', { level: 1, name: 'About Page' })).toBeDefined()
})