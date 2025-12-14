import mongoose from 'mongoose';

const userSchema = new mongoose.Schema({
    Username: String,
    Password: String,
    Email: String,
});

export default mongoose.model('Users', userSchema);