import Link from 'next/link';

const Footer = () => {
  return (
    <footer className="bg-gray-800 text-white py-8">
      <div className="container mx-auto px-4">
        <div className="flex justify-between items-center">
          <div>
            <h3 className="text-lg font-bold">{"{{ cookiecutter.project_name }}"}</h3>
            <p className="text-sm">&copy; {new Date().getFullYear()} {"{{ cookiecutter.project_name }}"}. All rights reserved.</p>
          </div>
          <div className="space-x-4">
            <Link href="/">
              Home
            </Link>
            <Link href="/about">
              About
            </Link>
          </div>
        </div>
      </div>
    </footer>
  );
};

export default Footer;
