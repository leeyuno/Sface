var mongoose = require('mongoose');
mongoose.Promise = global.Promise;
var Schema = mongoose.Schema;
const crypto = require('crypto')
const config = require('../config/config.js')

var productSchema = new Schema({
    title : String,
    category  : String,
    writer : String,
    image  : Array,
    text : String,
    tag  : Array,
    reply  : [{
        id : String,
        nick : String,
        text: String,
        key:String
    }]
    ,
    time : Number, //ex) 5, 10, 15, 20, 24 
    created_at : String,
    deleted_at : String,
    status : {type : Boolean , 'default' : true} // 경매중 : true, 경매완료 : false
    , 
    counter_Bid : {type : Number , 'default': 0}, //현재까지 입찰 횟수
    now_Bid : {
        id : String,
        nick : String,
        bid  : Number
    },
    start_Bid : Number, //시작가
    final_Bid : Number, // 즉시 구매가
    gapTouch : Number, // 터치 버튼 누를시 버튼당 가격을 어떻게 정할지 기준이 필요함.
    /*
        시작가와 즉시구매가의 갭 차이가 
        종가 - 시작가 = 갭
        갭 의 3 ~ 5프로를 갭 터치 버튼 값으로 지정
    */

})

function getTimeStamp_plus(time) {

    var d = new Date();
    d.setHours(d.getHours() + time);

    var s = 
    leadingZeros(d.getFullYear(), 4) + '-' +
    leadingZeros(d.getMonth() + 1, 2) + '-' +
    leadingZeros(d.getDate(), 2) + ' ' +

    leadingZeros(d.getHours(), 2) + ':' +
    leadingZeros(d.getMinutes(), 2) + ':' +
    leadingZeros(d.getSeconds(), 2);

    return s

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
  


productSchema.statics.findProduct = function(_id){
    return this.findOne({
        _id : _id
    }).exec()
}

productSchema.statics.create = function(
                                        title, 
                                        category, 
                                        time, 
                                        writer, 
                                        text, 
                                        tag,
                                        start_Bid, 
                                        final_Bid,
                                        image)
{
    const gap = parseInt((final_Bid - start_Bid) * 0.1) ; //현재 10프로 

    // const tagArray = tag[0] 

    const product = new this({
        title,
        category,
        time,
        writer,
        text,
        tag,
        start_Bid,
        final_Bid,
        gapTouch : gap,
        image,
        created_at : getTimeStamp(),
        deleted_at : getTimeStamp_plus(time)
    })
    
    product.save()
    
    return product

}



module.exports = mongoose.model('Product', productSchema);