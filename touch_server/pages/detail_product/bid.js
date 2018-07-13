var User = require('../../model/user');
var Product = require('../../model/product');
var async = require('async');


//입찰 버튼을 누를 경우, 입찰금액이 올라가고, 현재 최고 입찰자에 넣고, 입찰중인 목록에 넣고, 
exports.bid = (req,res) => {
    //입찰자에 대한 정보
    var {id, product_id} = req.body

    async.waterfall([
        
        //입찰자 정보를 가져온다. 카운트도 비교한다.
        //만약 카운트가 있는 사람이라면 입찰에 응한다.
        function(cb_user){
            console.log(id,product_id)
            User.find({id : id}, function(err,user){
                if(err){
                    return cb_user(err);
                }
                if(user.length===0){
                    return cb_user('*** bid.js user not founded');
                }
                else{
                    // 기회가 있는 놈만 입찰 가능함.
                    if(user[0].bidChance > 0){
                        return cb_user(null, user);
                    }
                    else{
                        return cb_user('*** bid.js user have not bidChande');
                    }
                }
            })
        },
        function(cb_user,cb_product){
            Product.find({_id : product_id}, function(err,product){
                if(err){
                    return cb_product(err);
                }
                if(product.length===0){
                    return cb_product('*** bid.js product not founded');
                }
                if(product[0].writer === cb_user[0].id){
                // if(product.writer === cb_user[0].profile.nick){
                    return cb_product('판매자는 입찰할 수 없습니다.');
                }
                if(product[0].now_Bid.id === id){
                    return cb_product('현재 최고입찰자는 입찰 할 수 없습니다.');
                }
                else{
                    if(product[0].status === true){
                        //제품의 경매가 진행중인 경우이니, 입찰 가격을 정하고 최고가로 갱신한다.
                        // --------------------- 제품에 대한 등록을 위한 부분 --------------- //
                        product[0].now_Bid.id = cb_user[0].id;
                        product[0].now_Bid.nick = cb_user[0].profile.nick;
                        //첫 입찰자일 경우 시작가 + 갭 값 더한다.
                        console.log('product_couter_bid : ', product[0].counter_Bid);
                        if(product[0].counter_Bid === 0){
                            product[0].now_Bid.bid = product[0].start_Bid + product[0].gapTouch;
                            console.log('1',product[0].start_Bid  + product[0].gapTouch)
                        }
                        //두번째 입찰자 부터는 현재가 + 갭 값으로 정한다.
                        else{
                            product[0].now_Bid.bid = product[0].now_Bid.bid + product[0].gapTouch;
                            console.log('2',product[0].now_Bid.bid + product[0].gapTouch)
                        }
                        product[0].counter_Bid += 1;
                        // --------------------- 유저에 대한 진행중인 내역을 위한 부분 --------------- //
                        //제품 입찰을 하였으니,  user.ingProduct 에 집어넣는다.
                        var check = false;

                        for(var i = 0; i < cb_user[0].ingProduct.length; i++){
                            // console.log('여기어때 ? : %s  : %s : %s', cb_user[0].ingProduct[i].product, product[0]._id, cb_user[0].ingProduct[i].product === product[0]._id);
                            if(cb_user[0].ingProduct[i].product === String(product[0]._id)){
                                check = true;
                            }
                        }
                        if(check  === true){
                            console.log('');
                        }
                        else{
                            cb_user[0].ingProduct.push({'product' : product[0]._id});
                        }    
                    
                        cb_user[0].save();
                        product[0].save();

                        return cb_product(null, product[0]);
                    }
                    else{
                        return cb_product('*** bid.js product is not biding');
                    }
                }
            })
        }
    ], function(err,result){
        if(err){
            console.log('*** /pages/detail_product/bid.js bid error : %s',err);
            res.status(500).json({
                result : err
            });
        }
        else{
            res.status(200).json({
                result : result
            });
        }
    })
}