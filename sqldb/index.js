const mysql = require('mysql');
const async = require('async');

// const filehandler = require('./filehandler.js');
const sqlAPI = require('./sqlAPI.js');
const schemeAPI = require('./sqlScheme.js');
const sql_config = require('./config.js');

// console.dir(sql_config.db[0].tables[0].cols);

let db_config = {};

db_config.host = (process.env.MYSQL_HOST)? process.env.MYSQL_HOST : 'sqldb';
db_config.user = (process.env.MYSQL_USER)? process.env.MYSQL_USER : 'testdbuser';
db_config.password = (process.env.MYSQL_PASSWORD)? process.env.MYSQL_PASSWORD : 'testdbpassword';
db_config.database = (process.env.MYSQL_DATABASE)? process.env.MYSQL_DATABASE : 'testdatabase';

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
      console.log("reconect to percona !!!");
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
          // console.dir(err);
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

rdb.insertOne = async (data) => {
  return await sqlAPI.insertEntry(rdb, data);
};

rdb.searchByKey = async (key) => {
  return sqlAPI.searchKey(rdb, key);
};

rdb.searchByValue = async (value) => {
  return sqlAPI.searchValue(rdb, value);
};

rdb.getOneValue = async (key) => {
  return sqlAPI.getOneValue(rdb, key);
};

rdb.searchKeyValLimit = async (options) => {
  return sqlAPI.searchKeyValLimit(rdb,options);
};


// be sure we have the right scheme for our database
rdb.testDbTable = async (tableName) => {
  return schemeAPI.testDbTable(rdb,tableName);
};

rdb.showColumnsFrom = async (tableName) => {
  return schemeAPI.showColumnsFrom(rdb,tableName);
};

rdb.createTable = async (createObject) => {
  return schemeAPI.createTable(rdb,createObject);
};

rdb.checkSQLstate = async (ckObj) => {
  return schemeAPI.checkSQLstate(rdb,ckObj);
};

// 
// test database with config schema
// 
rdb.checkSQLstate(sql_config);
// 
// end testing database schema
// 


// and export all
module.exports = rdb;