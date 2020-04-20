const PersonSchema = mongoose.Schema({
    name: {
        type: String,
        require: true,
    },
    lastname: {
        type: String,
        require: true,
    },
    email: {
        type: String,
        require: true,
    },
    age: {
        type: String
    },
    created_at: {
        type: Date,
        default: Date.now,
        require: true
    },
    updated_at: {
        type: Date,
        default: Date.now,
        require: true
    },
});

module.exports = PersonSchema;