var mongoose = require('mongoose');
mongoose.Promise = global.Promise;
var Schema = mongoose.Schema;
const crypto = require('crypto')
const config = require('../config/config.js')

var adminSchema = new Schema({
    username : String,
    password : String,
    DisplayName : String,
    created_at: {type: Date, index: {unique: false}, 'default': Date.now},
    updated_at: {type: Date, index: {unique: false}, 'default': Date.now}
})

module.exports = mongoose.model('Admin', adminSchema);