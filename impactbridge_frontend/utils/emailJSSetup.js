require('dotenv').config();
import emailjs from '@emailjs/browser';
const serviceID = process.env.NEXT_PUBLIC_EMAILJS_SERVICE_ID;
const templateID = process.env.NEXT_PUBLIC_EMAILJS_TEMPLATE_ID;
const publicKey = process.env.NEXT_PUBLIC_EMAIL_JS_PUBLIC_KEY;

export default function SendOTPMail(toEmail, mailMessage, toName) {
   return new Promise((resolve, reject) => {

      const templateParams = {
         to_name: toName,
         to_email: toEmail,
         message: mailMessage,
      }

      console.log(serviceID);
      emailjs.send(serviceID, templateID, templateParams, publicKey)
         .then((response) => {
            console.log(response);
            resolve({ status: 200 });
         })
         .catch((error) => {
            console.error("Error while sending mail", error);
            reject({ status: 400 });
         });
   });
}
