<matrixview show={visual}>
  <table class="table">
    <thead>
      <tr>
        <th>x/y</th>
        <th scope="col" each={ colth, chindex in baseSortTable.cols }>{colth}</th>
      </tr>
    </thead>
    <tbody>

<!-- 
                    baseSortTable.rows[tmpO.row].lines[tmpO.col]
       -->


      <!-- <tr each={ row , rcindex in templateList }> -->
      <tr each={ lineOf , rowinx in baseSortTable.rows }>

        <td>{rowinx}</td>
        <td each={ colname, colinx in baseSortTable.cols}>

          <div if={lineOf.lines[colname]} class="form-group row">

            <div class="col-8">
              <input type="text" class="form-control" disabled
                      id="{lineOf.lines[colname].key}" value="{ lineOf.lines[colname].col }">
            </div>

            <div class="col-2">

              <div class="btn-group" role="group" aria-label="Save or Cancel">
              <button class="btn btn-danger" hide={lineOf.lines[colname].disabled} onclick={ saveEntry(lineOf.lines[colname]) }>
                <i class="fa fa-save"></i>
                <!-- <i class="fa fa-edit"></i> -->
              </button>
              <button class="btn btn-danger" show={lineOf.lines[colname].disabled} onclick={ editEntry(lineOf.lines[colname]) }>
                <!-- <i class="fa fa-save"></i> -->
                <i class="fa fa-edit"></i>
              </button>
              <button class="btn btn-success" hide={lineOf.lines[colname].disabled}>
                <i class="fa fa-undo"></i>
              </button>
              <button class="btn btn-success" show={lineOf.lines[colname].disabled}>
                <i class="fa fa-copy"></i>
              </button>

            </div>

          </div>

        </td>
        
      </tr>
    </tbody>

  </table>
<script>
let that = this;
this.visual = (opts.visual==='true')? true : false;

this.baseListMatrix = [];

this.baseSortTable = {rows:{},cols:[]};
this.basematrix = {cols:['intern','extern','wsport','hostlisten'],rows:['testing','stage','prelive','live']};
this.templateList = [];

riotux.subscribe(that, 'basematrix', function ( state, state_value ) {
  // console.log("update env opts tag ");
  // console.dir(state_value);
  // that.shortEditRow = state_value.rows.join('.').replace(/\.\$/g,'');
  // that.shortEditCol = state_value.cols.join('.').replace(/\.\$/g,'');
  that.basematrix = riotux.getter('basematrix');

  // that.mergeRowCol();
  that.update();
});


riotux.subscribe(that, 'baseListMatrix', function ( state, state_value ) {
  that.baseListMatrix = riotux.getter('baseListMatrix');
  that.bigCopyMatrix(state_value);
  that.update();
});

this.bigCopyMatrix = (toSmallMatrix) => {
  let higherOrderMatrix = [];
  that.baseSortTable.cols = [];
  that.baseSortTable.rows = {};

  for(let h in toSmallMatrix) {
    let tmpO = {key:toSmallMatrix[h].key,col:'',row:'',value:toSmallMatrix[h].value,disabled:true};
    let kList = tmpO.key.split('.');
    tmpO.col = kList.pop();
    let rowCutList = that.basematrix.rows;
    let newKey = '';
    for(k in kList) {
      if(kList[k]!=rowCutList[k]) {
        newKey += kList[k] + '.';
      }
    }
    tmpO.row = newKey.replace(/\.$/,'');
    // tmpO.col = tmpO.key.split('.').slice(0,n.key.split('.').length-1).join('.');
    higherOrderMatrix.push(tmpO);

    if(!(that.baseSortTable.rows[tmpO.row]||false)) {
      that.baseSortTable.rows[tmpO.row] = {lines:{}};
    }

    that.baseSortTable.rows[tmpO.row].lines[tmpO.col] = tmpO;

    if( that.baseSortTable.cols.indexOf( tmpO.col ) ===-1 ) {
      that.baseSortTable.cols.push(tmpO.col)
    }

  }
  // console.log('new lower order funktion');

  // console.dir(that.baseSortTable.cols);
  // console.dir(that.baseSortTable.rows);

  // console.dir(higherOrderMatrix);
  // for(let h in higherOrderMatrix) {
  //   if(!(that.baseSortTable.rows[higherOrderMatrix[h].row]||false)) that.baseSortTable.rows[higherOrderMatrix[h].row] = {lines:[]};
    
  //   that.baseSortTable.rows[higherOrderMatrix[h].row].lines.push(higherOrderMatrix[h]);
    
  //   if( that.baseSortTable.cols.indexOf( higherOrderMatrix[h].col ) ===-1 ) {
  //     that.baseSortTable.cols.push(higherOrderMatrix[h].col)
  //   }
  // }



  // that.templateList = [];

  // for(let s in that.baseSortTable.rows) {
  //   let row = s;
  //   let key = that.baseSortTable.rows[s].lines[0].key;
  //   let cols = {};
  //   for(let l in that.baseSortTable.rows[s].lines) {
  //     cols[that.baseSortTable.rows[s].lines[l].col] = that.baseSortTable.rows[s].lines[l].value;
  //   }
  //   that.templateList.push({row,key,cols});
  // }

  // console.log("template like List count: "+that.templateList.length);
  // console.dir(that.templateList);

};

this.subEditEntry = (rowK) => {
  console.log("full rowcol "+rowK.key);
  console.dir(rowK);
  let rowcol = document.getElementById(rowK.key);
  rowcol.disabled = false;
  that.baseSortTable.rows[rowK.row].lines[rowK.col].disabled = false;
  console.dir(rowcol);
};


this.editEntry = (rowK) => {
  return () => { 
    // that.subEditEntry(rowKey,colKey);
    let inputElement = document.getElementById(rowK.key);
    inputElement.disabled = false;
    rowK.disabled = false;
  };
};

this.saveEntry = (rowK) => {
  return () => {
    // console.log("save Entry ");
    // console.dir(rowK);
    let inputElement = document.getElementById(rowK.key);
    inputElement.disabled = true;
    console.log("newValue "+inputElement.value);
    // insertKeyValue(rowK.key,inputElement.value);
  };
};

</script>
</matrixview>