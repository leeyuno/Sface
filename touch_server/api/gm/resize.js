var gm = require('gm');
var path = require('path');
var fs = require('fs');

//프로필 이미지를 받으면 리사이징 한다.
module.exports = function(ppath, image){
    var realPath = __dirname+'../../image/'+ppath+image
    fs.exists(realPath, function(exists){
        if(exists){
            gm(__dirname+'/../../image/'+ppath+image)
            .reszie(100,200)
            .write(__dirname+'/../../image/'+ppath+image, function (err) {
                if (err) console.error(err);
                else console.info('[system] image blur - do success');
            });
        }
        else{
            console.log('%s 파일을 찾을 수 없습니다.',image);
        }
    })   
}