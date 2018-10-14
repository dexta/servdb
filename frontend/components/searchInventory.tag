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

<ul class="list-group">
  <li class="list-group-item d-flex justify-content-between align-items-center" each={ entry,index in invAllList}>
    <button class="btn btn-primary" onclick={ selectItemView } data-itemIndex="{index}">
      <i class="fa fa-get-pocket"></i>
    </button>
    {entry.searchEntry}
    
    <span class="badge badge-primary badge-pill">
      <i class="fa fa-close" onclick={ removeItemFromAll } data-itemIndex="{index}"></i>
    </span>
  </li>
</ul>
<script>
let that = this;
this.invAllList = {};

riotux.subscribe(that, 'invViewList', function( state, state_value ) {
  that.invAllList = riotux.getter('invAllList');
  // console.dir(that.invAllList);
  that.update();
});

this.searchServer = (e) => {
  e.preventDefault();
  searchItem(this.refs.servernametosearch.value);
};


this.removeItemFromAll = (e) => {
  console.dir(e.target.dataset.itemindex);
  riotux.action('deleteInvItem',e.target.dataset.itemindex)
}

this.selectItemView = (e) => {
  let setItem = (e.target.dataset.itemindex||false)? e.target.dataset.itemindex : e.target.parentNode.dataset.itemindex
  // console.dir(e.target);
  // console.log(setItem);
  riotux.action('invViewList','setActiveItem',setItem);
};

</script>

</searchInventory>