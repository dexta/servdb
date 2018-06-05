<envireditoptions>
<div class="form-group row">
  <button type="button" class="btn btn-secondary btn-lg btn-block" onclick={toggleOpen}>
    <span class="badge badge-secondary pull-left">
      <i show={open} class="fa fa-minus-square"></i>
      <i hide={open} class="fa fa-plus-square"></i>
    </span>
                Environment Edit Options
  </button>
</div>

<form show={open} onsubmit={ doSomeForm }>

 <div class="form-group row">
  <div class="col-4">
    <button class="btn btn-success btn-block" onclick={ toggleEditRowCol('rows') }>
      <span class="badge badge-success pull-left">
        <i show={search.editrows} class="fa fa-lg fa-unlock"></i>
        <i hide={search.editrows} class="fa fa-lg fa-lock"></i>
      </span>
                Rows
    </button>
  </div>
  <div class="col-8">
    <input type="text" class="form-control" aria-label="rows of search pattern groups" disabled value="{shortEditRow}">
  </div>
 </div>

 <div class="form-group row">
  <div class="col-4">
    <button class="btn btn-danger btn-block" onclick={ toggleEditRowCol('cols') }>
      <span class="badge badge-danger pull-left">
        <i show={search.editcols} class="fa fa-lg fa-unlock"></i>
        <i hide={search.editcols} class="fa fa-lg fa-lock"></i>
      </span>

                Cols
    </button>
  </div>
  <div class="col-8">
    <input type="text" class="form-control" aria-label="cols of search pattern groups" disabled value="{shortEditCol}">
  </div>
 </div>

 <div class="form-group row">
  <div class="col-8">
    
  </div>
  <div class="col-4">
    <button class="btn btn-danger btn-block" onclick={updateMatrix}>Update</button>
  </div>
 </div>

</form>

<script>
let that = this;
this.search = {editrows:false,editcols:false};
this.basematrix = {cols:[],rows:[]};

this.open = (opts.open==="true")? true : false;

riotux.subscribe(that, 'search', function ( state, state_value ) {
  that.search = riotux.getter('search');
  that.update();
});
riotux.subscribe(that, 'basematrix', function ( state, state_value ) {
  // console.log("update env opts tag ");
  // console.dir(state_value);
  that.shortEditRow = state_value.rows.join('.').replace(/\.\$/g,'');
  that.shortEditCol = state_value.cols.join('.').replace(/\.\$/g,'');
  that.basematrix = riotux.getter('basematrix');
  that.mergeRowCol();
  that.update();
});

this.mergeRowCol = () => {
  // console.log("row string "+that.shortEditRow);
  // console.log("col string "+that.shortEditCol);
  let merRowCol = [];
  for(let mr in that.basematrix.cols) {
    if(that.basematrix.rows[mr]||false) {
      merRowCol[mr] = that.basematrix.rows[mr];
    } else {
      merRowCol[mr] = that.basematrix.cols[mr]
    }
  } 
  // console.log("merged ro co ");
  // console.dir(merRowCol);
  return merRowCol.join('.')+"%";
};


this.toggleEditRowCol = (toEdit) => {
  return () => { 
    let thone = (toEdit==='cols')? 'editcols' : 'editrows';
    let tother = (toEdit==='rows')? 'editcols' : 'editrows';

    if( that.search[thone] ) {
      that.search[thone] = false;
    } else if(that.search[tother]) { 
      that.search[thone] = true;
      that.search[tother] = false;
    } else {
      that.search['edit'+toEdit] = !that.search['edit'+toEdit];  
    }
    riotux.action('search', 'setSearch', 'editcols', that.search.editcols);
    riotux.action('search', 'setSearch', 'editrows', that.search.editrows);
  };
};

this.shortTheRowCols = (listOf) => {
  return () => {
    // console.log(listOf);
    return listOf.join('.');
  };
};

this.updateMatrix = () => {
  riotux.action('baseListMatrix', 'getBaseList', store.state, that.mergeRowCol());
};


this.doSomeForm = (e) => {
  (e||false)? e.preventDefault(): false;
};

this.toggleOpen = () => {
  that.open = !that.open;
};
</script>
</envireditoptions>