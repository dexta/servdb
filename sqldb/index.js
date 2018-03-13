const mysql = require('mysql');
const async = require('async');

// const filehandler = require('./filehandler.js');

const db_config = {
  host     : 'sqldb',
  user     : 'testdbuser',
  password : 'testdbpassword',
  database : 'testdatabase'
};

let rdb = {};

function handleDisconnect() {
  rdb.connection = mysql.createConnection(db_config);
  rdb.connection.connect(function(err) {
    if(err) {
      console.log('error when connecting to db:', err);
      setTimeout(handleDisconnect, 2000);
    }
  });

  rdb.connection.on('error', function(err) {
    console.log('db error', err.code);
    if(err.code === 'PROTOCOL_CONNECTION_LOST') {
      console.log("reconect to maria !!!");
      handleDisconnect();
    } else {
      throw err;
    }
  });
}

handleDisconnect();

rdb.testDatabase = function testDatabase(callback){
  let statBack = {check:'sql',state:false};
  rdb.testConnection( (err, data) => {
    if(err) {
      statBack.err = err;
    } else if(data||false) {
      statBack.info = 'connection and insert are working';
      statBack.state = true;
    } else {
      statBack.err = err;
      statBack.info = 'some went extreamly wrong';
    }
    callback(statBack);
  });
};


rdb.testConnection = function testConnection(callback) {
  rdb.connection.query('SELECT * FROM titletext LIMIT 10', function(err, rows, fields) {
    if(err) {
      let cTable = 'CREATE TABLE `titletext` (`id` INTEGER NULL AUTO_INCREMENT,`title` VARCHAR(256) NULL,`text` VARCHAR(4096) NULL ,PRIMARY KEY (`id`));';
      rdb.connection.query(cTable, function(err, rows, fields) {
        if(err) { 
          callback({error:'cant create table',query:cTable},null);
        } else {
          let createRows = rows;
          let iTable = 'INSERT INTO titletext (`title`, `text`) VALUES ("version","0.0.1");';
          rdb.connection.query(iTable, function(err, rows, fields) {
            if(err) {
              callback({error:'table created but instert miss',query:iTable},null);
            } else {
              callback(null,{createRows, insertRows:rows});
            }
          });
        }
      });
    } else {
      callback(null,rows);
    }
  });
};


rdb.query = function query(statement,callback) {
  rdb.connection.query(statement, function(err, rows, fields) {
    callback(err,rows,fields);
  });
};

rdb.pquery = function pquery(sql,args) {
  return new Promise( ( resolve, reject ) => {
      this.connection.query( sql, args, ( err, rows ) => {
          if ( err )
              return reject( err );
          resolve( rows );
      });
  });
};

rdb.insertData = function insertData(data,callback) {
  let inQuery = "INSERT INTO titletext";
  let keys = [];
  let values = [];
  for(let k in data) {
    keys.push(rdb.connection.escapeId(k));
    values.push(rdb.connection.escape(data[k]));
  }
  inQuery += " ("+keys.join(',')+")";
  inQuery += " VALUES ("+values.join(',')+")";
  rdb.query(inQuery,callback);
};


// rdb.importData = async function importData(filename) {
//   let filelist = await filehandler.filte2list(filename);
//   console.log('import sql from '+filename);
//   filelist.forEach( async (ele) => {
//     console.log(ele);
//     let re = await rdb.pquery(ele);
//   },rdb);
// };

// and export all
module.exports = rdb;