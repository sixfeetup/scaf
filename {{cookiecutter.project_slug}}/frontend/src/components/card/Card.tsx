import { ReactNode } from 'react'
import styles from './Card.module.css'

interface props {
  heading?: string
  body?: ReactNode
  footer?: string
}

const Card = (props: props) => {
  return (
    <div data-testid='Card' className={styles.card}>
      <p data-testid='CardHeading' className={styles.heading}>
        {props.heading}
      </p>
      <p data-testid='CardBody' className={styles.body}>
        {props.body}
      </p>
      <p data-testid='CardFooter' className={styles.footer}>
        {props.footer}
      </p>
    </div>
  )
}

export default Card
