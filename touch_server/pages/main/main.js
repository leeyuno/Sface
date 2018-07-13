var async = require('async');
var User = require('../../model/user');
var Product = require('../../model/product');

//가장 핫한 물품 리스트 받아오기
exports.hotProduct = (req,res) => {

    var { sex} =  req.body
//입찰자 수가 많다 || 조회수가 높다  || 시작가에서 최종금액까지 갭이 적다 || 여자면 의류 || 남자면 가전
    
    async.parallel([
        // // 입찰자 수가 많다 counter_Bid > 5
        // function(bid_count){
        //     Product.find({status: true}, function(err, one){
        //     // Product.find({$and :[{status: true}, {counter_Bid : {$gte  : 0}}]}, function(err, one){
        //         if(err){
        //             console.log('*** /main/hotproduct bid_count error : %s' ,err );
                    
        //         }
        //         if(one.length === 0){
        //             console.log('*** /main/hotproduct bid_count warn : not Founded' );
        //         }
        //         else{
        //             bid_count(null, one);
        //         }
        //     })
        // },
        // //시작가에서 최종금액 갭이 적을 때
        // function(bid_gap){
        //     Product.find({$and : [{status : true},{final_Bid : {$gt : 1000 }}, {gapTouch : {$gte: 1000}}]}, function(err, two){
        //     // Product.find({status : true}, function(err, two){
        //         if(err){
        //             console.log('*** /main/hotproduct bid_gap error : %s' ,err );
        //         }
        //         if(two.length ===  0){
        //             console.log('*** /main/hotproduct bid_gap warn  : not Founded');
        //         }
        //         else{
        //             bid_gap(null, two);
        //         }
        //     })
        // },
        function(bid_sex){
            //여자면 의류
            if(sex === 'female'){
                Product.find({$or : [{"category" : "여성의류"}, {"category" : "여성잡화"}]}, function(err, three){
                    if(err){
                        console.log('*** /main/hotproduct bid_sex female error : %s', err);
                    }
                    if(three.length === 0){
                        console.log('*** /main/hotproduct bid_sex warn : not Founded');
                    }
                    else{
                        bid_sex(null,three);
                    }
                })
            }
            //남자면 가전
            else{
                Product.find({$or : [{"status" : true},{"category" : "가전/디지털"}, {"category" : "자동차"}]}, function(err, four){
                    if(err){
                        console.log('*** /main/hotproduct bid_sex male error : %s', err);
                    }
                    if(four.length === 0){
                        console.log('*** /main/hotproduct bid_sex male warn : not fuonded');
                    }
                    else{
                        bid_sex(null,four);
                    }
                })
            }
        }
    ],
    function(err, result){
        if(err){
            console.log('*** /main/hotprodcut all error : %s', err);
            res.status(409).json({
                result : "0"
            });
        }
        else{
            console.log('*** /main/hotproduct success : fuck !!!');
            res.status(200).json({
                result : result
            });
        }
    })
}


exports.hotProduct_click = (req,res) => {
    var { _id } = req.body;


    const check = (product) => {
        if(product){
            return product;
        }
        else{
            throw new Error('not found Product');
        }
    }

    const respond = (product) =>{
        if(product){
            res.status(200).json({
                result : product
            });
        }
        else{
            res.status(400).json({
                result : "0"
            });
        }
    }

    const onError = (error) => {
        console.log('*** /hotProduct_click error : %s',error);
        res.status(409).json({
            result : "0"
        });
    }

    Product.findProduct(_id)
    .then(check)
    .then(respond)
    .catch(onError)
}