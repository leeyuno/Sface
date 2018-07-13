var User = require('../../model/user');

//로그아웃 기능
exports.logOut = (req,res) => {
    var {id,deviceId} = req.body;

    const check = (user) => {
        if(user){
            if(user.deviceId === deviceId){
                return 1
            }
            else{
                return 0
            }
        }
        else{
            return 0
        }
    }

    const respond = (data) => {
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
    const onError = (error) => {
        console.log('*** /logout Err : %s', err)
        res.status(409).json({
            result : "0"
        })
    }

    User.findId(id)
    .then(check)
    .then(respond)
    .catch(onError)
}