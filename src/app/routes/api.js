/**
 * @todo implement a new pattern of json responses
 * @todo resolve the eslint's alerts
 */

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
    PersonControllerInstance.all(req, res);
});

router.put('/person', function(req, res) {
    PersonControllerInstance.store(req, res);
});

module.exports = router;