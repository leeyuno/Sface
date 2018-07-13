var User = require('../../model/user');
var Message = require('../../model/message');
var async = require('async');

module.exports = function(user,devcieId,cb_message){
    //해당 유저의 임시메세지가 남겨져 있을 경우, 메세지를 저장한다.
    var data ;
    Message.find({$and : [{id: user}, {deviceId : devcieId}]},function(err,message){
        // console.log('있을걸?' , message);
        if(err){
            return cb_message(err)
        }
        else{
            if(message.length === 0){
                return cb_message('nothing');
            }
            else{
                msgRemove(user, devcieId, function(err,result){
                    if(err){
                        cb_message(err) ;
                    }
                    else{
                        //메세지 전송 후 이미지 삭제하기.
                        return cb_message(null, message[0].message);
                    }
                })
            }
        }
    })
}

function msgRemove(user, deviceId,cb) {
    Message.remove({$and : [{id : user},{deviceId : deviceId}]},function(err,result){
        if(err){
            cb(err)
        }
        else{
            if(result.length === 0){
                cb(0);
            }
            else{
                cb(null,'1')
            }

        }

    })
}

