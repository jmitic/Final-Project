var express = require('express');
var router = express.Router();

/* 
 * GET home page.  The function here basically just calls runMainQuery()
 * with a fixed query.
 */
router.get('/', function(req, res, next) {
  runMainQuery(req, res, next, "SELECT * from Institution;");
});

/* 
 * POST home page.  The function here figures out the query to run and
 * calls runMainQuery() with that function.  
 */
router.post('/', function(req, res, next) {
  let query = '';
  console.log(req.body);
  /* If the columns aren't specified, there's no query here. */
  if (req.body.formname && (req.body.formname === 'SQL')) {
    // Query from the main form.
    // Note this is HIGHLY insecure!  Input should be
    // sanitized before being used as code!!
    query = `SELECT ${req.body.columns} FROM `
            + `${req.body.tablespec} WHERE `
            + `${req.body.where_clause};`;
  }
  else if (req.body.formname && (req.body.formname == 'dropdown')
            && req.body.columns && (req.body.columns !== '')
            && req.body.instID) {
    // Query from the dropdown form.  Again, the input really should be
    // sanitized for security.
    query = `SELECT * FROM Course WHERE `
            + `instID = ${req.body.instID};`;
    if (req.body.courseID){
      query='select * from (course inner join Equivalence on ForeignID=Course.id) inner join Reqt on ReqtID=Reqt.id ' + 
      `where instID= ${req.body.instID} and Course.id=${req.body.courseID}`;
      if (req.body.datetaken){
        query=query + ` and ((Equivalence.effective is null  or date(${req.body.datetaken}) >= Equivalence.effective) and (Equivalence.expires is null or date(${req.body.datetaken}) <=Equivalence.expires))`;
      }
      query=query + ';';
    }
  }
  else if (req.body.formname =='courseadd' && req.body.instID && req.body.crs_code && req.body.hours) {
    query = 'INSERT INTO Course(crs_code, crs_name, hours, instID)'
      + `VALUES('${req.body.crs_code}','${req.body.crs_name}',${req.body.hours},${req.body.instID});`;
  }
 
  else if (req.body.formname == 'addequiv' && req.body.courseID && (req.body.converseID || req.body.ReqtID)) {
    if (req.body.ReqtID) {
      query= 'INSERT INTO Equivalence(ReqtID, ForeignID, authorizedby, dateapproved)'
        +`values(${req.body.ReqtID}, ${req.body.courseID},`
        +"'default', date('1889-01-01'));";
    }
    else {
      query= 'INSERT INTO Equivalence(ConverseID, ForeignID, authorizedby, dateapproved)'
        +`values(${req.body.converseID}, ${req.body.courseID},`
        +"'default', date('1889-01-01'));";
    }
  }
  runMainQuery(req, res, next, query);
});

/*
 * Run the main SQL query, if there is one.  Attach the query text and the
 * rows of the result to req.app.locals, so we don't have to pass huge 
 * numbers of parameters to the functions downstream.  If there's no main
 * SQL query, then the query text is just the empty string and the rows are
 * an empty array.  Whether there's a main query or not, finish by calling
 * runSchoolsQuery().
 */
function runMainQuery(req, res, next, query) {
  req.app.locals.query = query;
  if (query) {
    console.log(query)
    req.app.locals.db.all(query, [], (err, rows) => {
      if (err) {
        throw err;
      }

      req.app.locals.rows = rows;
      runSchoolsQuery(req, res, next);
    });
  }
  else {
    // If there's no query, rows is just an empty array.
    req.app.locals.rows = [];
    runSchoolsQuery(req, res, next);
  }
}

/*
 * Run the schools query to fill the schools dropdown.  Again, attach the
 * rows of the result (under the name "schools") to req.app.locals.  Finish
 * by calling runCoursesQuery().
 */
function runSchoolsQuery(req, res, next) {
  let schools_query = 'SELECT id, schoolName from Institution;';
  let Converse_courses_query = 'SELECT id,crs_code from Course where instID=1;';
  let converse_requirements_query = 'SELECT id, ARC_code, description from Reqt;';
  req.app.locals.db.all(schools_query, [], (err, schools) => {
    if (err) {
      throw err;
    }
    req.app.locals.schools = schools;
    req.app.locals.db.all(Converse_courses_query, [], (err, converse_courses) => {
      if (err) {
        throw err;
      }
      req.app.locals.converse_courses = converse_courses;
      req.app.locals.db.all(converse_requirements_query, [], (err, converse_requirements) => {
        if (err) {
          throw err;
        }
        req.app.locals.converse_requirements = converse_requirements;
        runCoursesQuery(req, res, next);
      } );
      

    });
  });
}

/*
 * If instID is specified in the form data, run the courses query to fill
 * the courses dropdown.  As with the schools query, attach the value of
 * instID and the rows of the query result (under the name "courses") to
 * req.app.locals.  If instID is *not* specified, req.app.locals.courses
 * is just an empty array.  Either way, finish by calling showIndex().
 */
function runCoursesQuery(req, res, next) {
  if (req.body.instID) {
    req.app.locals.instID = req.body.instID;
    let courses_query = 'SELECT id, crs_code from Course '
                        + `where instID=${req.body.instID}`;
                // Regrettably, adding an ORDER BY clause to this query 
                // doesn't seem to change the eventual order of the courses
                // in the dropdown
    req.app.locals.db.all(courses_query, [], (err, courses) => {
      if (err) {
        throw err;
      }

      req.app.locals.courses = courses;
      showIndex(req, res, next);
    });

  }
  else { // instID not specified, don't run the query
    req.app.locals.instID = undefined;
    req.app.locals.courses = [];
    showIndex(req, res, next);
  }
}

/*
 * This function actually renders the HTML page on the result, using
 * index.pug.  Much of what happens in this function is extracting
 * values from req.apps.locals to pass as parameters to index.pug.
 */
function showIndex(req, res, next) {
  res.render('index', { title: 'crsequiv database app',
                        query: req.app.locals.query,
                        rows: req.app.locals.rows,
                        schools: req.app.locals.schools,
                        converse_courses: req.app.locals.converse_courses,
                        converse_requirements: req.app.locals.converse_requirements, 
                        instID: req.app.locals.instID,
                        courses: req.app.locals.courses,
                        postdata: req.body });
}

module.exports = router;
