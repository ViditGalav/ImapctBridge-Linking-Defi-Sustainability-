
const accountSID = process.env.NEXT_PUBLIC_TWILIO_ACCOUNT_SID;
const twilioToken = process.env.NEXT_PUBLIC_TWILIO_AUTH_TOKEN;
const Client = require('twilio')(accountSID, twilioToken);





export default function SendOTPOnMobile(OTPmessage, toPhone) {
   Client.messages
      .create({
         body: OTPmessage,
         to: toPhone,
         from: '+19898502325',
      })
      .then((message) => console.log('OTP message sent:', message.sid))
      .catch((error) => console.error('Error sending OTP:', error.message));
}