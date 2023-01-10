import { useQuery } from '@tanstack/react-query'

import Card from 'components/card/Card'

import styles from './Home.module.css'
import { fetchMe } from './Home.queries'
const Home = () => {
  const { data, isLoading, error } = useQuery(['me'], fetchMe)
  console.log(isLoading, data, error)
  return (
    <div className={styles.Home}>
      {isLoading ? (
        <div>Loading...</div>
      ) : (
        <Card
          heading='Cookie Cutter'
          body='🚀 Vite + React + Typescript 🤘 & Eslint 🔥+ Prettier'
          footer='This is cookie cutter template'
        />
      )}
    </div>
  )
}
export default Home
