import { useQuery } from '@tanstack/react-query'

import Card from 'components/card/Card'
import { ReactComponent as RocketIcon } from 'assets/rocket.svg'

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
          body={
            <>
              <RocketIcon /> Vite + React + Typescript 🤘 & Eslint 🔥+ Prettier
            </>
          }
          footer='This is cookie cutter template'
        />
      )}
    </div>
  )
}
export default Home
