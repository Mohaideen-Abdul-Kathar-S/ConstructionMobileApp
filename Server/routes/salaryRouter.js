import express from 'express';
import {getSalaryReport, saveSalaryReport, deleteSalaryReport, getAllSalaryReportByRange, getSalaryReportByEmployeeWithRange} from '../controllers/salaryController.js'

export const salaryRouter = express.Router();

salaryRouter.get('/getsalaryreport/:dateTime',getSalaryReport);
salaryRouter.post('/savesalary',saveSalaryReport);
salaryRouter.delete('/deletesalaryreport/:dateTime/:Username', deleteSalaryReport);
salaryRouter.get('/getallSalary', getAllSalaryReportByRange);
salaryRouter.get('/getsalaryreportbyemployeewithrange/:Username/:sdate/:edate', getSalaryReportByEmployeeWithRange);
