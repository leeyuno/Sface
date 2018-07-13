var multer = require('multer');
var path = require('path');

var profile = multer.diskStorage({
    destination : function(req, file, cb){
        cb(null, 'image/profile/')
    },
    filename : function(req, file, cb){
        // console.log('test',file)
        var ext = path.extname(file.originalname);
        var filename = path.basename(file.originalname, ext)
        if(ext === '.jpg'|| ext === '.png' || ext === '.jpeg'){	//파일 확장자 조건문 삽입
            cb(null, filename + ext)
        }
    }
})

exports.profile = profile