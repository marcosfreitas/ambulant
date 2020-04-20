class Model {
    constructor() {
        this.model = null;
        this.schema = null;
        this.repository = null;
    }

    all = function(callback) {
        return this.repository.find({}, callback);
    };

    get = function(filter, callback) {
        return this.repository.find(filter, callback);
    };

    store = async function(data, callback) {
        let model = this.repository(data);
        return await model.save(callback);
    };

    deleteMany = function(filter, callback) {
        return this.repository.deleteMany(filter, callback);
    };

    deleteOne = function(filter, callback) {
        return this.repository.deleteOne(filter, callback);
    };

    update = function(filter, data, callback) {
        return this.repository.findOneAndUpdate(filter, data, {
            "new": true
        }, callback);
    };
}

module.exports = Model;