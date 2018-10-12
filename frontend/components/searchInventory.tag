<searchInventory>
<h1>search inventory</h1>
<form onsubmit={ searchServer }>
  <hr>
  <div class="form-group row">
    <label class="col-sm-2 col-form-label" for="singlekeyinputfield">Server</label>
    <div class="col-sm-10">
      <input type="text" class="form-control" id="singlekeyinputfield" placeholder="lxtestmuster" ref="servernametosearch">
    </div>
  </div>

  <div class="form-group row">
    </div>
    <div class="col-sm-2">
      <button class="btn btn-danger mb-2">SEARCH</button>
    </div>
  </div>
</form>
<script>
let that = this;
this.searchServer = (e) => {
  e.preventDefault();
  let searchStr = this.refs.servernametosearch.value;
  
  if(searchStr==='') return;

  console.log(searchStr);

  let getURL = `/inv/${searchStr}`;
  // superagent('get',getURL).then( (res) => {
  //   that.lastSaveReturn = (res.body.msg||false)? res.body : {msg:'null',status:'danger'} ;
  //   that.update();
  // });
	// riotux.action('baseselect', 'setBaseSelect', newOptVal);
	riotux.action('invAllList', 'addInvItem', {
		servername: 'lxtest',
		'network.eth0': '192.168.1.1',
		'network.eth1': '8.8.8.8'
	});
	riotux.action('invViewList','setActiveItem',searchStr);
};
</script>

</searchInventory>