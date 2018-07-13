var User = require('../../model/user');


module.exports = function(user){
    User.find({id : user}, function(err,user){
        if(err){
            return console.log('[system] %s 유저가 경고를 받았습니다.');
        }
        if(user.length === 0){
            return console.log('[system] %s 유저를 찾을 수 없습니다.');
        }
        else{
            user[0].warn = user[0].warn + 1;

            user[0].save();
            return console.log('[system] warn.js %s 유저가 경고를 받았습니다.', user[0].id)
        }
    })
}