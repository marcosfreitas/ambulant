 let Service = require('./Service');
 let PersonModel = require('../models/PersonModel');

 class PersonService extends Service
 {
    constructor () {
        /**
         * Here, it calls the parent class' constructor
         */
       super();

        /**
         * @info In derived classes, super() must be called before you can use 'this'.
         * Leaving this out will cause a reference error.
         */
       this.model = new PersonModel();
    }

 }

 module.exports = PersonService;