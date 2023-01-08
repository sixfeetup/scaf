import Card from 'components/card/Card'
import styles from './Home.module.css'
const Home = () => {
	return (
		<div className={styles.Home}>
			<Card
				heading='Cookie Cutter'
				body='🚀 Vite + React + Typescript 🤘 & Eslint 🔥+ Prettier'
				footer='This is cookie cutter template'
			/>
		</div>
	)
}
export default Home
