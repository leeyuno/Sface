var sms_config = require('./sms_config');
var request = require('request');

//'01044743250'
var sms_send  = (id, sigNum) => {
    var extension = [{
        type: 'SMS',
        to: id,
        from: '01028331861',
    //   subject: '문자 발송 테스트!',
        text: '['+sigNum+']' +' 터치의 인증번호입니다.'
    
    }];
    
    request.post(
        sms_config.sendUri,
        { 
        form: {
            api_key: sms_config.api_key,
            timestamp: sms_config.timestamp,
            salt: sms_config.salt,
            signature: sms_config.signature,
            extension: JSON.stringify(extension)
        }
        },
        function(err, res, body) {
            console.log(body);
        }
    );
}

exports.sms_send  = sms_send;