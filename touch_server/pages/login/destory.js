var User = require('../../model/user');
var Product = require('../../model/product');
var async = require('async');

exports.destroy = (req,res) => {
    var {id , deviceId} = req.body; 
    
    async.waterfall([
        function(test){
            User.find({$and : [{id : id},{deviceId : deviceId}]},function(err, user){
                if(err){
                    test(err)
                }
                if(user.length === 0){
                    test('not Found User');
                    
                }
                else{
                    test(null, user);
                }
            })
        },
        function(test,test2){
            async.parallel([
                function(cb_user){
                    User.remove({$and : [{id : id}, {deviceId : deviceId}]}, function(err,user){
                        if(err){
                            cb_user(err)
                        }
                        if(user.length === 0){
                            cb_user('not matched User');
                        }
                        else{
                            cb_user(null, '1.remove user success');
                        }
                        
                    })
                },
                function(cb_product){
                    Product.remove({writer : test[0].profile.nick},function(err,product){
                        if(err){
                            cb_product(err);
                        }
                        if(product.length === 0){
                            cb_product('not matced Product');
                        }
                        else{
                            cb_product(null,'2. remove Product success');
                        }
                    })
                },
                function(cb_product_reply){
                    Product.find({"reply.id" : {$in : [test[0].profile.nick]}},function(err,reply){
                        if(err){
                            cb_product_reply(err);
                        }
                        if(reply.length === 0){
                            cb_product_reply('not matched reply');
                        }
                        else{
                            var list = [];
                            for(var x = 0; x < reply.length; x++){
                                list.push(reply[x]._id);
                            }
                            console.log('1.list :', list)
                            async.eachSeries(list, function(obj, done){
                                Product.update({_id : obj},{$pull : {"reply.id" : {$in : [test[0].id]}}}),done
                            }),
                            console.log('2.list : ')
                            cb_product_reply(null, '3. remove Reply success');
                        }
                    })
                    // Product.update({},{$pull : {"reply.id" :{$in : [test[0].id]}}})
                    // Product.find({"reply.id" : {$in : [test[0].id]}}, function(err, reply){
                    //     if(err){
                    //         cb_product_reply(err);
                    //     }
                    //     else{
                    //         cb_product_reply(null, reply);
                    //     }
                    // })
                }
            ], function(err,result1){
                if(err){
                    console.log('fuck',err);
                }
                else{
                    test2(null,result1);
                }
            })
        }
    ], function(err,result2){
        console.log('test', result2)
    }
)
}