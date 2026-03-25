import express from 'express';
import {getAllEmployee,  addEmployee, DeleteEmployee, updateEmployee, getEmployeeByName, updateProfile, getEmployees ,getEmployeeByUsername} from '../controllers/employeeController.js';



export const employeeRouter = express.Router();

employeeRouter.post('/addemployee', addEmployee);
employeeRouter.delete('/deleteemployee/:Username', DeleteEmployee);
employeeRouter.put('/updateemployee', updateEmployee);
employeeRouter.get('/employees', getEmployees);
employeeRouter.get('/employeebyusername/:username', getEmployeeByUsername);
employeeRouter.get('/employee/:name', getEmployeeByName);
employeeRouter.put('/updateProfile',updateProfile);
employeeRouter.get('/allemployee', getAllEmployee);