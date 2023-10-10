import '@/styles/globals.css';
import MSNavbar from "@/components/Home/MSNavbar";
import Navbar from "@/components/Navbar";

import { UserProvider } from '@/context/UserContext';

export default function App({ Component, pageProps }) {
  return (
    <UserProvider>
      <div className="w-full max-md:hidden">
        <Navbar />
      </div>

      <div className="w-full md:hidden ">
        <MSNavbar />
      </div>
      <Component {...pageProps} />
    </UserProvider>
  )
}
