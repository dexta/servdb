const mysql = require('mysql');
const async = require('async');

// const filehandler = require('./filehandler.js');
const sqlAPI = require('./sqlAPI.js');

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


// test the database, tables and insert/selcet

// rdb.testDbConection = function testDbConection() {
//   return new Promise( (resolve, reject) => {
//     this.connection.connect( (err, data) => {
//       if (err) reject(err);        
//       resolve(this.connection.threadId);
//     });
//   });
// };

rdb.testDbTable = async (tableName) => {
  let doesItExist = await rdb.pquery(`SELECT * FROM ${tableName} LIMIT 1;`);
  if(doesItExist.length===0) {
    console.log(`no table with name ${tableName}`);
  } else {
    console.log(`some table here with name: ${tableName}`);
    console.dir(doesItExist);
  }
  return doesItExist;
};

rdb.showColumnsFrom = async (nameTable) => {
  let columns = await rdb.pquery(`show columns from ${nameTable}; `);
  if(columns.length===0) {
    console.log(`no columns in table with name ${nameTable}`);
  } else {
    console.log(`table here with name: ${nameTable} columns`);
    console.dir(columns);
  }
  return columns;
};


rdb.createTable = async (createObj) => {
  // DROP TABLE IF EXISTS `history`;
    
  // CREATE TABLE `history` (
  //   `id` INTEGER NOT NULL AUTO_INCREMENT,
  //   `key` VARCHAR(3072) NOT NULL,
  //   `value` VARCHAR(3072) NOT NULL,
  //   PRIMARY KEY (`id`)
  // );
  // createObj = {};
  // createObj.dropTable=true;
  // createObj.tableName='history';
  // createObj.primaryKey='id';
  // createObj.col = [];
  // createObj.col[0] = {name:'id',type:'INTEGER',options:' NOT NULL AUTO_INCREMENT'};
  // createObj.col[1] = {name:'key',type:'VARCHAR(3072)',options:'NOT NULL'},
  // createObj.col[2] = {name:'value',type:'VARCHAR(3072)',options:'NOT NULL'},
  // createObj.col[3] = {name:'',type:'',options:''},

  console.log("create Object ");
  console.dir(createObj);

  let createQuery = '';
  let colList = '';
  if(createObj.dropTable) {
    let dropedTable = await rdb.pquery('DROP TABLE IF EXISTS `'+createObj.tableName+'`;');
    console.log(`dropping table ${createObj.tableName}`);
    console.dir(dropedTable);
  }

  for(let c=0,cl=createObj.col.length;c<cl;c++) {
    let colI = createObj.col[c];
    colList += '`'+colI.name+'` '+colI.type+' '+colI.options+',';
  }
  colList += 'PRIMARY KEY (`'+createObj.primaryKey+'`)';

  createQuery += 'CREATE TABLE `'+createObj.tableName+'` (';
  createQuery += colList;
  createQuery += ');'
  
  console.log("create Table Query");
  console.log(createQuery);

  let crtaCall = await rdb.pquery(createQuery);
  return crtaCall;
};
// end the testing of databse, tables and select/inserts




rdb.insertOne = async function insertOne(data) {
  return await sqlAPI.insertEntry(rdb, data);
};

rdb.searchByKey = async function searchByKey(key) {
  return sqlAPI.searchKey(rdb, key);
};

rdb.searchByValue = async function searchByValue(value) {
  return sqlAPI.searchValue(rdb, value);
};

rdb.getOneValue = async function getOneValue(key) {
  return sqlAPI.getOneValue(rdb, key);
};

rdb.searchKeyValLimit = async function searchKeyValLimit(options) {
  return sqlAPI.searchKeyValLimit(rdb,options);
};

// and export all
module.exports = rdb;