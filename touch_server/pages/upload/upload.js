var User = require('../../model/user');
var Product = require('../../model/product');
var logger = require('../../api/logger/logger');
var async = require('async');

exports.upload_1 = (req,res) => {
    //사진, 카테고리, 글제목, 최소금액, 즉시구매가 , 시간설정, 태그

    var { category, title, start_Bid, final_Bid, time, writer, text, tag, image} = req.body;

    console.log('업로드  : ' + tag, image + ' : 업로드 ');

    async.waterfall([
        function(cb_product){
            console.log('1' , tag);
            // console.log('2')
            var result = Product.create(title, category, time, writer, text, tag,start_Bid, final_Bid,image)
            cb_product(null, result._id);
        },
        function(cb_product, cb_user){
            User.find({id : writer},function(err,user){
                if(err){
                    logger.error(__dirname + err);
                }
                if(user.length === 0){
                    logger.error( __dirname +'user not founded');
                }
                else{
                    console.log('뀹 들어갔넹 ㅠㅠ')
                    console.log('?', cb_product);
                    user[0].sellProduct.push({"product" : cb_product});
                    user[0].save()
                    cb_user(null, user);
                }
            })
        }
    ],function(err,result){
        if(err){
            logger.error(__dirname + err);
            res.status(500).json({
                result : err
            })
        }
        else{
            res.status(200).json({
                resut: "1"
            })
        }
    })

    // const create = (product) => {
    //     // console.log(tag);
    //     // console.log(tag[0]);
    //     // // console.log()
        
    //     Product.create(title, category, time, writer, text, tag,start_Bid, final_Bid,image);
        
    //     return 1
    // }

    
    // const respond = (data) => {
    //     if(data === 1){
    //         User.find({id : writer}, function(err,user){
    //             if(err){
    //                 logger.error(err);
    //             }
    //             if(user.length === 0){
    //                 logger.error('user not found %s', writer);
    //             }
    //             else{
    //                 user[0].sellProduct.push({"product" : })
    //             }
    
    //         })
    //         res.status(200).json({
    //             result : "1"
    //         })
    //     }
    //     else{
    //         res.status(400).json({
    //             result : "0"
    //         });
    //     }
    // }

    // const onError = (error) => {
    //     console.log('*** /upload/1 error : ', error);
    //     res.status(409).json({
    //         result : "0"
    //     });
    // }

    // Product.findProduct()
    // .then(create)
    // .then(respond)
    // .catch(onError)
}
