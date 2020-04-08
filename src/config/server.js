module.exports = function(app) {

    /**
     * Preparing required modules
     */
    global.express = require('express');
    global.router = express.Router();
    global.mongoose = require('mongoose');

    const dotenv = require('dotenv');
    dotenv.config();

    /**
     * validation layer
     */
    const { check, buildCheckFunction, validationResult } = require('express-validator');
    checkBodyAndQuery = buildCheckFunction(['body', 'query']);
    global.validationResult = validationResult;
    global.check = check;

    app = express();

    /**
     * Extras
     */
    app.use(express.urlencoded({
        extended : true
    }));

    app.use(express.json());

    /**
     * @todo Routes
     */
    const api = require('../app/routes/api');

    app.use('/v1', api);

    /**
     * @todo improve layer of capturing and monitoring
     * this is working with error 500
     */
    app.use(function(err, req, res, next) {
        console.error(err.stack);
        res.status(500).send('Whoops! Something went wrong')
    });

    app.listen(process.env.SERVER_PORT, function() {
        console.log('server listening at port ' + process.env.SERVER_PORT);
    });
};