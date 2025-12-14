import Users from '../models/User.js';
import nodemailer from 'nodemailer';
import Otp from '../models/Otp.js';
import dotenv from 'dotenv';

dotenv.config();

export const userLogin = async (req, res) => {
    try{

        const {Username, Password} = req.body;

        const user = await Users.findOne({Username, Password});

        if(user){
            res.status(200).json({message: "Login Successful", user});
        }
        else{
            res.status(401).json({message: "Invalid Credentials"});
        }
    }catch(error){
        res.status(500).json({message: "Internal Server Error", error});
    }
}

export const userChangePassword = async (req, res) => {
    try{
        const {Username, Password, NewPassword} = req.body;

        const user = await Users.findOneAndUpdate(
            {Username,Password},
            {Password: NewPassword},
            {new: true}
        );

        if(user){
            res.status(200).json({message: "Password Changed Successfully", user});
        }
        else{
            res.status(401).json({message: "Invalid Credentials"});
        }
    }catch(error){
        res.status(500).json({message: "Internal Server Error", error});
    }
}

export const userEmail = async (req, res) => {
    try{
        const {Username, Password, Email} = req.body;

        const user = await Users.findOneAndUpdate(
            {Username,Password},
            {Email: Email},
            {new: true}
        );

        if(user){
            res.status(200).json({message: "Email Changed Successfully", user});
        }
        else{
            res.status(401).json({message: "Invalid Credentials"});
        }
    }catch(error){
        res.status(500).json({message: "Internal Server Error", error});
    }
}

export const sendOTP = async (req, res) => {
    try{
        const {Username} = req.body;

        const user = await Users.findOne({Username});

        if(user){
            if(user.Email){
                const otp = Math.floor(100000 + Math.random() * 900000).toString();
                const transporter = nodemailer.createTransport({
                    service: 'gmail',
                    
                    auth:{
                        user: process.env.SENDER_EMAIL,
                        pass: process.env.SENDER_PASSWORD,
                    }
                });
                const mailOptions = {
                    from: process.env.SENDER_EMAIL,
                    to: user.Email,
                    subject: 'OTP for Password Reset',
                    text: `Your OTP for password reset is: ${otp}`,
                };
                
                const newOtp = new Otp({
                    Username,
                    Email : user.Email,
                    Otp: otp,
                });
                await newOtp.save();
                
                await transporter.sendMail(mailOptions);

                res.status(200).json({message: "OTP sent to registered email"});
            }else{
                res.status(400).json({message: "Missing Email in user profile"});
            }
        }
        else{
            res.status(401).json({message: "Invalid Username"});
        }

    }catch(error){
        console.error("Error in sendOTP:", error);
        res.status(500).json({message: "Internal Server Error", error});
    }
}


export const verifyOTP = async (req, res) => {
    try{
        const { Email, EnteredOtp, NewPassword} = req.body;
        const otpRecord = await Otp.findOne({Email, Otp: EnteredOtp});
        if(otpRecord){
            await Users.findOneAndUpdate({Username : otpRecord.Username}, {Password: NewPassword});
            await Otp.deleteMany({Email});
            res.status(200).json({message: "OTP verified and password reset successful"});
        }else{
            console.log("OTP verification failed for Email:", otpRecord);
            res.status(400).json({message: "OTP expired or invalid"});
        }
    }catch(error){
        console.error("Error in verifyOTP:", error);
        res.status(500).json({message: "Internal Server Error", error});
    }
}