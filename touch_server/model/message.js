var mongoose = require('mongoose');
mongoose.Promise = global.Promise;
var Schema = mongoose.Schema;
const crypto = require('crypto')
const config = require('../config/config.js')
var time = require('../api/time/time');

var messageSchema = new Schema({
    //현재 유저의 id 로 임시메세지 스키마를 만든 후 메세지를 찾아 전송한다.
    id :String, //현재 유저의 _id 를 입력
    deviceId : String,
    message : [{
        box : String,
        user : String, //보낸이의 아이디를 등록
        date: String,
        msg : String
    }]
})

messageSchema.statics.create = function(id, deviceId, box, sender, msg){
    const message = new this({
        id : id,
        deviceId : deviceId,
        message : {
            box : box,
            user : sender,
            date : time(),
            msg : msg

        }
    })

    return message.save()
}

module.exports = mongoose.model('Message', messageSchema);