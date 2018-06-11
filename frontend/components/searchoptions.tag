<searchoptions>
<div class="form-group row">  
  <button type="button" class="btn btn-primary btn-lg btn-block" onclick={toggleOpen}>
    <span class="badge badge-primary pull-left">
      <i show={open} class="fa fa-minus-square"></i>
      <i hide={open} class="fa fa-plus-square"></i>
    </span>
                Search
  </button>
</div>

<form onsubmit={ updateSearch } show={open}>
  <div class="form-group row">
    <div class="col-6">
      <button type="button" class="btn btn-info btn-block" onclick={toggleBtnCheck('baseon')}>
        <span class="badge badge-info pull-left">
          <i show={search.baseon} class="fa fa-check-square fa-2x"></i>
          <i hide={search.baseon} class="fa fa-square fa-2x"></i>
        </span>
                    Add base
      </button>
    </div>

    <div class="col-6">
      <button type="button" class="btn btn-success btn-block" onclick={toggleBtnCheck('cutbase')}>
        <span class="badge badge-success pull-left">
          <i show={search.cutbase} class="fa fa-check-square fa-2x"></i>
          <i hide={search.cutbase} class="fa fa-square fa-2x"></i>
        </span>
                    Cut base
      </button>
    </div>
  </div>

  <div class="form-group row">
    <div class="col-12">
      <input type="text" class="form-control" aria-label="Text input with checkbox" disabled value="{ baseselectpath }">
    </div>
  </div>

  <div class="form-group row">
    <div class="col-2">
      <div class="input-group-text" click={ updateSearch }>Text</i></div>
    </div>
    <div class="col-10">
      <input type="text" class="form-control" id="searchinputfield" placeholder="service." ref="searchstring" value={ search.text }>
    </div>
  </div>
   
  <div class="form-group row">
    <div class="col-2">
      <div class="input-group-text" click={ updateSearch }>Limit</div>
    </div>

    <div class="col-10"> 
      <input type="number" class="form-control" id="searchlimitinputfield" ref="searchlimit" value={ search.limit }>
    </div>
  </div>

  <div class="form-group row">
    <div class="col-8">
      <label>Count: { kvlist.length }</label>
    </div>
    <div class="col-4">
      <button class="btn btn-danger pull-right">send Search</button>
    </div>
  </div>
</form>
<script>

let that = this;
this.open = (opts.open==="true")? true : false;
this.search = {limit:10,base:'',baseon:false,cutbase:false};
this.kvlist = [];
this.baseselectpath = '';

riotux.subscribe(that, 'search', (state, state_value) => {
  that.update();
});

riotux.subscribe(that, 'kvlist', (state, state_value) => {
  that.update();
});

riotux.subscribe(that, 'baseselect', (state, state_value) => {
  that.baseselectpath = riotux.getter('baseselect').join('.').replace(/---select-all---/g,'%').replace(/\.*---select-none---\.*/,'');
  that.update();
});

this.on('update', () => {
  that.search = riotux.getter('search');
  that.kvlist = riotux.getter('kvlist');
});

this.on('mount', () => { that.update();});

this.on('unmount', () => {
  riotux.unsubscribe(this);
});

this.updateSearch = (e) => {
  e.preventDefault();
  let text = this.refs.searchstring.value;
  let limit = this.refs.searchlimit.value;

  if(text===''||limit==='') return;
  riotux.action('search', 'setSearch', 'text', text);
  riotux.action('search', 'setSearch', 'limit', limit);
  riotux.action('search', 'setSearch', 'base', that.baseselectpath);
  riotux.action('search', 'setSearch', 'baseon', that.search.baseon);
  riotux.action('search', 'setSearch', 'cutbase', that.search.cutbase);

  riotux.action('kvlist', 'getList', store.state);
}

this.toggleOpen = () => {
  that.open = !that.open;
};


this.toggleBtnCheck = (varName) => {
  return () => {
    that.search[varName] = !that.search[varName];
  };
};
</script>
</searchoptions>