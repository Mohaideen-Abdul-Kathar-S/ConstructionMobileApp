import mongoose from "mongoose";

const otpSchema = new mongoose.Schema({
    Username: String,
    Email: String,
    Otp: String,
    CreatedAt: { type: Date, default: Date.now } 
});

otpSchema.index({ CreatedAt: 1 }, { expireAfterSeconds: 300 });

export default mongoose.model("Otp", otpSchema);