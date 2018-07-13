  var config = {}
  config.HOST = 'localhost';
  config.HTTP_PORT = 8080;
  config.HTTPS_PORT = 443;
  config.SOCKET_PORT = 7777;
  config.SUCCESS_RESPONSE = 200;
//   config.mongodbUri = 'mongodb://mongoSface:Sface0121@192.168.0.6:27017/onami' 
  config.mongodbUri = 'mongodb://localhost:27017/touch'
  //---------------JWT Token key --------------------//
  config.secret = 'SfaceSecret';
  //-------------------------------------------------//
  //-------node Mailer-------//
  config.mail_service = "Gmail"
  config.mail_host = "smtp.gmail.com"
  config.mail_port = "465"
  config.mail_user = "sface.ssu@gmail.com"
  config.mail_password = "als1tn23"
  
  config.redis_cfg_port = 6379;
  config.redis_cfg_host = '127.0.0.1';
  config.redis_cfg_db = 0;
  
  //var module = module || {};
  module.exports = config;
  
  