const sqlite3 = require('sqlite3').verbose();

let query = "SELECT * from Institution where id = 1;"

let dbopen = function(fname) {
  let db = new sqlite3.Database(fname, sqlite3.OPEN_READWRITE, (err) => {
    if (err) {
      console.error(err.message);
    }
    console.log('Connected to the {0} database.'.format(fname));
  });
  return db;  
}

let dbclose = function(db) {
  // close the database connection
  db.close((err) => {
    if (err) {
      return console.error(err.message);
    }
    console.log('Close the database connection.');
  });
}


let dbShowQuery = function(fname, query) {
  let db = dbopen(fname);

  db.all(query, [], (err, rows) => {
      if (err) {
        throw err;
      }

      let result = "<table>";
      rows.forEach((row) => {
        //console.log(row.schoolName);
        result += '<tr>';
        result += '<td>' + row.id + '</td>';
        result += '<td>' + row.orgCode + '</td>';
        result += '<td>' + row.schoolName + '</td>';
        result += '</tr>';
      });
      result += "</table>";
      console.log(result);
    });

    dbclose(db);
}

module.exports = dbShowQuery;