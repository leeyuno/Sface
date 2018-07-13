var User = require('../../model/user');
var MsgExport = require('../../api/msgBackup/msgExport');
// 토큰 받고, 임시메시지 저장

exports.dcmr = (req,res) => {
    var {id,  deviceId,token} = req.body ;

    const check = (user) => {
        console.log(req.body)
        // console.log(user.profile.nick)
        console.log(deviceId, user.deviceId);

        if(user){
            //유저가 존재할 경우 디바이스 체크 한다.
            console.log('디바이스 타입값 확인을 위한 콘솔, : ', typeof(user.deviceId), typeof(req.body.deviceId));
            if(user.deviceId === deviceId){
                if(user.profile.nick === 'undefined'){
                    return 3
                }
                else{
                    console.log('token save');
                    user.token = token;
                    user.save()
                    return 1
                }
            }
            else{
                //deviceId 가 다를 경우, 로그인페이지로 이동시킨다. 다시 인증시킨다.
                //또는 디바이스가 없을 수도 있다 그럼 무조건 로그인 페이지로 보낸다
                return 2
            }
        }
        else if(!user){
            //유저가 존재하지 않으면 또는 _id 가 없으면 신규가입/로그인 페이지로 이동 : /login/1
            return 2
        }
        else{
            //이도 저도 아니면
            throw new Error('*** /dcmr error');
        }
    }

    const respond = (data) => {
        if(data === 1){
            /*[ 임시메세지 불러오기 ]*/
            MsgExport(id, deviceId, function(err,result){
                if(err){
                    res.status(201).json({
                        result : "0"
                    })
                }
                else{
                    res.status(200).json({
                        result : result
                    })
                }
            })
        }
        else if(data === 2){
            //로그인 페이지로 이동합니다.
            res.status(300).json({
                result : "2"
            })
        }
        else if(data === 3){
            res.status(222).json({
                result : "3"
            })
        }
        else{
            //이도 저도 아닙니다. 그냥 로그인으로 보냅니다.
            res.status(400).json({
                result : "2"
            })
        }
    }

    const onError = (error) => {
        console.log('*** /dcmr error : %s', error);
        res.status(409).json({
            result : "0"
        });
    }

    User.findId(id)
    .then(check)
    .then(respond)
    .catch(onError)
}