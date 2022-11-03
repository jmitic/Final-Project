var express = require('express');
var router = express.Router();

/* GET home page. */
router.get('/', function(req, res, next) {
  let query = "SELECT * from Institution;"
  req.app.locals.db.all(query, [], (err, rows) => {
    if (err) {
      throw err;
    }

    //console.log(rows);
    res.render('index', { title: 'crsequiv database app', query: query, rows: rows });
  });

  
});

module.exports = router;
