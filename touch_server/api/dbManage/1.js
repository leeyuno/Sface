var User = require('../../model/user');
var Product = require('../../model/product');
var async = require('async');

module.exports = function(userID,productID, where){
    // console.log(userID, productID, where , typeof(userID), typeof(productID), typeof(where));

    if(where === "hoProduct"){
        console.log(' : : 1 : :')
        User.update({_id : String(userID)},{$pull : {"hoProduct" : {"product" : String(productID)}}}, function(err, result){
            if(err){
                console.log('??' , err);
            }
            else{
                console.log('???', result);
            }
        });
    }
    if(where === "ingProduct"){
        console.log('?' , userID, productID)
        User.update({_id : String(userID)},{$pull : {"ingProduct" : {"product" : String(productID)}}}, function(err, result){
            if(err){
                console.log('??' , err);
            }
            else{
                console.log('???', result);
            }
        });
    }
    else{
        console.log('여기 맞아?')
        User.update({_id : String(userID)},{$pull : {"sellProduct" : {"product" : String(productID)}}}, function(err, result){
            if(err){
                console.log('??' , err);
            }
            else{
                console.log('???', result)
            }
        });
    }
}