var router = require('express').Router()
var p_login = require('../pages/login/login');
var p_upload = require('../pages/upload/upload');
//----- image upload ------//
var multer = require('multer');
var multer_profile = require('../api/multer/profile');
var multer_product = require('../api/multer/product');
var upload_profile = multer({storage : multer_profile.profile}).single('profile');
var upload_product = multer({storage : multer_product.product}).array('product', 8);
//---------------------------------------------------------------//


//---------------------------카테고리 접속 --------------------------//
var p_category = require('../pages/category/category');
router.post('/category/open', p_category.category_open);
router.post('/category/click', p_category.category_product_click);
//---------------------------회원가입 인증 --------------------------//
router.post('/auth/3', p_login.auth_3);
//---------------------------------------------------------------//

//---------------------------로그인 인증 --------------------------//
var p_login = require('../pages/login/login');
var p_login_dcmr = require('../pages/login/dcmr');
var p_login_logout = require('../pages/login/logout');
var p_login_destroy = require('../pages/login/destory');
router.post('/dcmr', p_login_dcmr.dcmr);
router.post('/login/1', p_login.login_1);
router.post('/login/2', p_login.login_2);
router.post('/login/3', p_login.login_3);
router.post('/logout', p_login_logout.logOut);
router.post('/destroy', p_login_destroy.destroy);
//-------------------------------ㅛ--------------------------------//

//---------------------------입찰 페이지 --------------------------//
var p_detail_product_bid = require('../pages/detail_product/bid');
var p_detail_product_heart = require('../pages/detail_product/heart');
var p_detail_product_reply  = require('../pages/detail_product/reply');
router.post('/bid', p_detail_product_bid.bid);
router.post('/heart', p_detail_product_heart.heart);
router.post('/reply', p_detail_product_reply.reply);
router.post('/reply2', p_detail_product_reply.reply2);
//---------------------------메인 페이지 --------------------------//
var p_main = require('../pages/main/main');
router.post('/hotproduct/view', p_main.hotProduct);
router.post('/hotproduct/click', p_main.hotProduct_click);

//-------------------------------ㅛ--------------------------------//
//---------------------------마이 페이지 --------------------------//
var p_mypage = require('../pages/mypage/mypage');

router.post('/mypage/view', p_mypage.mypage_view);
router.post('/mypage/update', p_mypage.mypage_update);
router.post('/mypage/bid', p_mypage.bid_list);
router.post('/mypage/sell', p_mypage.sell_list);
router.post('/mypage/ho', p_mypage.ho_list);
//---------------------------------------------------------------//
//---------------------------제품 업로드 --------------------------//
router.post('/upload/1', p_upload.upload_1);
//---------------------------------------------------------------//

//---------------------------제품 업로드 --------------------------//
var p_search = require('../pages/search/search');
router.post('/search/tag' , p_search.search);

//---------------------------------------------------------------//
//---------------------------이미지 업로드 --------------------------//
router.get('/upload/product_get',function(req,res){
    res.render('upload');
})
router.post('/upload/product',function(req,res){
    upload_product(req,res,function(err){
        if(err){
            console.log('*** /upload/product err :  %s',err);
            res.status(409).json({
                result : "0"
            });
        }
        else{
            console.log('/upload/product 이미지 등록 완료');
            res.status(200).json({
                result : "1"
            });
        }
    })
})

router.post('/upload/profile', function(req,res){
    upload_profile(req,res,function(err){
        if(err){
            console.log('*** /upload/profile err : %s', err);
            res.status(409).json({
                result : "0"
            });
        }
        else{
            console.log('/upload/profile 이미지 등록 완료');
            res.status(200).json({
                result : "1"
            });
        }
    })
})
//---------------------------------------------------------------//

module.exports = router

