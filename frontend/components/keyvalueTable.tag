<keyvalueTable>
<button class="btn btn-prinmary" onclick={ showhide_filter() }>Filter</button>
<button class="btn btn-info">Search</button>
<!-- <button class="btn btn-danger">Edit</button> -->


<form if={openclose.filter} onsubmit={ setFilter }>
  <hr>
  <div class="col-auto">
    <label class="sr-only" for="filterinputfield">Filter</label>
    <div class="input-group mb-2">
      <div class="input-group-prepend">
        <div class="input-group-text" click={ setFilter }><i class="fa fa-filter"></i></div>
      </div>
      <input type="text" class="form-control" id="filterinputfield" placeholder="service." ref="filterstring">
    </div>
  </div>
<!-- 
  <div class="col-auto">
    <button class="btn btn-primary mb-2">Set Filter</button>
  </div> -->
  </div>
</form>

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
  this.openclose = {filter:false,search:false,edit:false};
  this.state = {filter:'service.',search:'',edit:{}};

  this.filterList = ()=> {
    this.kvlist = this.kvlist.map( (l)=> { return { key: l.key.replace(this.state.filter,''), value: l.value } } );
  };

  superagent('get','/search/key/service.%25').then( (res) => {
  	that.kvlist = res.body;
  	that.update();
  });

  this.showhide_filter = () => {
    return () => {
      console.log('click show/hide filter');
      this.openclose.filter = !this.openclose.filter;  
    };
  };

  this.setFilter = (e) => {
    e.preventDefault();
    console.log("setFilter "+this.refs.filterstring.value);
    this.state.filter = this.refs.filterstring.value;
    this.filterList();
    console.dir(this.kvlist);
    this.openclose.filter = false;
  };

  this.countTheLen = () => {
    return that.kvlist.length;
  }




</script>

</keyvalueTable>