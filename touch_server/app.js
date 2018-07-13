var mongoose = require('mongoose')
mongoose.Promise = global.Promise

var http = require('http')
, express = require('express')
, bodyParser = require('body-parser')
, multer = require('multer')
, morgan = require('morgan')
, path = require('path') ;

var app = express();
var port = 8080;

process.setMaxListeners(15);

var logger = require('./api/logger/logger');
var sms_config = require('./api/sms/sms_config.js');

console.log('fuck : %s',sms_config.api_key);


//
console.log('++ Touch server2 On ++')
console.log('== ip :' + 'http://localhost:'+ port);
//

httpServer = require('http').createServer(app).listen(port);
var io = require('socket.io').listen(httpServer);
var database = require('./route/db')();
var socket = require('./api/socket/socket')(io);
var systemManage1 = require('./system/manage_product/product_status_manage')();
// var systemManage1 = require('./system/manage_product/product_exists_manage')();
// var test = require('./api/msgBackup/msgSave')('류민수', "testBox", "testMessage");
// require('./api/msgBackup/msgExport')("01028331861", "fuck", function(err, result){
//     if(err){
//         console.log('뀹1', err);
//     }
//     else{
//         console.log('뀹2',result);
//     }
// });


//require('./api/socket/socket.test.fuck')(httpServer,io);
app.use(morgan('dev'));
app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json({limit: '200mb'})); //File upload disk access 5mb
//app.use(bodyParser.urlencoded({limit: "50mb", extended: true, parameterLimit:50000}));
app.use(bodyParser.urlencoded({
    limit: '50mb',
    type:'*/x-www-form-urlencoded',
    extended: true
}));
app.use(require('./route/route.js')) //body-paresr 뒤에 있어야함

app.set('views', './views_file');
app.set('view engine', 'jade');

app.get('/', function(req,res){
    res.render('index');
});


logger.info('진짜??')

// image upload
app.use("/upload/profile", express.static(path.join(__dirname, "/image/profile")));
app.use("/upload/product", express.static(path.join(__dirname, "/image/product")));
app.use('/download/profile', express.static("image/profile"));
app.use('/download/product', express.static("image/product"));