<keyvalueTable>
<h4 class="bg-{opts.color}">#{opts.number}</h4>
<hr>
<button class="btn btn-info" onclick={ showhide } id="showhide_search">Search</button>
<button class="btn btn-prinmary" onclick={ showhide } id="showhide_filter">Filter</button>
<button class="btn btn-danger" onclick={ showhide } id="showhide_shorter">Shorterkey</button>


<div class="pull-right">
  <button type="button" class="btn btn-outline-secondary dropdown-toggle dropdown-toggle-split"
          onclick={ toggleOptions } id="optionBtn_{opts.number}">
    <i class="fa fa-gear"></i>
  </button>
  <div class="dropdown-menu" id="showhide_options_{opts.number}">
    <table class="table table-hover">
      <tr each={name in optionsNames}>
        <td>
          { name }
        </td>
        <td>
          <button if={state[toLow(name)]||state[toLow(name)]===false} 
                  class="btn btn-sm pull-right { state[toLow(name)]? 'btn-success' : 'btn-danger' }"
                  onclick={ stateSwitch(toLow(name)) }>
            <i class="fa { state[toLow(name)]? 'fa-check-square' : 'fa-plus-square'  } "></i>
          </button>
        </td>
      </tr>
    </table>


<!--     <div class="dropdown-item" each={name in optionsNames}>
      { name }
      <span if={state[toLow(name)]||state[toLow(name)]===false} class="btn btn-sm { state[toLow(name)]? 'btn-success' : 'btn-danger' }">
        <i class="fa { state[toLow(name)]? 'fa-check-square' : 'fa-plus-square'  } "></i>
      </span>
    </div> -->

    <!-- <div class="dropdown-item" >History 
      <span class="btn btn-sm pull-right { state.history? 'btn-danger' : 'btn-success' }"><i class="fa fa-plus-square"></i></span>
    </div>
    <div class="dropdown-item" href="#">Another action
      <span class="btn btn-sm pull-right { state.history? 'btn-danger' : 'btn-success' }"><i class="fa fa-plus-square"></i></span>
    </div>
    <div class="dropdown-item" href="#">Something else here
      <span class="btn btn-sm pull-right { state.history? 'btn-danger' : 'btn-success' }"><i class="fa fa-plus-square"></i></span>
    </div>
    <div role="separator" class="dropdown-divider"></div>
    <div class="dropdown-item" href="#">Separated link
      <span class="btn btn-sm pull-right { state.history? 'btn-danger' : 'btn-success' }"><i class="fa fa-plus-square"></i></span>
    </div> -->
  </div>
</div>

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
  this.openclose = {filter:false,search:true,shorter:false,options:false};
  this.state = {filter:'service.',search:'service.%25',searchlimit:100,history:false,autoclose:true};
  this.optionsNames = ['History','AutoClose','-----------','Save','Load'];

  this.shorterList = ()=> {
    this.kvlist = this.rawList.map( (l)=> { return { key: l.key.replace(this.state.shorter,''), value: l.value } } );
  };

  this.filterList = () => {
    this.kvlist = this.rawList.filter( l => l.key.search(this.state.filter)>=0 );
  };

  this.getKVList = (strtoget) => {
    let soh = (!this.state.history)? 'search' : 'history'; 
    let urlString = `/${soh}/key/${this.state.searchlimit}/${strtoget}`;
    superagent('get',urlString).then( (res) => {
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
    if(this.state.autoclose) this.openclose.shorter = false;
    this.update();
  };

  this.setSearch = (e) => {
    e.preventDefault();
    this.state.search = this.refs.searchstring.value;
    this.state.searchlimit = this.refs.searchlimit.value;
    this.getKVList(this.state.search);
    if(this.state.autoclose) this.openclose.search = false;
    this.update();
  };

  this.setFilter = (e) => {
    e.preventDefault();
    this.state.filter = this.refs.filterstring.value;
    this.filterList();
    if(this.state.autoclose) this.openclose.filter = false;
    this.update();
  }

  this.showhide = (e) => {
    e.preventDefault();
    let clElem = e.srcElement.id.split('_')[1];
    this.openclose = {filter:false,search:false,shorter:false,options:false};
    this.openclose[clElem] = true;
    console.dir(clElem);
  };

  this.toggleOptions = (e) => {
    e.preventDefault();
    let opEle = document.getElementById('showhide_options_'+this.opts.number);
    // let newState = (opEle.style.display===''||opEle.style.display==='none')? 'block' : 'none';  
    let btEle = document.getElementById('optionBtn_'+this.opts.number);
    // console.dir(opEle);
    if(opEle.style.display===''||opEle.style.display==='none') {
      opEle.style.display = 'block';
      opEle.style.top = (btEle.offsetHeight+btEle.offsetTop)+"px";
      opEle.style.left = (btEle.offsetLeft-opEle.offsetWidth+btEle.offsetWidth) +"px";
    } else {
      opEle.style.display = 'none';
    }
    // console.dir(btEle);
  };

  this.toLow = (tolower) => {
    return tolower.toLowerCase();
  };

  this.stateSwitch = (stateName) => {
    return () => {
      this.state[stateName] = !(this.state[stateName]);
    }
  };

  this.countTheLen = () => {
    return that.kvlist.length;
  };

  this.onoroff = (tof) => {
    if(tof) {
      return '<span class="btn btn-success"><i class="fa fa-check-square"></i></span>';
    } else {
      return '<span class="btn btn-danger"><i class="fa fa-plus-square"></i></span>';
    }
  };


</script>

</keyvalueTable>