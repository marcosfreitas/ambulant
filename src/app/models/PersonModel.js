const Model = require('./Model');
const PersonSchema = require('../schemas/PersonSchema');

// @todo implements Repository Pattern
class PersonModel extends Model {
    constructor () {

        super();

        this.model = 'person';
        this.schema = PersonSchema;
        this.repository = mongoose.model(this.model, this.schema);

    }

}

module.exports = PersonModel;