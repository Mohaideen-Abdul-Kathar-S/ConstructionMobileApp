import mongoose from "mongoose";

const exEmployeeSchema = new mongoose.Schema({
    Username : String,
    Name : String,
    Type : String,
    DateOfBirth : Date,
    Address : String,
    Salary : Number,
    Profile : String,
    Email : String,
});

export default mongoose.model("ExEmployee", exEmployeeSchema);