
var crypto = require('crypto');
var randomstring = require('randomstring');
var rn = require('random-number');
var request = require("request");
//https://www.coolsms.co.kr/index.php/detail?apiKey=NCSQ1ZTCBDSPZC9I
var api_key = 'NCSQ1ZTCBDSPZC9I';
var api_secret = 'Q8YM5BY39DIDBFXAK9PAODQY1GUSDHBE';
var timestamp = parseInt(new Date().getTime() / 1000);
var salt = randomstring.generate(30);
var signature = crypto.createHmac('md5', api_secret).update(timestamp + salt).digest('hex');

var option = {
    min : 1111,
    max : 9999,
    integer : true
}
var signatureNumber = rn(option);

var sms_config = {};
sms_config.api_key = api_key;
sms_config.api_secret = api_secret;
sms_config.signatureNumber = signatureNumber;
// sms_config.extension = extension;
sms_config.sendUri = 'https://api.coolsms.co.kr/sms/1.2/send';
sms_config.timestamp = timestamp;
sms_config.salt = salt
sms_config.signature = signature

console.log(sms_config.api_key);

module.exports = sms_config;