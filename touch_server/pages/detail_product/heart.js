var User = require('../../model/user');
var Product = require('../../model/product');
var async = require('async');
var logger = require('../../api/logger/logger');

exports.heart = (req, res) => {
    var {id, product_id}  = req.body;

    async.waterfall([
        function(cb_product){
            Product.find({_id : product_id}, function(err, product){
                if(err){
                    return cb_product(err);
                }
                if(product.length === 0){
                    return cb_product('*** pages/detail_product/heart.js product not founded');
                }
                else{
                    cb_product(null, product);
                }
            })
        },
        function(cb_product,cb_user){
            User.find({id : id}, function(err,user){
                if(err){
                    cb_user(err);
                }
                if(user.length === 0){
                    cb_user('*** pages/detail_product/heart.js user not founded');
                }
                else{
                    var check = false;
                    var check2 = 0;
                    //만약 이미 호감에 올려진 경우 중복값을 찾자!
                    // console.log('1', user[0].hoProduct.length);
                    if(user[0].hoProduct.length === 0){
                        user[0].hoProduct.push({"product" : cb_product[0]._id});
                        user[0].save()
                        cb_user(null, cb_product);
                    }
                    else{
                        for(var i = 0; i < user[0].hoProduct.length; i++){
                            if(user[0].hoProduct[i].product === String(cb_product[0]._id)){
                                //이미 중복인 경우에는 ?
                                check = true;
                                check2 = i
                                break;
                            }
                            else{
                                check = false;
                            }
                        }
                        if(check === true){
                            User.update({id : id},{$pull : {"hoProduct" : {"product" : String(cb_product[0]._id)}}}, function(err,result){
                                if(err){
                                    return cb_user(err)
                                }
                                else{
                                    cb_user(null, cb_product);
                                }
                            });
                            // cb_user('이미 호감 목록에 있습니다.')
                            

                        }
                        else{
                            // console.log('3')
                            user[0].hoProduct.push({"product" : cb_product[0]._id});
                            user[0].save()
                            cb_user(null, cb_product);
                        }
                    }
                }
            })
        }
    ], function(err,result){
        if(err){
            logger.error(__dirname +'/heart.js function err : %s', err);
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