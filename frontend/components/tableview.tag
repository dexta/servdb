<tableview show={visual}>
<div class="btn-toolbar justify-content-between" role="toolbar" aria-label="Toolbar option table view">
  <div class="btn-group mr-2" role="group" aria-label="Second group">
    <button onclick={ toggleEditMode } type="button" class="btn {!edit.on ? 'btn-danger' : 'btn-success' }">
      Edit Mode
      <i hide={edit.on} class="fa fa-toggle-off"></i>
      <i show={edit.on} class="fa fa-toggle-on"></i>
    </button>
<!--     <button if={!edit.on} onclick={ toggleEditMode } type="button" class="btn btn-danger"> </button>
    <button if={edit.on} onclick={ toggleEditMode } type="button" class="btn btn-success"></button> -->
  </div>  
  <div class="btn-group mr-2" role="group" aria-label="First group">
    <button type="button" class="btn btn-secondary">Order Key</button>
    <button type="button" class="btn btn-secondary"><i class="fa fa-sort-up"></i></button>
    <button type="button" class="btn btn-secondary">Order Value</button>
    <button type="button" class="btn btn-secondary"><i class="fa fa-sort-up"></i></button>
  </div>
  <div class="btn-group" role="group" aria-label="Third group">
    <button type="button" class="btn btn-secondary"><i class="fa fa-sort-down"></i></button>
  </div>
</div>

<table class="table">
  <thead>
    <tr>
      <th>
        <button hide={edit.on} onclick={ selectAll() } class="btn btn-primary">
          <i class="fa fa-check-square"></i>
          <!-- Select All -->
        </button>
        <button hide={edit.on} onclick={ selectAll('swap') } class="btn btn-warning">
          <i class="fa fa-arrows-h"></i>
        </button>
        <button show={edit.on} onclick={ saveAll } class="btn btn-danger">
          Save All
        </button>
      </th>
      <th scope="col">KEY</th>
      <th scope="col">VALUE</th>
    </tr>
  </thead>
  <tbody each={lineobj, index in view}>
    <tr if={!edit.list[index] || !edit.on}>
      <th scope="row">
        <button if={!edit.list[index]} onclick={ toggleEditLine(index) } type="button" class="btn btn-danger"> <i class="fa fa-toggle-off"></i></button>
        <button if={edit.list[index]} onclick={ toggleEditLine(index) } type="button" class="btn btn-success"><i class="fa fa-toggle-on"></i></button>
        <span class="pull-right">{ index+1 }</span>
      </th>
      <td>{ cutout(lineobj.key) }</td>
      <td>{ lineobj.value }</td>
    </tr>
    <tr if={edit.list[index] && edit.on}>
      <th scope="row">
        <button onclick={ saveOne(index) } class="btn btn-danger">Save</button>
        <button onclick={ toggleEditLine(index)} class="btn btn-warning">Cancel</button>
      </th>
      <td>
       <!-- { lineobj.key } -->
        <div class="input-group">
          <div class="input-group-prepend">
            <div class="input-group-text">Key</i></div>
          </div>
          <input type="text" class="form-control" id="searchinputfield" placeholder="service." ref="keyEdit_{index}" value={ lineobj.key }>
        </div>
      </td>
      <td>
        <!-- { lineobj.value } -->
        <div class="input-group">
          <div class="input-group-prepend">
            <div class="input-group-text">Key</i></div>
          </div>
          <input type="text" class="form-control" id="searchinputfield" placeholder="service." ref="valueEdit_{index}" value={ lineobj.value }>
        </div>

      </td>

    </tr>
  </tbody>
</table>

<script>
let that = this;
this.visual = (opts.visual==='true')? true : false;
this.kvlist = [];
this.search = {};
this.edit = {on:false,list:[]};
this.view = [];


riotux.subscribe(that, 'kvlist', function( state, state_value ) {
  // the state changed, than update the component
  that.kvlist = riotux.getter('kvlist'); // recieves the new state value
  that.search = riotux.getter('search');
  that.view = [];
  that.edit.list = [];
  for(let i in that.kvlist) {
    that.view[i] = JSON.parse( JSON.stringify(that.kvlist[i]) );
    that.edit.list[i] = false;
  }
  that.update();
});

this.shortout = (stringToShort) => {
  if(that.search.cutbase||false) {
    // let wildcards = that.search.base.replace(/\./g,'\\\.').replace(/%/g,'.*');
    // console.log("wildcards "+wildcards);
    // let whatHe = stringToShort.replace( new RegExp('/'+wildcards+'/g'),'');
    // console.log("what the hell-> "+whatHe);
    return stringToShort.replace( that.search.base,'');;
  } else {
    return stringToShort;
  }  
};

this.cutout = (stringTo) => {
  return this.shortout(stringTo);
};

this.on('update', function() {
  // console.dir(this.search);
});

this.on('unmount', function() {
  riotux.unsubscribe(this); // Unsubscribe the observe states
});


this.toggleEditMode = () => {
  if(this.edit.on) {
    this.edit.on = false;
  } else {
    this.edit.on = true;
  }
  this.update();
};

this.toggleEditLine = (indexNo) => {
  return () => {
    that.edit.list[indexNo] = !that.edit.list[indexNo];
    console.log("toggleEditLine "+indexNo);
  };
};

this.selectAll = (option) => {
  return () => {
    for(let s in that.edit.list) {
      if(option==='swap') {
        that.edit.list[s] = !that.edit.list[s];
      } else {
        that.edit.list[s] = true;  
      }
      
    }
    console.dir(that.edit.list);
  }
};

this.saveOne = (indexNo) => {
  return () => {
    console.log("save Value "+this.refs['keyEdit_'+indexNo].value+" __ "+this.refs['valueEdit_'+indexNo].value);
  };
};

this.saveAll = () => {
  for(let a in that.edit.list) {
    if(that.edit.list[a]) {
      console.log("save All  "+a+": "+that.kvlist[a].key+" __ "+that.kvlist[a].value);
      console.log("change Value "+this.refs['keyEdit_'+a].value+" __ "+this.refs['valueEdit_'+a].value);
    }
  }
};


</script>

</tableview>