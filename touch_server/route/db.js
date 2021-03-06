var mongoose = require('mongoose');
mongoose.Promise = global.Promise;
var config = require('../config/config');


module.exports = function() {
    var database;       // 데이터베이스 객체를 위한 변수 선언
    var UserSchema;     // 데이터베이스 스키마 객체를 위한 변수 선언
    var UserModel;      // 데이터베이스 모델 객체를 위한 변수 선언

    connetDB();

function connetDB() {
	var databaseUrl = config.mongodbUri;
    console.log("Touch database connecting..............!!");
    //mongoose.Promise = global.Promise;
    mongoose.connect(databaseUrl);
    database = mongoose.connection;

	database.on('error', console.error.bind(console, 'mongoose connection error.'));
    database.on('open', function () {
	console.log('sface MongoDB is running .. : ' + databaseUrl);

	    // user 스키마 및 모델 객체 생성
	    //createUserSchema();
	});
        // 연결 끊어졌을 때 5초 후 재연결
	database.on('disconnected', function() {
        console.log('연결이 끊어졌습니다. 5초 후 재연결합니다.');
        setInterval(function(){
            connectDB()},5000);
    });
}
     //MongoDB 실행
    //require('../model/user'); //user schema 유저 스키마 불러오기
}