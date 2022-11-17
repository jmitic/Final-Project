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
      console.log(req.body);
      res.render('index', { title: 'crsequiv database app', query: query, 
                  rows: rows, schools: schools, postdata: {} });
    });
  });
});

router.post('/', function(req, res, next) {
  let schools_query = 'SELECT id, schoolName from Institution;';
  req.app.locals.db.all(schools_query, [], (err, schools) => {
    if (err) {
      throw err;
    }
    //console.log('Schools: ' + schools);
    console.log('instID: ' + JSON.stringify(req.body.instID));

    let courses_query = 'SELECT id, crs_code from Course '
                        + `where instID=${req.body.instID}`;
    req.app.locals.db.all(courses_query, [], (err, courses) => {
      if (err) {
        throw err;
      }

      let query = '';
      if ((!req.body.columns) || (req.body.columns == '')) {
        query = '';
      }
      else if (req.body.formname && (req.body.formname === 'SQL')) {
        // Note this is HIGHLY insecure!  Input should be
        // sanitized before being used as code!!
        query = `SELECT ${req.body.columns} FROM `
                + `${req.body.tablespec} WHERE `
                + `${req.body.where_clause};`;
      }
      else if (req.body.formname && (req.body.formname == 'dropdown')
                && req.body.columns && (req.body.columns !== '')
                && req.body.instID) {
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
          console.log(req.body);
          res.render('index', { title: 'crsequiv database app', 
              query: query, rows: rows, schools: schools, 
              postdata: req.body });

        });
      }
      else { // No form data
        console.log(req.body);
        res.render('index', { title: 'crsequiv database app', 
                    query: '', rows: [], schools: schools, postdata: req.body });
      }
    });
  }); 
});

module.exports = router;
