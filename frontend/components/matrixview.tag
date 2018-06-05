<matrixview show={visual}>
  <table class="table">
    <thead>
      <tr>
        <th>x/y</th>
        <th scope="col" each={ colth, chindex in baseSortTable.cols }>{colth}</th>
      </tr>
    </thead>
    <tbody>
      <tr each={ row , rcindex in templateList }>
        <td>{row.row}</td>
        <td each={ cols, colinx in baseSortTable.cols}>
          <div if={row.cols[cols]} class="form-group row">
            <div class="col-8">
              <input type="text" class="form-control" aria-label="{ row.key }" disabled value="{ row.cols[cols] }">
            </div>
            <div class="col-2">
              <div class="btn-group" role="group" aria-label="Save or Cancel">
              <button class="btn btn-danger">
                <i class="fa fa-save"></i>
              </button>
              <button class="btn btn-success">
                <i class="fa fa-undo"></i>
              </button>
            </div>
          </div>
          <!-- <td each={ oneline, itemindex in lines}>{oneline.col} - {oneline.value}</td> -->
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

  // let higherOrderMatrix = that.baseListMatrix
  //  .map(
  //   (o) => { 
  //     return {
  //       key:o.key.replace("service.hellodocker.",""),
  //       value:o.value} 
  //     })
  //  .map(
  //   (n) => { 
  //     return {
  //       col:n.key.split('.')[n.key.split('.').length-1],
  //       row:n.key.split('.').slice(0,n.key.split('.').length-1).join('.'),
  //       key:n.key,
  //       value:n.value 
  //     } 
  //   });

  let higherOrderMatrix = [];
  for(let h in toSmallMatrix) {
    let tmpO = {key:toSmallMatrix[h].key,col:'',row:'',value:toSmallMatrix[h].value};
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
  }
  console.log('new lower order funktion');
  console.dir(higherOrderMatrix);


  that.baseSortTable.cols = [];
  that.baseSortTable.rows = {};


  for(let h in higherOrderMatrix) {
    if(!(that.baseSortTable.rows[higherOrderMatrix[h].row]||false)) that.baseSortTable.rows[higherOrderMatrix[h].row] = {lines:[]};
    
    that.baseSortTable.rows[higherOrderMatrix[h].row].lines.push(higherOrderMatrix[h]);
    
    if( that.baseSortTable.cols.indexOf( higherOrderMatrix[h].col ) ===-1 ) {
      that.baseSortTable.cols.push(higherOrderMatrix[h].col)
    }
  }

  console.dir(that.baseSortTable.cols);
  console.dir(that.baseSortTable.rows);

  that.templateList = [];

  for(let s in that.baseSortTable.rows) {
    let row = s;
    let key = that.baseSortTable.rows[s].lines[0].key;
    let cols = {};
    for(let l in that.baseSortTable.rows[s].lines) {
      cols[that.baseSortTable.rows[s].lines[l].col] = that.baseSortTable.rows[s].lines[l].value;
    }
    that.templateList.push({row,key,cols});
  }

  console.log("template like List count: "+that.templateList.length);
  console.dir(that.templateList);

};

</script>
</matrixview>