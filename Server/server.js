import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import {ConnectDB} from './config/MongoDB.js';
import {userRouter} from './routes/userRouter.js';
import {employeeRouter} from './routes/employeeRouter.js';
import { attendanceRouter } from './routes/attendanceRouter.js';
import { salaryRouter } from './routes/salaryRouter.js';

const app = express(); // creating express project

app.use(cors()); // allowing request from mention URL

app.use(express.json()); // config express to accept JSON data

dotenv.config(); // config the env file

ConnectDB(); // calling the connectDB to connect to MongoDB

app.use('/api/user',userRouter);
app.use('/api/employee',employeeRouter);
app.use('/api/attendance', attendanceRouter);
app.use('/api/salary', salaryRouter);

app.listen(process.env.PORT, () => { // config the server to listen on specified PORT
    console.log(`Server is running on port ${process.env.PORT}`);
}); 
