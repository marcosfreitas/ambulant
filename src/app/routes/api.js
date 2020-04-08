const router = global.router;
const checkBodyAndQuery = global.checkBodyAndQuery;
const check = global.check;
const validationResult = global.validationResult;

let PersonController = require('../controllers/PersonController');
let PersonControllerInstance = new PersonController();

router.get('/', function (req, res) {
    res.json({"working" : true});
});

router.get('/person', function(req, res) {
    PersonControllerInstance.index(req, res);
});

module.exports = router;