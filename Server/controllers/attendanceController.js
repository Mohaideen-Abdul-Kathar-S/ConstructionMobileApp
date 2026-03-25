import Attendance from "../models/Attendance.js";
import Employees from "../models/Employee.js";
import Salary from "../models/Salary.js"; 

export const initializeAttendance = async (req, res) => {
    try{
        const { dateTime } = req.params;
        console.log("Initializing attendance for dateTime:", dateTime);

        const dt = new Date(dateTime);

        const date = dt.toISOString().split("T")[0];

let session = "";

const hours = dt.getHours();
const minutes = dt.getMinutes();
const totalMinutes = hours * 60 + minutes;


if (totalMinutes >= 450 && totalMinutes <= 720) {
    session = "FN";
}
else if (totalMinutes >= 721 && totalMinutes <= 990) {
    session = "AN";
}
else {
    session = "CLOSED"; 
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

if (session === "CLOSED") {
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

if (!existingAttendance && session !== "CLOSED") {
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
    try {
        const { date, shift } = req.params;

        const attendanceRecord = await Attendance.findOne({
            AttendanceDate: new Date(date),
            Shift: shift
        });

        const employees = (await Employees.find({}))
            .map(emp => ({ Username: emp.Username, Type: emp.Type }));

       
        

        if (attendanceRecord) {
            res.status(200).json({ attendance: attendanceRecord, TypeList: employees });
        } else {
            res.status(404).json({ message: "Attendance not found" });

        }


    } catch (error) {
        res.status(500).json({ message: "Internal Server Error", error });
    }
};

export const markAttendance = async (req, res) => {
    try{
        console.log("Marking attendance with data:", req.body);
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
    try {
        const { date, shift } = req.params;

        const start = new Date(date);
        const end = new Date(date);
        end.setDate(end.getDate() + 1);

        const attendanceRecord = await Attendance.findOne({
            AttendanceDate: { $gte: start, $lt: end },
            Shift: shift
        });

        const prevAttendanceRecords = await Attendance.find({
            AttendanceDate: { $lt: start }
        }).sort({ AttendanceDate: -1 }).limit(10);

        let lsAN = [];
let lsFN = [];

prevAttendanceRecords.forEach(record => {

    record.AttendanceDate = record.AttendanceDate.toISOString().split("T")[0];

    const present = record.PresentList.length;
    const absent = record.AbsentList.length;

    if (record.Shift === "AN") {

        lsAN.push({
            AttendanceDate: record.AttendanceDate,
            Shift: record.Shift,
            PresentANCount: present,
            AbsentANCount: absent
        });

    } else {

        lsFN.push({
            AttendanceDate: record.AttendanceDate,
            Shift: record.Shift,
            PresentFNCount: present,
            AbsentFNCount: absent
        });

    }
});
let merged = {};

prevAttendanceRecords.forEach(record => {

    const date = record.AttendanceDate.toISOString().split("T")[0];
    const present = record.PresentList.length;
    const absent = record.AbsentList.length;

    // create date object if not exists
    if (!merged[date]) {
        merged[date] = {
            AttendanceDate: date,
            PresentFNCount: 0,
            AbsentFNCount: 0,
            PresentANCount: 0,
            AbsentANCount: 0
        };
    }

    if (record.Shift === "FN") {
        merged[date].PresentFNCount = present;
        merged[date].AbsentFNCount = absent;
    } 
    else if (record.Shift === "AN") {
        merged[date].PresentANCount = present;
        merged[date].AbsentANCount = absent;
    }

});

merged = Object.values(merged);

console.log("Merged attendance:", merged);

        if (attendanceRecord) {
            res.status(200).json({
                attendance: {"present": attendanceRecord.PresentList.length, "absent": attendanceRecord.AbsentList.length},
                previousAttendances: merged
            });
        } else if(merged.length > 0){
            res.status(200).json({
                
                previousAttendances: merged
            });
        }
            else {
            res.status(404).json({ message: "Attendance record not found" });
        }

    } catch (error) {
        res.status(500).json({ message: "Internal Server Error", error });
    }
};

export const viewAttendancebyDateAndShift = async (req, res) => {
    try {

        const { date, shift } = req.params;

        console.log("Viewing attendance for 123 date:", date, "and shift:", shift);

        const attendanceRecord = await Attendance.findOne({
            AttendanceDate: new Date(date),
            Shift: shift
        });

        if (!attendanceRecord) {
            return res.status(404).json({ message: "Attendance record not found" });
        }

        const presentList = attendanceRecord.PresentList;
        const absentList = attendanceRecord.AbsentList;

        const allUsernames = [...presentList, ...absentList];

        const employees = await Employees.find({
            Username: { $in: allUsernames }
        });

        let groupedTypes = {};

        employees.forEach(emp => {

            const isPresent = presentList.includes(emp.Username);

            const data = {
                Username: emp.Username,
                Name: emp.Name,
                isPresent
            };

            // create array if type not exists
            if (!groupedTypes[emp.Type]) {
                groupedTypes[emp.Type] = [];
            }

            groupedTypes[emp.Type].push(data);

        });

        console.log("Grouped attendance by type:", {
            ...groupedTypes,
            presentCount: presentList.length,
            absentCount: absentList.length
        });

        res.status(200).json({
            ...groupedTypes,
            presentCount: presentList.length,
            absentCount: absentList.length
        });

    } catch (error) {
        res.status(500).json({ message: "Internal Server Error", error });
    }
};

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
        console.log("Getting shift count for Username:", Username, "StartDate:", StartDate, "EndDate:", EndDate);


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