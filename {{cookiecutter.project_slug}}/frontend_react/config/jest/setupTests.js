import '@testing-library/jest-dom/extend-expect'
import React from 'react'

window.matchMedia = query => ({
  matches: false,
  media: query,
  onchange: null,
  addEventListener: jest.fn(),
  removeEventListener: jest.fn(),
  dispatchEvent: jest.fn(),
  addListener: jest.fn(),
  removeListener: jest.fn()
})

Object.defineProperty(URL, 'createObjectURL', {
  writable: true,
  value: jest.fn()
})

window.React = React
