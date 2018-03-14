const express = require('express');
const config = require('./config.js');

const DEFAULT_HOST = '0.0.0.0';
const DEFAULT_PORT = 8080;

const os = require("os");
const hostname = os.hostname();
const ipinterface = os.networkInterfaces();
const hostip = (ipinterface.eth0||false)? ipinterface.eth0[0].address : '0.0.0.0';

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

retrysql();

// rest routes api

app.get('/insert/simple/:key/:value', async (req, res)=> {
  let data = {key:req.params.key,value:req.params.value};
  let selCode = 500;
  let selReturn = {good:true};

  let reint = await sql.insertOne(data);
  if(reint) {
    selCode = 200;
    selReturn = reint;
  } else {
    selCode = 404;
    selReturn = {err:true,data:reint};
  }
  res.status(selCode).json(selReturn);
});

app.get('/search/key/:key', async (req, res) => {
  let searchResulutes = await sql.searchByKey(req.params.key);
  res.status(200).json(searchResulutes);
});

app.get('/search/value/:value', async (req, res) => {
  let searchResulutes = await sql.searchByValue(req.params.value);
  res.status(200).json(searchResulutes);
}); 

// old stuff
app.get('/api/get/all', (req,res) => {
  let allQuery = 'SELECT * FROM titletext ORDER BY id DESC LIMIT 10;';
  sql.query(allQuery, (err, rows, fields) => {
    if(err) {
      res.status(200).json(err);
    } else {
      res.status(200).json(rows);
    }
  });
  // res.status(200).json([{title:'hello world',text:'some text not sure how many char should be en'}]);
});

app.post('/api/get/all', (req,res) => {
  res.status(200).json([{title:'hello world',text:'some text not sure how many char should be en'}]);
});

app.post('/api/post', (req,res) => {
  sql.insertData(req.body, (err, rows, fields) => {
    if(err) {
      res.status(404).json(err);
    } else {
      res.status(200).json(rows);
    }
  });
});

// rest routes test
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