var gm = require('gm');
// brew install GraphicsMagick 꼭 필요
var path = require('path');
var fs = require('fs');

module.exports = function(image) {
    var realPath = __dirname+'../../image/product/'
    fs.exists(realPath, function(exists){
        if(exists){
            gm(__dirname+'/../../image/product/'+image)
            .blur(10,9)
            .write(__dirname+'/../../image/product/'+image, function (err) {
                if (err) console.error(err);
                else console.info('[system] image blur - do success');
            });
        }
        else{
            console.log('%s 파일을 찾을 수 없습니다.',image);
        }
    })   
}