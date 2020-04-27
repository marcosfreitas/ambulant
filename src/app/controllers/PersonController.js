/**
 * @todo applies auth layer
 */
let PersonService = require('../services/PersonService');


class PersonController {

    constructor () {
        this.service = new PersonService();
    }

    all = async function(req, res) {
        try {
            let people = await this.service.all(req, res);
            res.json(people);

        } catch (error) {
            console.error(error);
            res.json({
                error: 1,
                code: 'unexpected_app_status',
                description: "Erro inesperado",
                data: []
            });
        }
    }

    store = async function(req, res) {
        try {

            /**
             * Expects attributes
             * name,lastname,email,age (optional)
             */
            let person = await this.service.store(req, res);

            res.json(person);

        } catch (error) {
            res.json({
                error: 1,
                code: 'unexpected_app_status',
                description: "Erro inesperado",
                data: []
            });
        }
    }
}

module.exports = PersonController;