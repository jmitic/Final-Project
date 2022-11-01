var express = require('express');
var router = express.Router();
var database = require('../public/javascripts/dbconnect.js');

/* GET home page. */
router.get('/', function(req, res, next) {
  let db = database.dbopen('/crsequiv.sqlite');
  database.dbclose(db);
  res.render('index', { title: 'crsequiv database app' });
});

module.exports = router;
