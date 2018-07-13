var User = require('../../model/user');
var sms_send = require('../../api/sms/sms_send');
var sms_config = require('../../api/sms/sms_config');
var rn = require('random-number');
var option = {
    min : 1111,
    max : 9999,
    integer : true
}


/*
1. 회원가입
    1.1  핸드폰번호 입력
    1.1.1  핸드폰이 등록된 경우 -> login 페이지로 이동
    1.1.2  핸드폰이 등록되지 않은 경우 ->  인증문자 발송
    1.2 핸드폰 인증번호 입력
    1.3 닉네임 및 프로필 사진 등록
    1.4 확인 끝

2. 로그인
    2.1 핸드폰 번호 입력
    2.2.1 핸드폰이 등록되어 있지 않을 경우 -> 회원가입 페이지로 이동
    2.2.2 핸드폰이 등록되어 있는 경우 -> 인증문자 발송
    2.3 핸드폰 인증번호 입력
    2.4.1 디바이스 아이디가 다를 경우, 닉네임 확인 작업 수행 후 완료
    2.4.2 디바이스 아이디가 같은 경우, 완료
*/

//login 1 에서 유저가 없을 경우 회원가입을 만든다.
exports.login_1 = (req,res) => {
    var {id} = req.body;
    console.log(id, typeof(id)) 
    const check  = (user) => {
        if(user){
            var sigNum = rn(option);
            // sms_send.sms_send(id, sigNum);
            user.sigNum = 1111
            // user.sigNum = sigNum
            user.save();
        }
        //인증번호
        else if(!user){
            var sigNum = rn(option); //인증번호 랜덤 
            // sms_send.sms_send(id, sigNum);

            return User.create1(id,1111)
            // return User.create1(id,sigNum)
        }
        else{
            // console.log(typeof(id))
            throw new Error('*** /login/1 err')
        }
    }   

    const respond = (user) => {
        console.log('login success : %s',id);
        res.status(200).json({
            result: "1"
        });
    }

    const onError = (error) => {
        console.log('*** login_1 onError : ', error);
        res.status(409).json({
            error : "0"
        });
    }

    User.findId(id)
    .then(check)
    .then(respond)
    .catch(onError)

}

// 신규유저일 경우 인증번호 입력 후 auth 3 으로 이동
exports.login_2 = (req,res) => {
    var {id , sigNum, deviceId} = req.body

    const check = (user) => {
        sigNum = Number(sigNum);
        if(user){
            if(user.sigNum === sigNum){
                //로그인이면
                if(user.deviceId ===  deviceId){
                    return 1
                }
                if(!user.deviceId){
                    return 2
                }
                else{
                    //회원은 존재하나 디바이스 아이디가 다르므로, 닉네임 인증으로 /login/3으로 보낸다
                    return user
                }
            }
            else{
                return 0;
            }
        }
        else{
            throw new Error('not found user id');
        }
    }

    const respond = (user) => {
        if(user === 1){
            console.log('login success')
            res.status(200).json({
                result: user
            });
        }
        else if(user === 2){
            //auth/3 으로 이동
            console.log('login new success');
            res.status(300).json({
                result : "2"
            });
        }
        else if(user === 0){
            res.status(409).json({
                result: "0"
            });
        }
        else{
            //인증은 성공하였으니 디바이스 아이디가 다를 경우 login_3 에서 닉네임을 인증하기 위하여 닉네임을 전송
            console.log('login failed : change deviceID');
            // var text_1 = user.profile.nick;
            var data = fn_nickChange(user.profile.nick);
            //login/3 으로 이동
            console.log('test : ',data)
            res.status(333).json({
                result : data 
            })
            // res.status(400).json({
            //     result : data 
            // })
        }
    }

    const onError = (error) => {
        console.log('***  login_2 error : %s', error);
        res.status(409).json({
            result : "0"
        });
    }

    User.findId(id)
    .then(check)
    .then(respond)
    .catch(onError)
}

exports.login_3 = (req,res) => {
    var {id, nick, deviceId} = req.body;

    const check = (user) => {
        if(user){
            if(user.profile.nick === nick){
                user.deviceId = deviceId
                user.save()
                return user
            }
            else{
                return 0
            }
        }
        else{
            throw new Error('not founed user');
        }
    }
    const respond = (data) => {
        if(data){
            console.log('login success : %s',data.id)
            res.status(200).json({
                result: "1"
            });
        }
        else{
            console.log('login failed : %s', id)
            res.status(400).json({
                result : "0"
            })
        }
        
    }

    const onError = (error) => {
        console.log('***  login_2 error : %s', error);
        res.status(409).json({
            result : "0"
        });
    }

    User.findId(id)
    .then(check)
    .then(respond)
    .catch(onError)

}

//인증까지 완료되었으니, 닉네임 프로필 사진 등록한다.
exports.auth_3 = (req,res) => {
    
    var {id, nick,sex, deviceId, push} = req.body;

    const check = (user) => {
        if(user){
            user.deviceId = deviceId;
            user.profile.nick = nick;
            user.profile.push = push;
            user.profile.sex = sex;

            user.save();
            return 1;
        }
        else{
            throw new Error('not founded user!');
        }
    }

    const respond = (data) => {
        console.log(data);
        if(data === 1){
            res.status(200).json({
                result : "1"
            });
        }
        else{
            res.status(400).json({
                result : "0"
            });
        }
        
    }

    const onError = (error) =>{
        console.log('*** auth_3 : ',error);
        res.status(409).json({
            result : "0"
        });
    }

    User.findId(id)
    .then(check)
    .then(respond)
    .catch(onError)

}


function fn_nickChange(user){
    var text_1 = user
    var text_2 = text_1.length;
    var text_3 = parseInt(text_2/2)

    var text_4 = text_1.substring(text_3);
    var text_5  = '*'
    for(var a = 0; a < text_4.length-1; a++){
        console.log(text_5) ;
        text_5 += '*'
    };

    var text_6 = text_1.substring(0, text_3);
    var text_7 =text_6 + text_5

    return text_7;

}