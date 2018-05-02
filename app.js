const express = require('express');
const config = require('./config.js');

const DEFAULT_HOST = '0.0.0.0';
const DEFAULT_PORT = 8080;

// some Container information
// leftover by cp
const os = require("os");
const hostname = os.hostname();
const ipinterface = os.networkInterfaces();
const hostip = (ipinterface.eth0||false)? ipinterface.eth0[0].address : '0.0.0.0';
// ------
// ----
// -- 

const app = express();
require('express-async-errors');
const bodyParser = require('body-parser');
app.use(express.static('frontend'));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({extended: true}));


const sql = require('./sqldb');

async function checkVersion() {
  let lastVersion = await sql.pquery('SELECT text FROM titletext WHERE title = "version" ORDER BY id ASC LIMIT 1;');
  console.log("lastVersion "+lastVersion[0].text);
  // console.log("update to version 0.0.2");
  // sql.importData(__dirname+'/updateData/version002.sql');
};

const retrysql = () => {
  sql.testDatabase( (testresult) => {
    if(testresult.err) {
      setTimeout(retrysql,2000);
    } else {
      checkVersion();
    }
    console.dir(testresult);
  });
}; 

async function newTestStack() {
  // let testConections = await sql.testDbConection();
  let testTable = await sql.testDbTable('servtable');
  let tableColumns = await sql.showColumnsFrom('servtable');
  // console.dir(testTable);
  // console.dir(tableColumns);
  let testVersion = {};
  testVersion.dropTable=true;
  testVersion.tableName='version';
  testVersion.primaryKey='id';
  testVersion.col = [];
  testVersion.col[0] = {name:'id',type:'INTEGER',options:' NOT NULL AUTO_INCREMENT'};
  testVersion.col[1] = {name:'version',type:'VARCHAR(64)',options:'NOT NULL'};
  let testCreate = await sql.createTable(testVersion);
  console.log(testCreate);
};

newTestStack();

// retrysql();

// rest routes api
const restAPI = require('./restapi')(app,sql,config);

// rest routes test
// TODO: add some test 
app.get('/hostdata', (req,res) => {
  res.status(200).json({hostname,hostip,buildversion:process.env.BUILD_VERSION});
});

app.get('/test/truefalse/', (req,res) => {
  res.status(200).json({testTrue:true,testFalse:false});
});

app.get('/test/env/', (req,res) => {
  res.status(200).json(process.env);
});


const host = config.host || DEFAULT_HOST;
const port = config.port || DEFAULT_PORT;


app.listen(port, host);
console.log(`Running on http://${host}:${port}`);

module.exports = app; // for testing┌