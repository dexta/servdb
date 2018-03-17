<keyvalueTable>
<button class="btn btn-info" onclick={ showhide } id="showhide_search">Search</button>
<button class="btn btn-prinmary" onclick={ showhide } id="showhide_filter">Filter</button>
<button class="btn btn-danger" onclick={ showhide } id="showhide_shorter">Shorterkey</button>

<hr>

<form if={openclose.shorter} onsubmit={ setShorter }>
  <div class="col-auto">
    <label class="sr-only" for="shorterinputfield">Shorter</label>
    <div class="input-group mb-2">
      <div class="input-group-prepend">
        <div class="input-group-text" click={ setShorter }><i class="fa fa-cut"></i></div>
      </div>
      <input type="text" class="form-control" id="shorterinputfield" placeholder="service." ref="shorterstring" value={ state.shorter }>
    </div>
  </div>
</form>

<form if={openclose.filter} onsubmit={ setFilter }>
  <div class="col-auto">
    <label class="sr-only" for="filterinputfield">filter</label>
    <div class="input-group mb-2">
      <div class="input-group-prepend">
        <div class="input-group-text" click={ setFilter }><i class="fa fa-filter"></i></div>
      </div>
      <input type="text" class="form-control" id="filterinputfield" placeholder="service." ref="filterstring" value={ state.filter }>
    </div>
  </div>
</form>


<form if={openclose.search} onsubmit={ setSearch }>
  <div class="form-inline">
    <label class="sr-only" for="filterinputfield">search</label>
    <div class="input-group col-sm-8">
      <div class="input-group-prepend">
        <div class="input-group-text" click={ setSearch }><i class="fa fa-search"></i></div>
      </div>
      <input type="text" class="form-control" id="searchinputfield" placeholder="service." ref="searchstring" value={ state.search }>
    </div>
    <div class="input-group col-sm-4">
      <div class="input-group-prepend">
        <div class="input-group-text"><i class="fa fa-cloud-upload"></i></div>
      </div>
      <input type="number" class="form-control" id="searchlimitinputfield" placeholder="service." ref="searchlimit" value={ state.searchlimit }>
    </div>
  </div>
</form>

<hr>

<table class="table">
  <caption>Count of key value { countTheLen() }</caption>
  <thead>
    <tr>
      <th scope="col">#</th>
      <th scope="col">KEY</th>
      <th scope="col">VALUE</th>
    </tr>
  </thead>
  <tbody each={lineobj, index in kvlist}>
    <tr>
      <th scope="row">{ index+1 }</th>
      <td>{ lineobj.key }</td>
      <td>{ lineobj.value }</td>
    </tr>
  </tbody>
</table>

<script>
  let that = this;
  this.kvlist = [];
  this.rawList = [];
  this.openclose = {filter:false,search:true,shorter:false};
  this.state = {filter:'service.',search:'service.%25',searchlimit:100};

  this.shorterList = ()=> {
    this.kvlist = this.rawList.map( (l)=> { return { key: l.key.replace(this.state.shorter,''), value: l.value } } );
  };

  this.filterList = () => {
    this.kvlist = this.rawList.filter( l => l.key.search(this.state.filter)>=0 );
  };

  this.getKVList = (strtoget) => {
    superagent('get',"/search/key/"+strtoget).then( (res) => {
    	that.kvlist = res.body;
      that.rawList = res.body;
    	that.update();
    });
  };

  this.getKVList(this.state.search);

  this.setShorter = (e) => {
    e.preventDefault();
    console.log("setShorter "+this.refs.shorterstring.value);
    this.state.shorter = this.refs.shorterstring.value;
    this.shorterList();
    console.dir(this.kvlist);
    this.openclose.shorter = false;
    this.update();
  };

  this.setSearch = (e) => {
    e.preventDefault();
    this.state.search = this.refs.searchstring.value;
    this.getKVList(this.state.search);
    this.openclose.search = false;
    this.update();
  };

  this.setFilter = (e) => {
    e.preventDefault();
    this.state.filter = this.refs.filterstring.value;
    this.filterList();
    this.openclose.filter = false;
    this.update();
  }

  this.showhide = (e) => {
    e.preventDefault();
    let clElem = e.srcElement.id.split('_')[1];
    this.openclose = {filter:false,search:false,shorter:false};
    this.openclose[clElem] = true;
    console.dir(clElem);
  };

  this.countTheLen = () => {
    return that.kvlist.length;
  }




</script>

</keyvalueTable>