<baseoptions>
<div class="form-group row">
  <button type="button" class="btn btn-info btn-lg btn-block" onclick={toggleOpen}>
    <span class="badge badge-info pull-left">
      <i show={open} class="fa fa-minus-square"></i>
      <i hide={open} class="fa fa-plus-square"></i>
    </span>
                Baseplate
  </button>
</div>

<form show={open} onsubmit={doSomeForm}>
  <div class="form-group row">
    <div class="col-4">
      <input type="number" class="form-control" aria-describedby="how many level deep" 
                value="{basedepth}" onchange={updateBasedepth} ref="basedepthvalue">
    </div>
  </div>

  <div class="form-group row" each={ base, index in bases }>
    <div class="col-2">
      <button class="btn btn-block { (search.editrows)? 'btn-success' : (search.editcols)? 'btn-danger' : 'btn-info' }"
              onclick={ togglerowscols } id="matrixSel_{index}">
        <virtual if={!(search.editrows||search.editcols)}>
          {index+1}
        </virtual>
        <virtual if={(search.editrows||search.editcols)}>
          <i class="fa fa-edit"></i>
        </virtual>
      </button>
    </div>
    <div class="col-10">
      <select class="form-control FormControlSelect" id="formControlSelect_{index}" onchange={ updateSelect(index) }>
        <option each={ item, count in base } selected={item===select[index]}>{ item }</option>
      </select>
    </div>
  </div>
</form>

<script>

let that = this;
this.search = {editrows:false,editcols:false};

this.open = (opts.open==="true")? true : false;

this.bases = [];
this.select = [];
this.basedepth = 4;
this.basematrix = {cols:[],rows:[]};

riotux.subscribe(that, 'bases', function ( state, state_value ) {
  that.bases = riotux.getter('bases');
  that.update();
});

riotux.subscribe(that, 'basedepth', function ( state, state_value ) {
  that.basedepth = riotux.getter('basedepth');
  that.update();
});

riotux.subscribe(that, 'basematrix', function ( state, state_value ) {
  that.basematrix = riotux.getter('basematrix');
  that.update();
});

riotux.subscribe(that, 'baseselect', function(state, state_value) {
  that.select = riotux.getter('baseselect');
  that.update();
});

riotux.subscribe(that, 'search', function ( state, state_value ) {
  that.search = riotux.getter('search');
  that.update();
});


this.handleUpdateSelect = (indexNo) => {
  
  // let sek = document.querySelector('#exampleFormControlSelect_'+indexNo);
  // riotux.action('baseselect', 'setBaseSelect', indexNo, sek.value);

  let selAll = document.querySelectorAll('.FormControlSelect');
  
  let newOptVal = [];
  for(let s in selAll) {
    if(selAll[s]===undefined||selAll[s].selectedIndex===undefined) continue;
    newOptVal.push(selAll[s].options[selAll[s].selectedIndex].innerText);
  }
  
  // console.log("newOptVal "+newOptVal);
  riotux.action('baseselect', 'setBaseSelect', newOptVal);
  // riotux.action('bases', 'getBases', store.state);
};

this.updateSelect = (indexNo) => {
  return () => that.handleUpdateSelect(indexNo);
};


this.handleColRowAdding = (colrows, intoindex, newValue) => {
  let oppo = (colrows==='cols')? 'rows' : 'cols';
  // new

  for(let n=0;n<intoindex;n++) {
    if(!(that.basematrix[colrows][n]||false)) that.basematrix[colrows][n]='%';
    if(!(that.basematrix[oppo][n]||false)) that.basematrix[oppo][n]='%';
  }

  if(that.basematrix[oppo][intoindex]===newValue) {
    that.basematrix[oppo][intoindex]='%';
  }

  if(newValue.search('none')!=-1) {
    that.basematrix[colrows][intoindex] = '$';
  } else if(newValue.search('all')!=-1) {
    that.basematrix[colrows][intoindex] = '%';
  } else {
    that.basematrix[colrows][intoindex] = newValue;  
  }
  
  that.storeBasematrix();
  // end new
};

this.storeBasematrix = () => {
  riotux.action('basematrix', 'setBasematrix', that.basematrix);
};

this.updateBasedepth = () => {
  riotux.action('basedepth', 'setBaseDepth', this.refs.basedepthvalue.value);
  riotux.action('bases', 'getBases', store.state);
};

this.togglerowscols = (e) => {
  let btid = (e.target.id||false)? e.target.id.split("_")[1] : (e.target.parentElement.id||false)? e.target.parentElement.id.split("_")[1] : null;
  let selEl = document.querySelector('#formControlSelect_'+btid);  
  if(btid===null) return;
  let indexID = parseInt(btid);
  let selName = selEl.options[selEl.selectedIndex].innerText;
  // console.log("btn id "+indexID);
  // console.log("select Name "+selName);
  if(that.search.editcols) {
    // that.basematrix.cols[indexID] = selName;
    // that.storeBasematrix();
    that.handleColRowAdding('cols', indexID, selName);
  } else if(that.search.editrows) {
    // that.basematrix.rows[indexID] = selName;
    // that.storeBasematrix();
    that.handleColRowAdding('rows', indexID, selName);
  }
  // console.dir(that.basematrix);
};

this.doSomeForm = (e) => {
  (e||false)? e.preventDefault(): false;
};

this.toggleOpen = () => {
  that.open = !that.open;
};
</script>

</baseoptions>