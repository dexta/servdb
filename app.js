const http2 = require("http2");
const keys = require("./keys");

const DEFAULT_HOST = '0.0.0.0';
const DEFAULT_PORT = 8423;
// const DEFAULT_BASEDIR = '/var/lib/collectd/rrd'; // collectd default

const config = require('./config.js');
// const basedir = config.basedir || DEFAULT_BASEDIR;
const app = require('./webapp/index.js')(config);


app.get('*', (req,res,next) => {
  console.log("get URL-> ",req.url);
  return next();
});
app.post('*', (req,res,next) => {
  console.log("POST URL-> ",req.url);
  console.dir(req.body)
  return next();
});

// const sum = require('./rrdService/sum.js')(app,config);
// const simple = require('./rrdService/simple.js')(app,config);

const host = config.host || DEFAULT_HOST;
const port = config.port || DEFAULT_PORT;


const server = http2.createServer({
  key: keys.privateKey,
  cert: keys.certificate
}, app);

server.listen(port, host, () => {
  console.log(`rrd-server listening at http://${host}:${port}`);
});