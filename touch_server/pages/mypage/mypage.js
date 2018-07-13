var User = require('../../model/user');
var Product = require('../../model/product');
var async = require('async');
var logger = require('../../api/logger/logger');
var dbManage = require('../../api/dbManage/1');

exports.mypage_view = (req,res) => {
    var {id,deviceId} = req.body;

    const check = (user) => {
        if(user) {
            if(user.deviceId === deviceId){
                return user
            }
            else{
                return 0
            }
        }
        else{
            throw new Error('Not founded user');
        }

    }

    const respond = (data) => {
        if(data) {
            res.status(200).json({
                result : data
            });
        }
        else{
            res.status(400).json({
                result : '0'
            });
        }
    }

    const onError = (error) => {
        console.error('*** /mypage error : %s',err);
        res.status(409).json({
            result : "0"
        })
    }

    User.findId(id)
    .then(check)
    .then(respond)
    .catch(onError)
}

exports.mypage_update = (req,res) => {
    var {id, deviceId, image, push } = req.body;

    const check = (user) => {
        if(user){
            if(user.deviceId === deviceId){
                user.image = image;
                user.push = push;
                user.save()            

                return user
            }
            else{
                return 0
            }
        }
        else{
            throw new Error('Not founded user');
        }
    }

    const respond = (data) => {
        if(data) {
            res.status(200).json({
                result : data
            });
        }
        else{
            res.status(400).json({
                result : '0'
            });
        }
    }

    const onError = (error) => {
        console.error('*** /mypage error : %s',err);
        res.status(409).json({
            result : "0"
        })
    }

    User.findId(id)
    .then(check)
    .then(respond)
    .catch(onError)
}



exports.bid_list = (req,res) => {
    var {id, deviceId} = req.body;


    async.waterfall([
        function(cb_user){
            User.find({$and : [{id : id}, {deviceId : deviceId}]}, function(err,user){
                if(err){
                    return cb_user(err);
                }
                if(user.length === 0){
                    return cb_user('user not founded');
                }
                else{
                    if(user[0].deviceId === deviceId){
                        cb_user(null, user);
                    }
                    else{
                        cb_user('user deviceID not matched');
                    }
                    
                }
            })

        },
        // cb_user 에서 ingProduct 리스트를 불러온다
        function(cb_user, cb_list){
            var arr_obj  = [];
            var arr_result = [];

            //async each 문을 돌리기 위한 object 배열 선언
            for(var i = 0; i < cb_user[0].ingProduct.length; i++){
                arr_obj.push(String(cb_user[0].ingProduct[i].product));
            }
            
            if(arr_obj.length > 0){
                async.eachSeries(arr_obj, function(obj,done){
                    Product.find({_id : obj}, function(err,ppp){
                        if(err){
                            logger.error(__dirname + err);
                            done(err);
                        }
                        else{
                            if(ppp.length > 0){
                                arr_result.push(ppp);
                                done()
                            }
                            else{
                                var userID  = cb_user[0]._id;
                                var productID = String(obj);

                                // dbManage(cb_user[0]._id,obj,"ingProduct");
                                dbManage(userID,productID,"ingProduct");
                                done()
                            }
                        }
                    })
                }, function(err){
                    if(err){
                        cb_list(err);
                    }
                    else{
                        cb_list(null, arr_result)
                    }
                })
            }
            else{
                cb_list('bid proudct is empty');
            }
        }
    ],function(err,result){
        var total = [];
        if(err){
            logger.error(__dirname + 'bid_test error : %s', err);
            res.status(500).json({
                result : err
            })
        }
        else{
            // console.log('씨발!!! : ',result);
            res.status(200).json({
                result : result
            })
        }
    })
}


exports.sell_list = (req,res) => {
    var {id, deviceId} = req.body;

    async.waterfall([
        function(cb_user){
            User.find({$and : [{id : id}, {deviceId : deviceId}]}, function(err, user){
                if(err){
                    logger.error(__dirname + 'sell list err : %s', err);
                    return cb_user(err);
                }
                if(user.length === 0){
                    return cb_user("user not founded");
                }
                else{
                    if(user[0].sellProduct.length >= 1){
                        cb_user(null, user[0]);    
                    }
                    else{
                        cb_user('판매목록이 존재하지 않습니다.');
                    }
                }
            })
        },
        function(cb_user, cb_product){
            var list = [];
            var total = [];
            console.log(cb_user)
            for(var i = 0; i < cb_user.sellProduct.length; i++){
                console.log(cb_user.sellProduct[i])
                list.push(cb_user.sellProduct[i].product);

            }
            console.log(list)

            async.eachSeries(list, function(item,done){
                console.log('?',item);
                Product.find({_id : item}, function(err, product){
                    // console.log(' :  : : : : ', product)
                    if(err){
                        done(err)
                    }
                    else{
                        if(product.length !== 0){
                            total.push(product);
                            done()
                        }
                        else{
                            // console.log('없는 것' , item);

                            //dbmanage 는 목록 중에 물품이 삭제되어 존재하지 않을 경우 실행된다.
                            var userID  = cb_user._id;
                            var productID = String(item);
                            dbManage(cb_user._id, item, "sellProduct");
                            done()
                        }
                    }
                });
            },function(err){
                if(err){
                    logger.error(__dirname + 'sell_list 223 err : ' + err);
                    cb_product(err);
                }
                console.log('180109  success');
                cb_product(null, total);
            });
        },
        function(cb_product, cb_sort){
            var list = cb_product;
            var trueData = [];
            var fasleData = [];
            
            for(var i = 0; i < list.length; i++){
                if(list[i].status === true){
                    trueData.push(list[i]);
                }
                else{
                    fasleData.push(list[i]);
                }
            }

            for(var t=0; t < fasleData.length; t++){
                trueData.push(fasleData[t]);
            }

            if(list.length === trueData.length){
                cb_sort(null, trueData);
            }
            
        }
    ], function(err,result){
        if(err){
            logger.error(__dirname + 'sell_list error : %s', err);
            res.status(500).json({
                result : err
            })
        }
        else{
            // console.log('씨발!!! : ',result);
            res.status(200).json({
                result : result
            })

        }
        
    })
}

exports.ho_list = (req,res) => {
    var {id, deviceId} = req.body;

    async.waterfall([
        function(cb_user){
            User.find({$and : [{id : id}, {deviceId : deviceId}]}, function(err, user){
                if(err){
                    logger.error(__dirname + 'sell list err : %s', err);
                    return cb_user(err);
                }
                if(user.length === 0){
                    return cb_user("user not founded");
                }
                else{
                    if(user[0].hoProduct.length >= 1 ){
                        cb_user(null, user[0].hoProduct);
                    }
                    else{
                        cb_user('호감 데이터가 없습니다.');
                    }
                    
                }
            })
        },
        function(cb_user, cb_product){
            var count = 0;
            var list = [];
            var total = [];

            for(var i = 0; i < cb_user.length; i++){
                list.push(cb_user[i].product);
            }

            async.eachSeries(list, function(item,done){
                // console.log('?',item);
                Product.find({_id : item}, function(err, product){
                    // console.log(' :  : : : : ', product)
                    if(err){
                        done(err)
                    }
                    else{
                        if(product.length !== 0){
                            total.push(product);
                            done()
                        }
                        else{
                            done()
                        }
                    }
                });
            },function(err){
                if(err){
                    logger.error(__dirname + 'sell_list 223 err : ' + err);
                }
                // console.log('180109  success');
                cb_product(null, total);
            });
        }
    ], function(err,result){
        if(err){
            logger.error(__dirname + 'ho_list error : %s', err);
            res.status(500).json({
                result : err
            })
        }
        else{
            res.status(200).json({
                result : result
            })
        }
    })
}
