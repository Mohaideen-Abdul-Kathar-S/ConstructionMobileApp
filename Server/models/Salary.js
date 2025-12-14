import mongoose from 'mongoose';

const slarySchema = new mongoose.Schema({
    SalaryDate : Date,
    Details : [
        {
            Username : String,
            StartDate : Date,
            EndDate : Date,
            ShiftCount : Number,
            Salary : Number,
            Type : String,
        }
    ]
});

export default mongoose.model('Salary', slarySchema);