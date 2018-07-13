var Product = require('../../model/product');
var User = require('../../model/user');
var async = require('async');

module.exports = function(){
    /* 제품 전체 _id 를 가져와 하나씩 찾아보고 존재하지 않을 경우 데이터를 삭제한다.
    1. 제품 정보(_id)를 모두 가져와 리스트로 저장
    2. 회원 리스트 정보(_id)를 모두 가져와 리스트 저장
    3. 모든 데이터 완료되면 유저 Find : _id -> product _id 확인하여 존재할 경우 패스 아니면 제거
     :  : 제품 존재 리스트 중 없는 것이 있으면 제거 : : 
    */

    // var product_list = [];
    // var user_list = [];

    var product_list;
    var user_list;
    var total_list = [];
    var user_id_array = [];
    var product_id_array = [];


    async.parallel([
        function(cb_product){
            Product.find({}, function(err,product){
                if(product.length > 0){
                    product_list = product
                    cb_product(null, product_list);
                }
            })
        },
        function(cb_user){
            User.find({}, function(err,user){
                if(user.length > 0){
                    user_list = user
                    cb_user(null, user_list);
                }
            })
        }
    ],function(err,result){
        if(err){
            console.log('?', err);
        }
        else{
            // total_list.push(result);
            //waterfall
            var one = [];
            var two = [];
            async.waterfall([
                function(cb_data){
                    for(var i =0; i < user_list.length; i++){
                        user_id_array.push(String(user_list[i]._id));
                    }
                    for(var y =0; y< product_list.length; y++){
                        product_id_array.push(String(product_list[y]._id));
                    }

                    if(product_id_array.length > 0 && user_id_array.length > 0){
                        async.eachSeries(user_list._id, function(obj,done){
                            User.find({"_id" : obj}, function(err,user){
                                if(err){
                                    done(err)
                                }
                                if(user.length === 0){
                                    done()
                                }
                                else{
                                    for(var a =0; a < user[0].hoProduct.length; a++){
                                        for(var b= 0; b < product_list.length; b++){
                                            if(user[0].hoProduct[a].product === product_list[b]._id){
                                                one.push(user[0].hoProduct[a].product);
                                            }
                                        }
                                    }
                                    console.log('one : ', one);
                                    var zero = [];

                                    if(one.length !== user[0].hoProduct.length){
                                        for(var d = 0; d < user[0].hoProduct.length; d++){
                                            zero.push(user[0].hoProduct[d].product);
                                        }

                                        for(var c = 0 ; c < zero.length; c++){
                                            for(var e = 0; e < one.length; e++){
                                                if(zero[c] === one[e]){
                                                    zero[c].pop();
                                                }
                                            }
                                        }

                                        console.log('zero : ', zero);

                                        user[0].hoProduct
                                    }
                                    else{

                                    }
                                    
                                    // user[0].hoProduct.product
                                }
                            })
                        })
                        
                        async.eachSeries(product_list._id, function(obj, done){
                            
                        })
                    }

        
                },
                function(){
        
                }
        
            ], function(err,result){
        
            })
        }
    })

    
}
