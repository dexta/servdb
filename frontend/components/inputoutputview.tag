<inputoutputview show={visual}>
<div class="btn-toolbar justify-content-between" role="toolbar" aria-label="Toolbar option table view">
<!--   <div class="btn-group mr-2" role="group" aria-label="Second group">
    <button onclick={ toggleEditMode } type="button" class="btn {!edit.on ? 'btn-danger' : 'btn-success' }">
      Edit Mode
      <i hide={edit.on} class="fa fa-toggle-off"></i>
      <i show={edit.on} class="fa fa-toggle-on"></i>
    </button>
  </div>   -->
  <div class="btn-group" role="group" aria-label="Third group">
    <button class="btn btn-primary" onclick={ saveAllItems }>Save all</button>
  </div>
</div>

<form onsubmit={ setTails }>
  <!-- <hr> -->
  <div class="form-group row">
    <label class="col-sm-1 col-form-label" for="basekeyinputfield">Base</label>
    <div class="col-sm-8">
      <input type="text" class="form-control" id="basekeyinputfield" placeholder="service.hellodocker." list="quicklist"
              ref="tailsbasestring" value={fullTmpKey} onchange={ updateBaseString } onkeyup={ keyUpOnBaseString }>
        <datalist id="quicklist">
          <option value={sortstr} each={ sortstr, sortindex in  baseSortList}>
        </datalist>
    </div>
    <div class="col-sm-1">
      <!-- <button class="btn btn-success" id="setNewBase" onclick={ setNewBase }><i class="fa fa-umbrella"></i></button> -->
    </div>
    <div class="col-sm-2">
      <!-- <button class="btn btn-primary" onclick={ saveAllTailItems }>Save all</button> -->
    </div>
  </div>

 <table class="table">
  <thead>
    <tr>
      <th scope="col" style="width: 20%">Edit</th>
      <th scope="col" style="width: 50%">KEY</th>
      <th scope="col" style="width: 30%">VALUE</th>
    </tr>
  </thead>

  <tbody>
    <tr each={tail, index in tmpList.tails}>
      <td scope="row">
        <button onclick={ saveOne(index) } class="btn btn-danger">Save</button>
        <button onclick={ toggleEditLine(index)} class="btn btn-warning">Cancel</button>
      </td>
      <td scope="row">
        <input type="text" class="form-control" id="tailskeyinputfield_{index}" ref="tailskeystring_{index}" value="{fullTmpKey}{tail}" disabled>
        <small if={ errorMsgList[index] } class="form-text text-muted text-{errorMsgList[index].status}">
          Lr: {errorMsgList[index].msg}
        </small>
      </td>
      <td scope="row">
        <input type="text" class="form-control" id="tailsvalueinputfield_{index}" ref="tailsvaluestring_{index}" tabindex="{index +1}">
      </td>
    </tr>

  </tbody>
 </table>
</form>


<script>
let that = this;
this.visual = (opts.visual==='true')? true : false;
this.edit = {on:false,list:[]};
this.tmpList = { base: '', tails: [] };
this.fullTmpKey = '';
this.bases = [];
this.baseSortList = [];
this.errorMsgList = [];

riotux.subscribe(that, 'tmpList', function ( state, state_value ) {
  that.tmpList = riotux.getter('tmpList');
  that.update();
});

riotux.subscribe(that, 'bases', function ( state, state_value ) {
  that.bases = riotux.getter('bases');
  that.listAddSort('', 0);
  that.update();
});

riotux.subscribe(that, 'baseselect', (state, state_value) => {
  that.fullTmpKey = riotux.getter('baseselect').join('.').replace(/---select-all---/g,'').replace(/\.*---select-none---\.*/,'');
  that.fullTmpKey = that.fullTmpKey.replace(/\.\./gi,'.');
  if(that.fullTmpKey[that.fullTmpKey.length-1]!='.') {
    that.fullTmpKey += '.';
  }
  that.update();
});

this.listAddSort = (preset, level) => {
  if(!that.bases[level]||false) return;
  that.baseSortList = [];
  preset += (preset!="")? '.' : '';
  for(let n in that.bases[level]) {
    if(that.bases[level][n].indexOf('---')===-1) {
      that.baseSortList.push( preset + that.bases[level][n]);
    }
  }
};

this.sendNewOneToDB = (key,value,index) => {
  if(key===''||value==='') return;
  insertKeyValue(key,value, (reMsg) => {
    that.errorMsgList[index] = reMsg;
    that.update();
  });
};

this.saveOne = (indexInList) => {
  return () => {
    let key = that.refs["tailskeystring_"+indexInList].value;
    let value = that.refs["tailsvaluestring_"+indexInList].value;
    this.sendNewOneToDB(key,value,indexInList);
  };
};

this.toggleEditLine = (indexInList) => {
  return () => {
    console.log(indexInList);
  };
};

this.updateBaseString = () => {
  let baseString = that.refs.tailsbasestring.value;
  that.tmpList.base = baseString.replace(/\.$/,'');
  let baseSearchList = that.tmpList.base.split('.');

  that.listAddSort(that.tmpList.base, baseSearchList.length);
  
  that.fullTmpKey = (that.tmpList.base!='')? that.tmpList.base+'.' : '';
  that.update();
};


this.keyUpOnBaseString = () => {
  return 0;
  let baseString = that.refs.tailsbasestring.value;
  let baseList = baseString.split('.');
};

this.saveAllItems = () => {

};

</script>
</inputoutputview>