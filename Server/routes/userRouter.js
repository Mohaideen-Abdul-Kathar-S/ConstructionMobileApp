import express from 'express';
import {userLogin, userChangePassword, userEmail, sendOTP, verifyOTP} from '../controllers/userController.js';

export const userRouter = express.Router();

userRouter.post('/login',userLogin);
userRouter.put('/changepassword',userChangePassword);
userRouter.put('/changeemail',userEmail);
userRouter.post('/sendotp',sendOTP);
userRouter.post('/verifyotp',verifyOTP);