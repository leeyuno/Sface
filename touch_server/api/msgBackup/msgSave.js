var User = require('../../model/user');
var Message = require('../../model/message');
var time = require('../../api/time/time');
var async = require('async');

module.exports = function(receiver,sender, box,msg){
    //닉네임을 받아오니 닉네임으로 유저를 검색한 후, 임시메시지로 저장
    async.waterfall([
        function(cb_user){
            User.find({"profile.nick" : receiver}, function(err,user){
                if(err){
                    return cb_user(err);
                }
                else{
                    if(user.length === 0){
                        return cb_user('user.length === 0');
                    }
                    else{
                        return cb_user(null, user[0]);
                    }
                }
            })
        },
        function(cb_user, cb_message){
            console.log('user : ',cb_user , cb_user.id);
            
            Message.find({id : cb_user.id}, function(err,message){
                if(err){
                    return cb_message(err);
                }
                else{
                    if(message.length === 0){
                        //메세지를 create;
                        Message.create(cb_user.id, cb_user.deviceId, box, sender, msg);
                        console.log(' :  : message create !')
                        return cb_message(null,'create');
                    }
                    else{
                        //메세지 .message push
                        message[0].message.push({box : box, user: sender, date : time(), msg: msg});
                        message[0].save()
                        console.log(' : :  message push');
                        return cb_message(null, 'push');
                    }
                }
            })
        }
    ],function(err,result){
        if(err){
            console.log('err : %s', err);
            return 0
        }
        else{
            console.log('result : %s',result);
            return 1
        }
    })
}