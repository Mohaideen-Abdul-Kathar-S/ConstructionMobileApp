import express from 'express';
import { addEmployee, DeleteEmployee, updateEmployee, getEmployeeByName, updateProfile } from '../controllers/employeeController.js';


export const employeeRouter = express.Router();

employeeRouter.post('/addemployee', addEmployee);
employeeRouter.delete('/deleteemployee/:Username', DeleteEmployee);
employeeRouter.put('/updateemployee', updateEmployee);
employeeRouter.get('/employee/:name', getEmployeeByName);
employeeRouter.put('/updateProfile',updateProfile);