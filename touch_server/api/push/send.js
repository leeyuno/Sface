var async = require('async')
var User = require('../../model/user');
var Product =require('../../model/product');
var Message = require('../../model/message');
var FCM = require('fcm-node');
var serverKey  = "AAAAJGePFHI:APA91bH4uOel1thHTN0PPsDT7f85ApU9XeyxWVFGkrDF4z5IFqFk3mzrpseo83SRCC1DYcarsjBeA0LY5TF74zhaiYJyBdURdgGsDHcRdFW-nj67rpahG0THdLkjRJP6uYQPk7VIoiGV"
// var serverKey = 'AAAAVUyGtI0:APA91bHjPr5y_FL3Rkxr9joUr7QrUdqle7uJvaVpfu1shZWKsrCYyyKFy9omvFr4XYie3ic2j543bp27Cphzyk--mnjRpf5jIxH-L-NImHkqEA8tJrdirb7IirhFBD_pEgW-G0KbvoYf';
var fcm = new FCM(serverKey);
var logger = require('../logger/logger');
/*
        1. 홍보용(전체 메세지)
        2. 댓글이 달릴 경우(판매자/구매자)
        4. 채팅 알림(판매자/구매자)
        5. 경매 마감 전
        6. + 최고입찰자가 나 -> 타인으로 바뀔 경우 '나' 에게 푸시메세지 전송
        3. 키워드 알림 => system 에서 구축 필요
*/
//키워드 알림

//최고입찰자 변깅시

//경매 마감

// 판매자 / 구매자 채팅 푸싱
exports.Push_chat_msg = function(fn,sender, receiver, msg, cb){
    async.waterfall([
        function(cb_user){
            User.find({"profile.nick" : receiver}, function(err,user){
                if(err){
                    return cb_user(err)
                }
                if(user.length === 0){
                    return cb_user('user.length === 0');
                }
                else{
                    if(user[0].token){
                        cb_user(null, user[0]);
                    }
                    else{
                        return cb_user('user : %s is not agreed push notification');
                    }
                    
                }
            })
        },
        function(cb_user, cb_push){
            //sender, receiver, msg, token,cb
            Push_chat_msg_fcmSend(sender, receiver, msg, token, function(err,result){
                if(err){
                    return cb_push(err);
                }
                else{
                    cb_push(null, result);
                }
            })
        }
    ], function(err, result){
        if(err){
            return cb(err);
        }
        else{
            return cb(null, result);
        }
    }) 
}


// 제품에 대한 질문 / 답변 푸싱
exports.Push_reply_msg = function(fn, product, buyUser, sellUser, msg,cb){
    // 질문일  경우 판매자가 받는다.
    var who ;

    if(fn === "q"){
        who = sellUser    
    }
    else{
        who = buyUser
    }
            
    async.waterfall([
        function(cb_userToken){
            
            // User.find({"profile.nick" : sellUser}{
            User.find({"id" : who}, function(err, user){
                if(err){
                    return cb_userToken(err);
                }
                if(user.length === 0){
                    return cb_userToken('user.length === 0');
                }
                else{
                    if(user[0].token){
                        cb_userToken(null, user[0].token);
                    }
                    else{
                        //푸시메세지에 동의하지 않을 경우 전송되지 않음. 
                        return cb_userToken('buyUser is not agreed Push Function');
                    }
                }
            })
        },
        function(cb_userToken,cb_push){
            if(fn === "q"){
                Push_reply_msg_fcmSend("q",cb_userToken,product,msg,buyUser, sellUser,function(err,result){
                    if(err){
                        return cb_push(err);
                    }
                    else{
                        cb_push(null, result);
                    }
                })
            }
            else{
                Push_reply_msg_fcmSend("r", cb_userToken, product, msg, buyUser, sellUser, function(err,result){
                    if(err){
                        return cb_push(err);
                    }
                    else{
                        cb_psuh(null, result);
                    }
                })
            }
        }
    ], function(err,result){
        if(err){
            return cb(err);
        }
        else{
            return cb(null,result);
        }
    })

}
exports.Push_all_msg = function(msg){
    var Total = [];

    async.waterfall([
        function(cb_userList){
            User.find({}, function(err,userList){
                if(err){
                    cb_userList(err);
                }
                if(userList.length === 0){
                    cb_userList('userList.length == 0');
                }
                else{
                    for(var i = 0; i < userList.length; i++){
                        if(userList[i].token){
                            Total.push(userList[i].token);
                        }
                    }
                    cb_userList(null, Total);
                }
            })
        },
        function(cb_userList, cb_token){
            async.each(cb_userList, function(obj, done){
                Push_all_msg_fcmSend(obj, msg, function(err, result){
                    if(err){
                        return done(err)
                    }
                    else{
                        done()
                    }
                })
            }, function(err){
                if(err){
                    cb_token(err);
                }
                else{
                    cb_token(null, 'success');
                }
            })
        }
    ], function(err,result){
        if(err){
            logger.error('push_all_msg err : %s', err);
            return 0
        }
        else{
            return result
        }
    })
}


/* ------------------------------------------------------------------
                    
                            [ FUNCTION ]

--------------------------------------------------------------------*/


function fcmSend(message,cb){
    fcm.send(message, function(err, response){
        if(err){
            cb(err);
        }
        if(!response){
            cb('not sended');
        }
        else{
            cb(null, success);
        }
    })
}

function Push_chat_msg_fcmSend(sender, receiver, msg, token,cb){
    console.log('[test] fcmSend value check : %s,%s,%s, %s', sender, receiver, msg,token);
    var message = {
        to : token,
        priority : "high",
        content_available : true,
        notification : {
            title : 'Touch',
            body : sender + ' 님이 ' +msg + '라고 보냈음.'
        }
    }

    fcmSend(message, function(err, result){
        if(err){
            cb(err);
        }
        else{
            cb(null, result);
        }
    })
}

function Push_reply_msg_fcmSend(which,token,product,msg,buyUser, sellUser,cb){
    console.log('[test] fcmSend value check %s,%s, %s,%s', token,product,msg, buyUser, sellUser);
    
    var quset_msg = buyUser +' 님이'+ product + ' 에 질문을 올렸습니다.' + msg
    var reply_msg = sellUser +' 님이' +product + ' 에 답변을 달았습니다.' + msg

    var result_msg;

    if(which === "q"){
        result_msg = quset_msg;
    }
    else{
        result_msg = reply_msg
    }

    var message = {
        to : token,
        priority : "high",
        content_available: true,
        notification : {
            title: 'Touch',
            body: result_msg
        }
    }
    fcmSend(message, function(err, result){
        if(err){
            cb(err);
        }
        else{
            cb(null, result);
        }
    })
}
function Push_all_msg_fcmSend(token, msg, cb) {
    console.log('[test] fcmSend value check %s,%s', token,msg);
    var message = {
    // to : r_token,
        to : token,
        priority : "high",
        content_available: true,
        notification : {
            title: 'Touch',
            body:  msg
        }
        // ,
        // data : {
        //     nick : s_nick,
        //     message : r_msg,
        //     key : r_key,
        //     receiver : r_nick,
        //     time : r_time
        // }
    };
    fcmSend(message, function(err,result){
        if(err){
            cb(err);
        }
        else{
            cb(null, result);
        }
    })
}

