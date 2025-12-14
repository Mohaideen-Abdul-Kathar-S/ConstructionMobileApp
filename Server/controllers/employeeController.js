import Employees from "../models/Employee.js";
import Users from '../models/User.js';
import ExEmployee from "../models/ExEmployee.js";

export const addEmployee = async (req, res) => {
    try{
        const {Username, Name, Type, DateOfBirth, Address, Salary, Profile} = req.body;

        if(!Username || !Name || !Type || !DateOfBirth || !Address || !Salary){
            return res.status(400).json({message: "All fields are required"});
        }

        const userExists = await Users.findOne({Username});
        if(userExists){
            return  res.status(400).json({message: "Username already exists"});
        }

        const newUser = new Employees({
            Username,
            Name,
            Type,
            DateOfBirth,
            Address,
            Salary:Number(Salary),
            Profile,
        });
        await newUser.save();

        const newLoginUser = new Users({
            Username,
            Password: Username,
        });

        await newLoginUser.save();

        res.status(200).json({message: "Employee added successfully", employee: newUser});
    }catch(error){
        res.status(500).json({message: "Internal Server Error", error});
    }
}

export const DeleteEmployee = async (req, res) => {
    try{
        const {Username} = req.params;

        const deletedEmployee = await Employees.findOneAndDelete({Username});
        const deletedUser = await Users.findOneAndDelete({Username});
        if(deletedEmployee && deletedUser){
            const exEmployee = new ExEmployee({
                Username: deletedEmployee.Username,
                Name: deletedEmployee.Name,
                Type: deletedEmployee.Type,
                DateOfBirth: deletedEmployee.DateOfBirth,
                Address: deletedEmployee.Address,
                Salary: deletedEmployee.Salary,
                Profile: deletedEmployee.Profile,
                Email: deletedUser.Email,
            });
            await exEmployee.save();
            res.status(200).json({message: "Employee deleted successfully"});
        }
        else{
            res.status(404).json({message: "Employee not found"});
        }   
    }catch(error){
        res.status(500).json({message: "Internal Server Error", error});
    }   
}

export const updateEmployee = async (req, res) => {
    try{
        const {Username, Name, Type, DateOfBirth, Address, Salary, Profile} = req.body;
        const updatedEmployee = await Employees.findOneAndUpdate(
            {Username},
            {Name, Type, DateOfBirth, Address, Salary:Number(Salary), Profile},
            {new: true}
        );
        if(updatedEmployee){
            res.status(200).json({message: "Employee updated successfully", employee: updatedEmployee});
        }else{
            res.status(404).json({message: "Employee not found"});
        }
    }catch(error){
        res.status(500).json({message: "Internal Server Error", error});
    }
}



export const getEmployeeByName = async (req, res) => {
    try{
        const { name } = req.params;
     

        const employeeList = await Employees.find({
            Name: { $regex: `^${name}`, $options: "i" }
        });

        if(employeeList.length === 0){
            return res.status(404).json({ message: "Employee not found" });
        }   
        res.status(200).json({ employees: employeeList });

    }catch(error){
        res.status(500).json({message: "Internal Server Error", error});
    }
}

export const updateProfile = async (req, res) => {
  try {
    const { Username, Profile } = req.body;

    if (!Username || !Profile) {
      return res.status(400).json({
        message: "Username and Profile are required"
      });
    }

    const employee = await Employee.findOneAndUpdate(
      { Username },
      { $set: { Profile } },
      { new: true }
    );

    if (!employee) {
      return res.status(404).json({
        message: "Employee not found"
      });
    }

    return res.status(200).json({
      message: "Profile updated successfully",
      employee
    });

  } catch (error) {
    res.status(500).json({
      message: "Internal Server Error",
      error
    });
  }
};
