module.exports = (app,sql,config) => {
// --
// ----
// ------
// export as objcet create new befor use seriously
// the module.exports level is -1 of indentation
// so lets start with 0 as we like it ;)
// ------
// ----
// --

const generateEnvVariables = (jobj,options) => {
  let base = options.base||'';
  let tail = options.tail||'';
  if(base===''&&tail==='') return 0;
  
  let outStr = '';
  for(let l in jobj) {
    let key = jobj[l].key.replace(base+'\.','').replace(/\./g,'_').toUpperCase();
    let val = jobj[l].value;
    if(options.export||false) {
      outStr += 'export ';
    }
    outStr += `${key}=${val}\n`;
  }
  return outStr;
};


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

app.get('/search/:keyval/:limit/:value', async (req, res) => {
  let opts = {};
  opts.limit = req.params.limit;
  opts.by = req.params.keyval;
  opts.search = req.params.value;
  let searchResulutes = await sql.searchKeyValLimit(opts);

  res.status(200).json(searchResulutes);
});

app.get('/onevalue/:key', async (req, res) => {
  let theone = await sql.getOneValue(req.params.key);
  res.status(200).send(theone);
});


app.get('/env/:base/:key', async (req, res) => {
  let fullKey = `${req.params.base}.${req.params.key}`;
  let searchResulutes = await sql.searchByKey(fullKey);

  res.status(200).send(generateEnvVariables(searchResulutes,{base:req.params.base,tail:req.params.key,export:true}));
});
// --
// ----
// ------
// end of module.exports nothing can stand after that
// ------
// ----
// --
};