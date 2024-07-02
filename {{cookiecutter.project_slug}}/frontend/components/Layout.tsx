import { Inter } from 'next/font/google'
import { ReactNode } from 'react'

import Footer from './Footer'
import NavBar from './NavBar'

const inter = Inter({ subsets: ['latin'] })

const Layout = ({ children }: { children: ReactNode }) => {
  return (
    <div className={`${inter.className}`}>
      <NavBar />
      <main className={`container mx-auto min-h-48 ${inter.className}`}>{children}</main>
      <Footer />
    </div>
  )
}

export default Layout
