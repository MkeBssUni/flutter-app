const jwt = require("jsonwebtoken");
const User = require("../models/user");

const generateToken = (id) => {
  return jwt.sign({ id }, process.env.JWT_SECRET, {
    expiresIn: "30d",
  });
};

exports.registerUser = async (req, res) => {
  const { name, email, password } = req.body;
  console.log("register", req.body);

  const userExists = await User.findOne({ email });
  if (userExists) {
    return res.status(400).json({ message: "User already exists" });
  }

  try {
    // Create user
    const user = await User.create({ name, email, password });
    if(user){
        return res.status(201).json({
            _id: user._id,
            name: user.name,
            email: user.email,
            token: generateToken(user._id),
        });
    }else{
        return res.status(400).json({ message: "Invalid user data" });
    }
  } catch (error) {
    console.log(error);
    return res.status(500).json({ message: "Error creating user: ",error });
  }
};


exports.login = async (req, res)=> {
    const {email, password} = req.body;
    console.log("login", req.body);
    const user = await User.findOne({email});
    
    if(!user){
        return res.status(404).json({message: "User not found"});
    }

    const isMatch = await user.comparePassword(password);

    if(!isMatch){
        return res.status(401).json({message: "Invalid credentials"});
    }

    return res.status(200).json({
        _id: user._id,
        name: user.name,
        email: user.email,
        token: generateToken(user._id),
    });
}