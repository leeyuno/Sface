var async = require('async');
var Product = require('../../model/product');

exports.search = (req,res) => {
    var { data } = req.body;

    //db.products.getIndexes()
    //db.products.createIndex({"title" : "text", "tag" : "text"});

    //test
    // Product.find({tag : {$elemMatch  : {$in : [data]}}}, function(err,result){
    //     // console.log(result)
    //     if(err){
    //         console.log('*** /search/tag error : %s', err);
    //     }
    //     if(result.length === 0){
    //         console.log('*** /search/tag warn : Not Founded!');
    //     }
    //     else{
    //         res.status(200).json({
    //             result : result
    //         });
    //     }
    // })
    //test2 제목 검색 .sort({score :{$meta : "textScore"}}) ,{score : "textScore"}
    Product.find({$text : {$search : data}},function(err,result){
        console.log(result)
        if(err){
            console.log('*** /search/tag error : %s', err);
        }
        if(result.length === 0){
            console.log('*** /search/tag warn : Not Founded!');
        }
        else{
            res.status(200).json({
                result : result
            })
        }
    })
    /* 
        검색 유형
        1. 태그 검색
        2. 제목 검색
        3. 
    */
    // async.parallel([
    //     function(search_tag) {
    //         // Product.find({$and : [{status : true},{}]}) //진행중인 제품만 보고싶을 경우
    //         Product.find({tag : {$in : tag}, function()})

    //     },
    //     function() {

    //     },
    //     function() {

    //     },
    //     function(){

    //     },

    // ],function(err, result){
    //     if(err){

    //     }
    //     else{

    //     }
    // })
}





/*


exports.clan_search_detail = (req,res) => {
    
    var text = req.body.text 
    

    Clan.find({}, function(err,clan){
        if(err) {
            errLog.info('clan / searchClan.js / clan_search_detail / err1 %s' , err);
            res.send({"result" : "0"});
        }
        if(!clan[0]){
            console.log('clan search detail not found')
            res.send({"result" : "2"});
        }
        else{
            console.log('clan search detail found')
            // res.send({"result" : clan})
            // console.log(clan[0].id.indexOf(text))
            var totalClan = [];
            for(var x = 0; x < clan.length; x++){
                if(clan[x].id.indexOf(text) > -1){
                    // console.log(clan[x].id.indexOf(text))
                    totalClan.push(clan[x])
                }
            }
            for(var y=0; y < clan.length; y++){
                if(clan[y].game.indexOf(text) > -1){
                    // console.log(clan[y].game.indexOf(text))
                    totalClan.push(clan[y])
                }
            }
            res.send({"result" : totalClan})
        }
    })
}
*/
