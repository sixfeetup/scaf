import { lazy, Suspense } from 'react'
import { BrowserRouter, Route, Routes as RRDRoutes } from 'react-router-dom'
import SuspenseFallback from 'components/SuspenseFallback'

const NotFound = lazy(() => import('pages/NotFound'))
const Home = lazy(async () => import('pages/Home'))

const Routes = () => {
  return (
    <BrowserRouter>
      <Suspense fallback={<SuspenseFallback />}>
        <RRDRoutes>
          <Route path='/' element={<Home />} />
          <Route path='*' element={<NotFound />} />
        </RRDRoutes>
      </Suspense>
    </BrowserRouter>
  )
}

export default Routes
