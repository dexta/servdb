<inputoutputoptions>
<div class="form-group row">
  <button type="button" class="btn btn-info btn-lg btn-block" onclick={toggleOpen}>
    <span class="badge badge-info pull-left">
      <i show={open} class="fa fa-minus-square"></i>
      <i hide={open} class="fa fa-plus-square"></i>
    </span>
                Input Output Options
  </button>
</div>

<form show={open} onsubmit={doSomeForm}>
  <div class="form-group row">
    <div class="col-12">
      <input type="text" class="form-control" aria-label="Text input with checkbox" disabled value="{ baseselectpath }">
    </div>
  </div>
  <div class="form-group row">
    <div class="col-6">
      <button class="btn btn-block btn-danger">
        from File
      </button>
    </div>
    <div class="col-6">
      <button class="btn btn-block btn-danger" onclick={ importTextbox }>
        from Textbox
      </button>
    </div>
  </div>
  <div class="form-group row">
    <div class="form-group col-12">
      <label>Template text to import as keys</label>
      <textarea class="form-control" rows="7" cols="42" ref="textInputByTextbox">
        This is $\{APP_NAME} in $\{APP_ENV_STAGE} stage&#13;
        External Ports are =>&#13;
          - Webfrontedn $\{APP_PORTS_FRONTEND}&#13;
          - API $\{APP_PORTS_API}&#13;
          - Healthcheck $\{APP_PORTS_HEALTHCHECK}&#13;
        We will run the loglevel $\{APP_ENV_LOGLEVEL}&#13;
        Server that have to be accessable $\{APP_ENV_DBSERVER_NAME} &#13;
         - PORT $\{APP_ENV_DBSERVER_PORT}&#13;
         - ROOTPASS $\{APP_ENV_DBSERVER_ROOTPASS}&#13;
         - USER $\{APP_ENV_DBSERVER_USER}&#13;
         - DBNAME $\{APP_ENV_DBSERVER_DBNAME}&#13;
         - USERPASS $\{APP_ENV_DBSERVER_USERPASS}&#13;
      </textarea>
    </div>
  </div>
</form>

<script>

let that = this;

this.open = (opts.open==="true")? true : false;
this.tmpList = { base: '', tails: [] };
this.baseselectpath = '';

riotux.subscribe(that, 'tmpList', function ( state, state_value ) {
  that.tmpList = riotux.getter('tmpList');
  that.update();
});


riotux.subscribe(that, 'baseselect', (state, state_value) => {
  that.baseselectpath = riotux.getter('baseselect').join('.').replace(/---select-all---/g,'').replace(/\.*---select-none---\.*/,'').replace(/\.\./gi,'.');
  that.update();
});

this.importTextbox = () => {
  let text = that.refs.textInputByTextbox.value;
  console.log("text input "+text);

  let regexp = /\$\{([A-Z_]+)\}/g;
  let allVarz = text.match(regexp);
  console.log("output vars "+allVarz.length);
  console.dir(allVarz);

  let tailKeys = [];
  for(let a in allVarz) {
    let tStr = allVarz[a].replace("${","").replace("}","").toLowerCase();
    let tArr = tStr.split("_");
    // let last = tArr.pop();
    tailKeys.push( tArr.join(".") );
  }

  riotux.action('tmpList', 'setTempListTails', tailKeys);

  console.dir(tailKeys);
};


this.toggleOpen = () => {
  that.open = !that.open;
};
</script>
</inputoutputoptions>