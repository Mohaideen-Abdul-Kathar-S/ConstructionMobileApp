import Salary from '../models/Salary.js';


export const getSalaryReport = async (req, res) => {
    try{
        const {dateTime} = req.params;
        const salaryDate = new Date(dateTime);
        salaryDate.setHours(0, 0, 0, 0);

        const report = await Salary.findOne({SalaryDate:salaryDate});
        if(report){
            res.status(200).json(report);
        }
        else{
            res.status(404).json({message:"Yet to Add reports"});
        }
    }catch(error){
        res.status(500).json({message:"Server Error", error});
    }
}

export  const saveSalaryReport = async (req, res) => {
    try{
        const { dateTime, Username, StartDate, EndDate, ShiftCount, amount, Type } = req.body;

    if (!dateTime || !Username || !StartDate || !EndDate || !ShiftCount || !amount || !Type) {
      return res.status(400).json({ message: "All fields are required" });
    }

    const salaryDate = new Date(dateTime);
    salaryDate.setHours(0, 0, 0, 0);

    const start = new Date(StartDate);
    const end = new Date(EndDate);

        const updated = await Salary.findOneAndUpdate(
      {
        SalaryDate: salaryDate,
        "Details.Username": Username
      },
      {
        $set: {
          "Details.$.StartDate": start,
          "Details.$.EndDate": end,
          "Details.$.ShiftCount": ShiftCount,
          "Details.$.Salary": amount,
          "Details.$.Type": Type
        }
      },
      { new: true }
    );

     if (updated) {
      return res.status(200).json({
        message: "Salary report updated successfully",
        salaryReport: updated
      });
    }

     const saved = await Salary.findOneAndUpdate(
      { SalaryDate: salaryDate },
      {
        $push: {
          Details: {
            Username,
            StartDate: start,
            EndDate: end,
            ShiftCount,
            Salary: amount,
            Type
          }
        }
      },
      { new: true, upsert: true }
    );

    return res.status(201).json({
      message: "Salary report saved successfully",
      salaryReport: saved
    });

    }catch(error){
        res.status(500).json({message: "Internal Server Error", error});
    }
}


export const deleteSalaryReport = async (req, res) => {
    try{
        const {dateTime, Username} = req.params;
        const SalaryDate = new Date(dateTime);
        SalaryDate.setHours(0, 0, 0, 0);
          const updatedReport = await Salary.findOneAndUpdate(
      {
        SalaryDate,
        "Details.Username": Username 
      },
      {
        $pull: { Details: { Username } }
      },
      { new: true }
    );

    if (!updatedReport) {
      return res.status(404).json({ message: "Salary report not found" });
    }
      return res.status(200).json({
      message: "User salary report deleted successfully",
      salaryReport: updatedReport
    });
        

    }catch(error){
        res.status(500).json({message:"Server Error", error});
    }
}


export const getAllSalaryReportByRange = async (req, res) => {
    try{
      const {sdate, edate} = req.params;
      console.log("Received dates:", sdate, edate); 
      const startDate = new Date(sdate);
    startDate.setHours(0, 0, 0, 0);

    const endDate = new Date(edate);
    endDate.setHours(23, 59, 59, 999);

      const reportInRange = await Salary.find({SalaryDate: {$gte: startDate, $lte: endDate}});
      if(reportInRange.length === 0){
         res.status(404).json({message:"Reports Not Found"});
        
      }
      else{
        console.log("Report in range:", reportInRange);
       res.status(200).json(reportInRange);
      }

    }catch(error){
      res.status(500).json({message:"Server Error", error});
    }
}


export const getSalaryReportByEmployeeWithRange = async (req, res) => {
  try {
    const { Username, sdate, edate } = req.params;

    const startDate = new Date(sdate);
    startDate.setHours(0, 0, 0, 0);

    const endDate = new Date(edate);
    endDate.setHours(23, 59, 59, 999);

    const reportInRange = await Salary.find(
      {
        SalaryDate: { $gte: startDate, $lte: endDate },
        "Details.Username": Username
      },
      {
        SalaryDate: 1,
        Details: { $elemMatch: { Username } }
      }
    ).sort({ SalaryDate: 1 });

    if (reportInRange.length === 0) {
      return res.status(404).json({
        message: "No salary records found for this employee in the given range"
      });
    }

    return res.status(200).json({
      
      data: reportInRange
    });

  } catch (error) {
    res.status(500).json({ message: "Server Error", error });
  }
};
