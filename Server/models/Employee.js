import mongoose from 'mongoose';

const employeeSchema = new mongoose.Schema({
    Username : String,
    Name : String,
    Type : String,
    DateOfBirth : Date,
    Address : String,
    Salary : Number,
    Profile : String,
});

export default mongoose.model("EmployeeS", employeeSchema);