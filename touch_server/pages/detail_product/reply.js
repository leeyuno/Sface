var User = require('../../model/user');
var Product = require('../../model/product');
var async = require('async');

exports.reply = (req,res) => {
    var {id, product_id, text} = req.body;

    //질문을 올리는 사람을 찾은 후, 제품의 reply에 텍스트를 집어넣는다.
    async.waterfall([
        function(cb_user){
            User.find({id : id}, function(err,user){
                if(err){
                    return cb_user(err);
                }
                if(user.length === 0){
                    return cb_user('*** pages/detail_product/reply user not founded');
                }
                else{
                    return cb_user(null, user);
                    // console.log(user[0])
                }
            })
        },
        function(cb_user,cb_product){
            Product.find({_id : product_id}, function(err,product){
                if(err){
                    return cb_product(err);
                }
                if(product.length === 0){
                    return cb_product('*** pages/detail_product/reply product not founded')
                }
                else{
                    //질문을 올린다. 판매자일 경우 질문을 올릴 순 없다.
                    //질문자가 작성자일 순 없다.
                    // console.log(cb_user[0].id , product[0].writer);
                    if(cb_user[0].id === product[0].writer){
                        return cb_product('판매자는 댓글을 쓸 수 없습니다.');
                    }
                    else{
                        product[0].reply.push({id : cb_user[0].id, nick : cb_user[0].profile.nick, text: text});
                        product[0].save();
                        
                        
                        //***********FCM***********//

                        return cb_product(null, product);
                    }
                }
            })
        }
    ], function(err,result){
        if(err){
            console.log('*** /pages/detail_product/reply error : %s',err);
            res.status(500).json({
                result : err
            })
        }
        else{
            res.status(200).json({
                result : result
            });
        }
    })
}


exports.reply2 = (req,res) =>{
    var {id , product_id, reply_key, text} = req.body;

    async.waterfall([
        function(cb_user){
            User.find({id : id}, function(err,user){
                if(err){
                    return cb_user(err);
                }
                if(user.length === 0){
                    return cb_user('user not founded');
                }
                else{
                    return cb_user(null, user);
                }
            })
        },
        function(cb_user,cb_product){
            Product.find({_id  : product_id}, function(err,product){
                if(err){
                    return cb_product(err);
                }
                if(product.length === 0){
                    return cb_product('product not founded');
                }
                // if(product[0].writer !== cb_user[0].profile.nick){
                if(product[0].writer !== cb_user[0].id){
                    return cb_product('제품의 주인이 아닙니다.');
                }
                else{
                    //반복문으로 댓글질문 _id 값을 찾는다. 
                    var check = false;
                    var num = 0;
                    var count = 0;

                    //질문에 대한 답글이 여러개일 경우 기존에 몇개가 달려있는지 확인하기 위한 반복문
                    for(var x =0; x < product[0].reply.length; x++){
                        if(product[0].reply[x].key  === reply_key){
                            count++
                        }
                    }
                    //답글의 위치를 선정하기 위하여 기존 댓글 뒤쪽에 위치하기 위한 수 작업
                    for(var i = 0; i < product[0].reply.length; i++){
                        if(String(product[0].reply[i]._id) === reply_key){
                            if(count > 0 ){
                                check = true;
                                num = i+1+count;
                            }
                            else{
                                check = true;
                                num = i+1;
                                
                            }
                            
                        }
                    }

                    if(check === true){
                        // product[0].reply.push({id : cb_user[0].id, nick : cb_user[0].profile.nick, text : text, key : product[0].reply[num-1]._id});
                        var obj = new Object;
                        obj.id = cb_user[0].id
                        obj.nick = cb_user[0].profile.nick
                        obj.text = text
                        obj.key = reply_key


                        product[0].reply.splice(num,0,obj);
                        product[0].save()

                        return cb_product(null, product);
                    }
                    else{
                        
                        return cb_product('not matched product reply');
                    }
                }
            })
        }
    ],function(err,result){
        if(err){
            console.log('*** /pages/detail_product/reply error : %s',err);
            res.status(500).json({
                result : err
            })
        }
        else{
            res.status(200).json({
                result : result
            });
        }
    })
}
