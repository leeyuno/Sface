var socket = require('socket.io');
var logger = require('./../logger/logger');
var msgSave = require('./../msgBackup/msgSave');

module.exports = function(io){
    console.log('1. socket.io test');

    // var io = require('socket.io')(app);

    io.sockets.on('connection', function(socket){
        console.log('2. socket.io [connect]');
        
        socket.on('join', function(data){
            console.log('3. socket.io [join]', data);
            var user = data.user
            var box = data.box

            io.sockets.to(box).emit('check', user);

            socket.join(box);
            console.log('3-1. socket.io [join : %s]', box);
            
            //현재 BOX 안에 있는 인원 체크 ;
            io.in(box).clients(function(err,inUser){
                console.log('3-2. socket.io [join  : %s,  count : %s]', box, inUser.length);
            })
        })

        socket.on('send', function(data){
            console.log('4. socket.io [SEND]', data);
            var sender = data.sender; //보내는 사람
            var receiver = data.receiver // 받는 사람
            var box = data.box;
            var msg = data.message;
            

            io.in(box).clients(function(err, inUser){
                if(err){
                    console.log('4-1. socket.io [SEND err : %s] ',err);
                }
                if(inUser.length === 0){
                    console.log('4-2 socket.io [SEND Warning : inUser legnth 0]');
                    io.sockets.in(box).emit('not')
                }
                if(inUser.length === 1){
                    console.log('4-3. socket. io [SEND offline push]');
                    /*
                        상대방이 오프라인인 상태이기 때문에, 푸시를 이용해 메세지 전달;
                        [ push 모듈 불러오기 ]
                    */
                    //임시 메세지 저장하기
                    return msgSave(receiver,sender, box,msg);
                }
                else{
                    console.log('4-4. socket. io [SEND online emit ]');
                    io.sockets.in(box).emit('message', sender, receiver, msg, box);
                }
            })
        })

        socket.on('dc', function(data){
            console.log('5. socket.io [ DC ]');
            var user = data.user;
            var box = data.box;

            io.in(box).clients(function(err, inUser){
                if(err){
                    console.log('5-1. socket.io [DC err : %s] ',err);
                }
                else{
                    if(inUser.length <= 0){
                        console.log('5-2 socket.io [DC warn :  inUser.length <= 0]');
                    }
                    else{
                        socket.leave(box);
                        io.in(box).clients(function(err,inUser2){
                            if(err){
                                console.log('5-3 socekt.io [DC err : %s]',err);
                            }
                            else{
                                console.log('5-4 socket.io [DC 현재 남은 인원 : %s] ', inUser2.length);
                            }
                        })
                    }
                }
            })
        })

        socket.on('disconnect', function(data){
            console.log('6. socket.io [disconnect]',data);
        })
    })

}