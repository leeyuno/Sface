var winston = require('winston');

var logger = new(winston.Logger)({
    transports : [
        new (winston.transports.Console)(),
        // file transport add
        new (winston.transports.File)({
            filename : __dirname+'/../../logs/winston_test.log'
        })

    ]
})

module.exports = logger