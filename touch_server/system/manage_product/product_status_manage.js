var Product = require('../../model/product');
var manageImage = require('../manage_image/manageImage');
// product Bid Status check;
// 제품 경매 시간이 지난 경우 자동으로 false 처리함
module.exports = function() {
    var time_1  = getTimeStamp()
    
    // setTimeOut('pbsc()', 50000);
    var test = setInterval(pbsc,10000);
    
    function pbsc(){
        Product.find({$and : [{"status" : true},{ "deleted_at" : {$lte : time_1}}]}, function(err,result){
            if(err){
                console.log('[system] manage_product manageProduct.js error : %s', err);
            }
            if(result.length === 0){
                // console.error('fuck')
                console.log('[system] 현재 경매를 종료할 데이터가 없습니다. ');
            }
            else{
                // console.log('fuck2', result);
                for(var a = 0; a < result.length; a++ ){
                    result[a].status = false;
                    //경매가 종료되어야 할 물품의 이미지들을 블러처리를 해버린다. 
                    for(var b = 0; b < result[a].image.length; b++){
                        manageImage(result[a].image[b]);
                    }
                    result[a].save()

                }
                console.log('[system] manageProduct.js pbsc() success');
            }
        })
    }

    function getTimeStamp() {
        var d = new Date();
        var s =
          leadingZeros(d.getFullYear(), 4) + '-' +
          leadingZeros(d.getMonth() + 1, 2) + '-' +
          leadingZeros(d.getDate(), 2) + ' ' +
      
          leadingZeros(d.getHours(), 2) + ':' +
          leadingZeros(d.getMinutes(), 2) + ':' +
          leadingZeros(d.getSeconds(), 2);

        return s;
      }
      
      function leadingZeros(n, digits) {
        var zero = '';
        n = n.toString();
      
        if (n.length < digits) {
          for (i = 0; i < digits - n.length; i++)
            zero += '0';
        }
        return zero + n;
      }
    }











