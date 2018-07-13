var multer = require('multer');
var path = require('path');
// var Resize = require('../gm/resize');

var product = multer.diskStorage({
    destination : function(req, file, cb){
        cb(null, 'image/product/')
    },
    filename : function(req, file, cb){
        console.log('doh test : ', file);
        console.log('test', file.filename);
        // var size = Resize(file)
        // console.log('test',file)
        var ext = path.extname(file.originalname);
        var filename = path.basename(file.originalname, ext)
        if(ext === '.jpg'|| ext === '.png' || ext === '.jpeg'){	//파일 확장자 조건문 삽입
            cb(null, filename + ext)
        }
    }
})
exports.product = product