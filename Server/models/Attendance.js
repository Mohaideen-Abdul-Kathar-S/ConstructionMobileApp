import mongoose from 'mongoose';

const attendanceSchema = new mongoose.Schema({
    AttendanceDate : Date,
    Shift : String,
    PresentList : [String],
    AbsentList : [String],
});

export default mongoose.model('Attendance', attendanceSchema);