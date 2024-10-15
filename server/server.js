require ('dotenv').config();
const express = require('express');
const morgan = require('morgan');
const cors = require('cors');
const mongoose = require('mongoose');
const authRouter = require('./routes/authRoutes');

const app = express();

app.use(morgan('dev'));
app.use(cors());
app.use(express.json());

app.use('/api/auth', authRouter);

// Connect to db

mongoose.connect(process.env.MONGO_URI)
.then(()=>{
    console.log("Connected to db");
})
.catch((err)=>{
    console.log("Error connecting to db: ", err);

})

const PORT = process.env.PORT || 3000;

app.listen(PORT, ()=>{
    console.log(`Server is running on port ${PORT}`);
})