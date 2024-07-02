import Image from 'next/image';
import Link from 'next/link'

const NavBar = () => {
  return (
    <nav className='bg-gray-800 p-4'>
      <div className='container mx-auto'>
        <div className='flex gap-4 items-center text-white text-lg font-bold'>
          <Image src='/scaf-logo.png' alt='Scaf Logo' width={60} height={75} />
          <Link href='/'>Home</Link>
          <Link href='/about'>About</Link>
        </div>
      </div>
    </nav>
  )
}

export default NavBar
