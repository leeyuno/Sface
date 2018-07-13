var Product = require('../../model/product');

exports.category_open = (req,res) => {
    var { categoryNum } = req.body
    //조건 카테고리 번호로 지정
    
    Product.find({$and  : [{status : true},{category : categoryNum }]}, function(err, list){
        if(err) {
            console.log('*** /category/open/%s error : %s', categoryNum, err);
            res.status(500).json({
                result : "0"
            });
        }
        if(list.length === 0){
            console.log('*** /category/open/%s warn : not founded!', categoryNum);
            res.status(409).json({
                result : "0"
            });
        }
        else{
            console.log('/category/open success');
            res.status(200).json({
                result : list
            })
        }
    })    
}


exports.category_product_click = (req,res) => {
    var {_id } = req.body;

    Product.find({_id : _id}, function(err, product){
        if(err){
            console.log('*** /pages/category/category_product_click err : %s', err);
            res.status(500).json({
                result : "0"
            });
        }
        if(product.length === 0){
            console.log('*** /pages/category/category_product_click  warn : 데이터가 존재하지 않습니다.');
            res.status(400).json({
                result : "0"
            });
        }
        else{
            console.log('/pages/category/category_product_click  success');
            res.status(200).json({
                result : product
            });
        }
    })
}
//디저털/가전


/*
디지털/가전
게임/취미
스포츠/레저
유아
여성의류
여성잡화
남성의류
남성잡화
뷰티/미용
생활/식품
가구/인테리어
도서/티켓/음반
자동차
반려동물용품
// 부동산
*/


/*
여성의류
남성의류
패션잡화
뷰티/미용
유아/출산
스포츠/레저
디지털/가전
도서/티켓/취미/애완
생활/문구/가구/식품
차량/오토바이
기타
*/


/*
디지털/가전              : 1
스포츠/레저/취미           : 2
키덜트/피규어/소장          : 3
차량/오토바이 
남성의류
남성패션/잡화
여성의류
여성패션/잡화
뷰티/미용
유아/출산
인테리어/가구/장식
예술/음반
티켓/상품권/쿠폰
기타
*/