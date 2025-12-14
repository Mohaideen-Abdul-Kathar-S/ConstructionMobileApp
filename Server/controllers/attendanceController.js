import Attendance from "../models/Attendance.js";
import Employees from "../models/Employee.js";
import Salary from "../models/Salary.js"; 

export const initializeAttendance = async (req, res) => {
    try{
        const { dateTime } = req.params;

        const dt = new Date(dateTime);

        const date = dt.toISOString().split("T")[0];

        const time = dt.toISOString().split("T")[1].slice(0, 5);

let session = "";

const [hours, minutes] = time.split(":").map(Number);
const totalMinutes = hours * 60 + minutes;

if (totalMinutes >= 450 && totalMinutes <= 720) {
    session = "FN";
}
else if (totalMinutes >= 721 && totalMinutes <= 990) {
    session = "AN";
}
else {
    session = "OUT_OF_SESSION"; 
}

const employees = (await Employees.find({})).map(emp => emp.Username);

const existingAttendance = await Attendance.findOne({
    AttendanceDate: date,
    Shift: session
});

if (session === "AN") {
    const fnAttendance = await Attendance.findOne({
        AttendanceDate: date,
        Shift: "FN"
    });

    if (!fnAttendance) {
        const fnRecord = new Attendance({
            AttendanceDate: date,
            Shift: "FN",
            PresentList: [],
            AbsentList: employees
        });
        await fnRecord.save();
    }
}

if (session === "OUT_OF_SESSION") {
    const anAttendance = await Attendance.findOne({
        AttendanceDate: date,
        Shift: "AN"
    });

    if (!anAttendance) {
        const anRecord = new Attendance({
            AttendanceDate: date,
            Shift: "AN",
            PresentList: [],
            AbsentList: employees
        });
        await anRecord.save();
    }
}

if (!existingAttendance && session !== "OUT_OF_SESSION") {
    const newAttendance = new Attendance({
        AttendanceDate: date,
        Shift: session,
        PresentList: [],
        AbsentList: employees
    });
    await newAttendance.save();
}

return res.status(200).json({ Date:date, Shift:session });

    }catch(error){
        res.status(500).json({message: "Internal Server Error", error});
    }
}

export const getAttendance = async (req, res) => {
    try{
        const { date, shift } = req.params;
        const attendanceRecord = await Attendance.findOne({AttendanceDate:date,shift});
        const employees = (await Employees.find({})).map(emp => ({Username: emp.Username, Type: emp.Type}));
        const A = employees.filter(emp => emp.Type === "A");
        const B = employees.filter(emp => emp.Type === "B");
        const C = employees.filter(emp => emp.Type === "C");
        const TypeList = {A, B, C};
        if(attendanceRecord){
            res.status(200).json({attendance: attendanceRecord, TypeList});
        }


    }catch(error){
        res.status(500).json({message: "Internal Server Error", error});
    }
}

export const markAttendance = async (req, res) => {
    try{
        const { AttendanceDate, Shift, PresentList, AbsentList } = req.body;
        const attendanceRecord = await Attendance.findOneAndUpdate(
            {AttendanceDate, Shift},
            {PresentList, AbsentList},
            {new: true}
        );
        if(!attendanceRecord){
           res.status(404).json({message: "Attendance record not found"});
        }
        else{
            res.status(200).json({message: "Attendance updated successfully"});
        }

    }catch(error){
        res.status(500).json({message: "Internal Server Error", error});
    }
}

export const viewAttendance = async (req, res) => {
    try{
        const { date, shift } = req.params;
        const attendanceRecord = await Attendance.findOne({AttendanceDate:date,shift});
        const prevAttendanceRecords = await Attendance.find({AttendanceDate:{$lt:date}}).sort({AttendanceDate:-1}).limit(10);
        if(attendanceRecord){
            res.status(200).json({attendance: attendanceRecord, previousAttendances: prevAttendanceRecords});
        } else {
            res.status(404).json({message: "Attendance record not found"});
        }
    }catch(error){
        res.status(500).json({message: "Internal Server Error", error});
    }
}

export const getAttendanceByDate = async (req, res) => {
    try{
        const { sdate, edate } = req.params;
        const attendanceRecords = await Attendance.find({AttendanceDate:{$gte:sdate,$lte:edate}}).sort({AttendanceDate:1});
        res.status(200).json({attendances: attendanceRecords});

    }catch(error){
        res.status(500).json({message: "Internal Server Error", error});
    }
}

export const getAttendanceByEmployee = async (req, res) => {
    try{
        const { Username, date } = req.params;
        const attendanceRecords = await Attendance.find({
            AttendanceDate: date
        });
        const attendanceStatus = attendanceRecords.map(record => {
            if (record.PresentList.includes(Username)) {
                return { shift: record.Shift, status: "Present" };
            } else if (record.AbsentList.includes(Username)) {
                return { shift: record.Shift, status: "Absent" };
            } else {
                return { shift: record.Shift, status: "Leave" };
            }
        });
        res.status(200).json({attendanceStatus});
    }catch(error){
        res.status(500).json({message: "Internal Server Error", error});
    }
}


export const getAttendanceByEmployeeWithRange = async (req, res) => {
    try{
        const { Username, sdate, edate } = req.params;
        const attendanceRecords = await Attendance.find({
            AttendanceDate: {$gte: sdate, $lte: edate}
        });
        const attendanceStatus = attendanceRecords.map(record => {
            if (record.PresentList.includes(Username)) {
                return { date: record.AttendanceDate, shift: record.Shift, status: "Present" };
            } else if (record.AbsentList.includes(Username)) {
                return { date: record.AttendanceDate, shift: record.Shift, status: "Absent" };
            } else {
                return { date: record.AttendanceDate, shift: record.Shift, status: "Leave" };
            }
        });
        res.status(200).json({attendanceStatus});
    }catch(error){
        res.status(500).json({message: "Internal Server Error", error});
    }
}



export const getShiftCount = async (req, res) => {
    try{
        const {Username, StartDate, EndDate} = req.body;
        if(!Username || !StartDate){
            return res.status(400).json({message: "Username and StartDate are required"});
        }
        if(!EndDate){
        EndDate=StartDate;
        }


const oldSalaryReport = await Salary.find({
  Details: {
    $elemMatch: {
      Username: Username,
      StartDate: { $lte: new Date(EndDate) },
      EndDate: { $gte: new Date(StartDate) }
    }
  }
});

if (oldSalaryReport.length > 0) {
  return res.status(400).json({
    message: "The given interval is already closed",
    oldSalaryReport
  });
}

        const attendanceRecords = await Attendance.find({
  AttendanceDate: {
    $gte: new Date(StartDate),
    $lte: new Date(EndDate)
  }
});


        const shifts = attendanceRecords.filter(record => 
            record.PresentList.includes(Username)
        );
        res.status(200).json({shiftCount: shifts.length});
    }catch(error){
        res.status(500).json({message: "Internal Server Error", error});
    }

}