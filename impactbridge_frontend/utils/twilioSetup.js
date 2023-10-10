require('dotenv').config();



const Client = require('twilio')(accountSID, twilioToken);

const SendOTPOnMobile = (OTPmessage, toPhone) => {
  Client.messages
    .create({
      body: OTPmessage,
      to: toPhone,
      from: '+19898502325',
    })
    .then((message) => console.log('OTP message sent:', message.sid))
    .catch((error) => console.error('Error sending OTP:', error.message));
}

module.exports = SendOTPOnMobile;