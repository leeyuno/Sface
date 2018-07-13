var User = require('../../model/user');

//경고 카드가 3장이 넘어가는 사람이 있으면 블락 유저로 만들어버림.

module.exports = function() {
    User.find({$and : [{Block : false },{warn : {$gt : 3}}]}, function(err, warnUser){
        if(err){
            return console.log('[system] block.js err: %s', err);
        }
        else{
            for(var i = 0; i < warnUser.length; i++){
                warnUser[i].Block = true;
                warnUser[i].save()
                return console.log('[system] %s 유저가 경고3회로 강제 제재에 들어갑니다.', warnUser[i].id);
            }
        }
    })
}
