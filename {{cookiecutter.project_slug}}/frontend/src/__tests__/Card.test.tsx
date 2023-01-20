import { render } from '@testing-library/react'
import Card from '../components/card/Card'

const defaultProps = {
  heading: 'heading',
  body: 'body',
  footer: 'footer'
}

describe('Card', () => {
  it('should mount', () => {
    const { getByTestId } = render(<Card />)
    expect(getByTestId('Card')).toBeInTheDocument()
  })

  describe('Given Props', () => {
    it('should render heading, body and footer from props', () => {
      const { getByTestId } = render(<Card {...defaultProps} />)

      const heading = getByTestId('CardHeading')
      const body = getByTestId('CardBody')
      const footer = getByTestId('CardFooter')

      expect(heading.innerHTML).toEqual('heading')
      expect(body.innerHTML).toEqual('body')
      expect(footer.innerHTML).toEqual('footer')
    })
  })
  describe('Not Given Props', () => {
    it('should have empty heading, body and footer', () => {
      const { getByTestId } = render(<Card />)

      const heading = getByTestId('CardHeading')
      const body = getByTestId('CardBody')
      const footer = getByTestId('CardFooter')

      expect(heading.innerHTML).toEqual('')
      expect(body.innerHTML).toEqual('')
      expect(footer.innerHTML).toEqual('')
    })
  })
})
