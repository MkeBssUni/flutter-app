const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');

const userSchema = new mongoose.Schema({
    name:{
        type: String,
        required: true
    },
    email:{
        type: String,
        required: true,
        unique: true
    },
    password:{
        type: String,
        required: true
    }
});

userSchema.pre('save', async function(next){
    const user = this;
    if(!user.isModified('password')){
        return next();
    }else{
        const hash = await bcrypt.hash(user.password, 10);
        user.password = hash;
        next();
    }
});

userSchema.methods.comparePassword = async function(password){
    return await bcrypt.compare(password, this.password);
}

const User = mongoose.model('User', userSchema);

module.exports = User;