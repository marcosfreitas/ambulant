const express = require('express')
const dotenv = require('dotenv')

class App {
    constructor() {
       /**
        * Preparing required modules
        */
        this.express = express();
        this.envFile();

        /**
         * APP DEBUG
         * define a global CONST checked in services classes
         */
        this.IS_DEBUG = process.env.APP_DEBUG;

        this.middlewares();
        this.routes();
    }

    /**
     * Prepare dotenv to use production or development .env file
     */
    envFile() {
        this.dotenv = dotenv.config({
            path: process.env.NODE_ENV === 'dev' ? '.env.dev' : '.env'
        });
    }
}