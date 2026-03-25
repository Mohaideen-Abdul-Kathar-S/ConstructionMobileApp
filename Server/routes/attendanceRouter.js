import express from 'express';
import {viewAttendancebyDateAndShift, initializeAttendance, getAttendance, markAttendance, viewAttendance, getAttendanceByDate, getAttendanceByEmployee, getShiftCount, getAttendanceByEmployeeWithRange} from '../controllers/attendanceController.js';


export const attendanceRouter = express.Router();

attendanceRouter.post('/initializeattendance/:dateTime', initializeAttendance);
attendanceRouter.get('/getattendance/:date/:shift', getAttendance);
attendanceRouter.put('/markattendance', markAttendance);
attendanceRouter.get('/viewattendance/:date/:shift', viewAttendance);
attendanceRouter.get('/viewattendancebydateandshift/:date/:shift', viewAttendancebyDateAndShift);
attendanceRouter.get('/getattendancebydate/:sdate/:edate', getAttendanceByDate);
attendanceRouter.get('/getattendancebyemployee/:Username/:date', getAttendanceByEmployee);
attendanceRouter.post('/getshiftcount', getShiftCount);
attendanceRouter.get('/getattendancebyemployeewithrange/:Username/:sdate/:edate', getAttendanceByEmployeeWithRange);