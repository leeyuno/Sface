var mongoose = require('mongoose');
mongoose.Promise = global.Promise;
var Schema = mongoose.Schema;
const crypto = require('crypto')
const config = require('../config/config.js')

var userSchema = new Schema({
    id : String, //핸드폰 번호로 할 생각
    sigNum : {type: Number, 'default' : 1111}, //인증번호
    deviceId : String,  
    token : String,
    profile : {
        nick : String,
        sex :  String,
        email : String,
        push : Boolean,
        
    },
    image : String,
    warn : Number // 경고 횟수
    , Block  : {type : Boolean, 'default' : false} //차단할 것인지 허용할 것인지
    , push : Boolean
    , bidChance : {type : Number, 'default' : 10}
    ,create_at : {type: String, 'default' : getTime('Y-m-d H:i:s')}
    ,hoProduct : [{
        product : String
    }]
    ,ingProduct : [{
        product : String
    }]
    ,sellProduct : [{
        product : String
    }]

}) 

// userSchema.statics.create = function()
userSchema.statics.create1 = function(id, sigNum){
    const user = new this({
        id,
        sigNum
    })

    return user.save()
}

userSchema.methods.verify = function(password){
    const encrypted = crypto.createHmac('sha256', config.secret)
                            .update(password)
                            .digest('base64')
        return this.password === encrypted
}

userSchema.methods.d_verify = function(deviceId){
    const d_encrypted = crypto.createHmac('sha256', config.secret)
                        .update(deviceId)
                        .digest('base64')

        return this.deviceId === d_encrypted
}

userSchema.statics.findId = function(id){
    return this.findOne({
        id : id
    }).exec()
}

userSchema.statics.findUnderId = function(_id){
    return this.findOne({
        _id  : _id
    }).exec()
}

module.exports = mongoose.model('User', userSchema);



function fix2num(n){
    return [0, n].join('').slice(-2);
}

function getTime(format){
    var curdate = new Date();
    if( format == undefined ) return curdate;
    format = format.replace(/Y/i, curdate.getFullYear());
    format = format.replace(/m/i, fix2num(curdate.getMonth() + 1));
    format = format.replace(/d/i, fix2num(curdate.getDate()));
    format = format.replace(/H/i, fix2num(curdate.getHours()));
    format = format.replace(/i/i, fix2num(curdate.getMinutes()));
    format = format.replace(/s/i, fix2num(curdate.getSeconds()));
    format = format.replace(/ms/i, curdate.getMilliseconds());
    return format;
}
