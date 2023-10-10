import { useState } from "react";
import Link from "next/link";
import Client from "@/utils/SanityClientSetup";
import md5 from "md5";
import { v4 as uuidv4 } from 'uuid';
import { BeatLoader } from "react-spinners";
import { useRouter } from "next/router";
import {IoCloudDone} from 'react-icons/io5';

const commonInputStyle = "outline-none border-[0.5px] border-gray-300 rounded-sm py-1 px-2";
const commonBtnStyle = "text-white bg-blue-600 hover:bg-blue-500 transition-all duration-300 rounded-sm py-1 px-2";

export default function Signup() {
  const router = useRouter();
  const [fullName, setFullName] = useState("");
  const [email, setEmail] = useState("");
  const [contactNo, setContactNo] = useState("");
  const [role, setRole] = useState("");
  const [password, setPassword] = useState("");
  const [confirmPassword, setConfirmPassword] = useState("");
  const [isMailSent, setIsMailSent] = useState(false);
  const [emailVerified, setEmailVerified] = useState(false);
  const [isMessageSent, setIsMessageSent] = useState(false);
  const [isUser, setIsUser] = useState(null);
  const [fields, setFields] = useState(false);
  const [userVerified, setUserVerified] = useState(false);
  const [isAuthenticated, setIsAuthenticated] = useState(false);


  const sendOTPOnMail = () => {
    if (fullName.length >= 2 && email.length >= 11 && role !== "" && role !== 'none' && password.length >= 8 && (confirmPassword === password) && contactNo.length == 10) {

      Client.fetch(`*[_type == 'user' && (contactNo == '${contactNo}' || email == '${email}')]`)
        .then((data) => {
          if (!data[0]) {
            setIsMailSent(true);
          } else {
            setIsUser(true);
            setTimeout(() => {
              setIsUser(false);
            }, 3000);
          }
        })
        .catch((error) => {
          console.log("Error while checking the user --- ", error);
        })

    } else {
      setFields(true);
      setTimeout(() => {
        setFields(false);
      }, 3000);
    }
  }

  const verifyMail = () => {
    setEmailVerified(true);
    setIsMailSent(false);
  }

  const sentOTPOnContactNo = () => {
    setIsMessageSent(true);
  }

  const verifyMobile = () => {
    setUserVerified(true);
    handleSubmit();
  }

  const handleSubmit = () => {
    const uniqueId = uuidv4();

    const userDoc = {
      _type: 'user',
      _id: uniqueId,
      fullName,
      email,
      role,
      contactNo,
      password: md5(password)
    }

    const clientDoc = {
      _type: role == 'Investor' ? 'investor' : 'projectowner',
      _id: uuidv4(),
      fullName,
      userId: uniqueId
    }

    Client.createIfNotExists(userDoc)
      .then(() => {
        Client.createIfNotExists(clientDoc)
          .then(() => {
            setIsAuthenticated(true);
            setTimeout(() => {
              localStorage.setItem("ImpactBridgeAuth", uniqueId);
              router.push("/");
            }, 2000);
          })
          .catch((console.error));
      })
      .catch((console.error));
  }

  return (
    <div className="w-full h-screen flex items-center justify-center bg-gradient-to-t from-black to-violet-950">
      <div className="w-1/3 max-md:w-2/3 max-sm:w-11/12 animate-fade-in-up bg-gradient-to-t from-black to-violet-900 rounded-3xl shadow-lg p-6 max-sm:p-4">
        <div>
          <h1 className="text-white text-2xl font-semibold max-sm:text-xl">Signup here</h1>
        </div>
        <div className="my-5 max-sm:my-3 px-5 max-sm:px-2 flex flex-col">

          <div className="my-2">
            {fields && (<p className="py-2 text-center w-full bg-red-500 text-white rounded-md animate-fade-in-up transition-all duration-200 ease-linear">Input all the fields correctly!</p>)}

            {isUser && (<p className="py-2 text-center w-full bg-red-500 text-white rounded-md animate-fade-in-up transition-all duration-200 ease-linear">User already exist!</p>)}
          </div>

          <div className="flex flex-col my-2">
            <p className="text-gray-300">Full Name</p>
            <input type="text" name="fullName" className={commonInputStyle} onChange={(e) => setFullName(e.target.value)} required />
            {fullName.length > 0 && fullName.length < 2 && <p className="text-red-500 animate-fade-in transition-all duration-200 ease-linear">at least two character!</p>}
          </div>

          <div className="flex flex-col my-2">
            <p className="text-gray-300">Email</p>
            <input type="email" name="email" className={commonInputStyle} onChange={(e) => setEmail(e.target.value)} required />
            {((email.length > 1 && email.length < 11) && (!email.includes('@') || !email.includes('.'))) && <p className="text-red-500 animate-fade-in transition-all duration-200 ease-linear">input correct email id!</p>}
          </div>

          <div className="flex flex-col my-2">
            <p className="text-gray-300">Role</p>
            <select name="role" onChange={(e) => setRole(e.target.value)} className={`${commonInputStyle} cursor-pointer`}>
              <option value='none'>Select your role</option>
              <option value='projectOwner'>Project Owner</option>
              <option value='investor'>Investor</option>
            </select>
            {(role === "" || role === 'none') && (<p className="text-red-500 animate-fade-in transition-all duration-200 ease-linear">**Required</p>)}
          </div>

          <div className="flex flex-col my-2">
            <p className="text-gray-300">Password</p>
            <input type="password" name="password" className={commonInputStyle} onChange={(e) => setPassword(e.target.value)} required />
            {(password.length >= 5 && password.length < 8) && (<p className="text-red-500 animate-fade-in transition-all duration-200 ease-linear">Password must contain atleast 8 characters!</p>)}
          </div>

          <div className="flex flex-col my-2">
            <p className="text-gray-300">Confirm Password</p>
            <input type="password" name="password" className={commonInputStyle} onChange={(e) => setConfirmPassword(e.target.value)} required />
            {((password.length == confirmPassword.length && password !== confirmPassword) || (confirmPassword.length > 1 && password !== confirmPassword)) && (<p className="text-red-500 animate-fade-in transition-all duration-200 ease-linear">Password must be same!</p>)}
          </div>

          <div className="flex flex-col my-2">
            <p className="text-gray-300">Contact no</p>
            <input type="number" name="contactNo" className={commonInputStyle} onChange={(e) => setContactNo(e.target.value)} required />
            {(contactNo.length > 1 && (contactNo.length < 10 || contactNo.length > 10)) && (<p className="text-red-500 animate-fade-in transition-all duration-200 ease-linear">Contact no must be of 10 characters!</p>)}
          </div>

          {!emailVerified && (
            <div className="flex my-2 justify-between animate-fade-in duration-300 ease-linear">
              {!isMailSent && <button className={commonBtnStyle} onClick={sendOTPOnMail}>Verify email</button>}
              {isMailSent && (
                <div className="flex flex-col">
                <p className="text-gray-300 animate-fade-in transition-all duration-300 ease-linear">OTP is sent on {email}</p>
                <div className="flex animate-fade-in duration-300 ease-linear">
                  <input type="text" name="contactNo" className={`${commonInputStyle} rounded-r-none w-[100px]`} required />
                  <button className={`${commonBtnStyle} rounded-l-none shadow-lg`} onClick={verifyMail}>Verify</button>
                </div>
                </div>
              )}
            </div>
          )}

          {emailVerified && !userVerified && (
            <div className="flex my-2 justify-between animate-fade-in duration-300 ease-linear">
              {!isMessageSent && <button className={commonBtnStyle} onClick={sentOTPOnContactNo}>Verify Contact</button>}
              {isMessageSent && (
                <div className="flex flex-col">
                <p className="text-gray-300 animate-fade-in transition-all duration-300 ease-linear">OTP is sent on {contactNo}</p>
                <div className="flex animate-fade-in duration-300 ease-linear">
                  <input type="text" name="contactNo" className={`${commonInputStyle} rounded-r-none w-[100px]`} required />
                  <button className={`${commonBtnStyle} rounded-l-none shadow-lg`} onClick={verifyMobile}>Verify</button>
                </div>
                </div>
              )}
            </div>
          )}

          {userVerified && !isAuthenticated && (
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
            <Link className="text-gray-300 hover:text-gray-50 transition-all duration-300 ease-in-out underline" href="/">Home</Link>
            <Link className="text-blue-300 hover:text-blue-100 transition-all duration-300 ease-in-out underline" href="/auth/login">Login</Link>
          </div>
        </div>
      </div>
    </div>
  )
}