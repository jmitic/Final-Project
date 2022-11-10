var express = require('express');
var router = express.Router();

/* GET home page. */
router.get('/', function(req, res, next) {
  let dropdown_query = 'SELECT id, schoolName from Institution;';
  req.app.locals.db.all(dropdown_query, [], (err, schools) => {
    if (err) {
      throw err;
    }
    //console.log('Schools: ' + schools);
    let query = "SELECT * from Institution;"
    req.app.locals.db.all(query, [], (err, rows) => {
      if (err) {
        throw err;
      }

      //console.log(rows);
      res.render('index', { title: 'crsequiv database app', query: query, 
                  rows: rows, fillins: schools });
    });
  });
});

router.post('/', function(req, res, next) {
  let dropdown_query = 'SELECT id, schoolName from Institution;';
  req.app.locals.db.all(dropdown_query, [], (err, schools) => {
    if (err) {
      throw err;
    }
    //console.log('Schools: ' + schools);
    let query = '';
    if (req.body.formname && (req.body.formname === 'SQL')) {
      // Note this is HIGHLY insecure!  Input should be
      // sanitized before being used as code!!
      query = `SELECT ${req.body.columns} FROM `
              + `${req.body.tablespec} WHERE `
              + `${req.body.where_clause};`;
    }
    else if (req.body.formname && (req.body.formname == 'dropdown')) {
      query = `SELECT ${req.body.columns} FROM Course WHERE `
              + `instID = ${req.body.instID};`;
    }
    
    if (query !== '') {
      console.log(query);
      req.app.locals.db.all(query, [], (err, rows) => {
        if (err) {
          throw err;
        }

        //console.log(rows);
        res.render('index', { title: 'crsequiv database app', 
            query: query, rows: rows, fillins: schools });

      });
    }
    else { // No form data
      res.render('index', { title: 'crsequiv database app', 
                  query: '', rows: [], fillins: schools });
    }
  });
});

module.exports = router;
