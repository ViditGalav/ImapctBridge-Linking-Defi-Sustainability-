import Client from "@/utils/SanityClientSetup";
import Link from "next/link";
import { useState } from "react";
import { useRouter } from "next/router";
import md5 from "md5";
import { BeatLoader } from 'react-spinners';
import { IoCloudDone } from 'react-icons/io5';


const commonInputStyle = "outline-none border-[0.5px] border-gray-300 rounded-sm py-1 px-2";
const commonBtnStyle = "text-white bg-blue-600 hover:bg-blue-500 transition-all duration-300 rounded-sm py-1 px-5";


export default function Login() {
  const router = useRouter();
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [contactNo, setContactNo] = useState("");
  const [wrongUser, setWrongUser] = useState(false);
  const [fields, setFields] = useState(false);
  const [loading, setLoading] = useState(false);
  const [isAuthenticated, setIsAuthenticated] = useState(false);

  const handleLogin = () => {
    setLoading(true);
    if (email && password && contactNo) {
      Client.fetch(`*[ _type == 'user' && email == '${email}' && contactNo == '${contactNo}' && password == '${md5(password)}']`)
        .then((data) => {
          // console.log(data);
          if (!data[0]) {
            setWrongUser(true);
          } else {
            setLoading(false);
            setIsAuthenticated(true);
            setTimeout(() => {
              localStorage.setItem("ImpactBridgeAuth", data[0]?._id);
              router.push("/");
            }, 2000);
          }
        })
    } else {
      setFields(true);
      setTimeout(() => {
        setFields(false);
      }, 3000);
    }
  }



  return (
    <div className="w-full h-screen flex items-center justify-center bg-gradient-to-t from-black to-violet-950">
      <div className="w-1/3 max-md:w-2/3 max-sm:w-11/12 animate-fade-in-up bg-gradient-to-t from-black to-violet-900 rounded-3xl shadow-lg p-6 max-sm:p-4">
        <div>
          <h1 className="text-white text-2xl font-semibold max-sm:text-xl">Login here</h1>
        </div>
        <div className="my-5 max-sm:my-3 px-5 max-sm:px-2 flex flex-col">

          <div className="my-2">
            {fields && (<p className="py-2 text-center w-full bg-red-500 text-white rounded-md animate-fade-in-up transition-all duration-200 ease-linear">Input all the fields correctly!</p>)}

            {wrongUser && (<p className="py-2 text-center w-full bg-red-500 text-white rounded-md animate-fade-in-up transition-all duration-200 ease-linear">User not exists! <Link 
              href={"/auth/signup"}
              className="text-blue-500 underline"
            >Signup</Link></p>)}
          </div>

          <div className="flex flex-col my-2">
            <p className="text-gray-300">Email</p>
            <input type="email" name="email" className={commonInputStyle} onChange={(e) => setEmail(e.target.value)} required />
          </div>

          <div className="flex flex-col my-2">
            <p className="text-gray-300">Contact no</p>
            <input type="number" name="contactNo" className={commonInputStyle} onChange={(e) => setContactNo(e.target.value)} required />
          </div>

          <div className="flex flex-col my-2">
            <p className="text-gray-300">Password</p>
            <input type="password" name="password" className={commonInputStyle} onChange={(e) => setPassword(e.target.value)} required />
          </div>

          {!loading && !isAuthenticated && (<div className="flex justify-between items-center">
            <button type="button" className={commonBtnStyle} onClick={handleLogin}>Login</button>
            <Link href="/auth/forgot-password" className="text-gray-500">Forgot Password?</Link>
          </div>)}

          {loading && (
            <div className="flex my-2 justify-between animate-fade-in duration-300 ease-linear">
              <BeatLoader color="#36d7b7" />
            </div>
          )}

          {isAuthenticated && (
            <div className="flex items-center my-2 justify-between animate-fade-in duration-300 ease-linear">
              <p className="mr-2 text-blue-500">You are authenticated!</p>
              <IoCloudDone fontSize={30} color="#36d7b7" />
            </div>
          )}

          <div className="flex items-center justify-between mt-3">
            <div className="w-2" />
            <Link className="text-blue-300 hover:text-blue-100 transition-all duration-300 ease-in-out underline" href="/auth/signup">New user?</Link>
          </div>
        </div>
      </div>
    </div>
  )
}
