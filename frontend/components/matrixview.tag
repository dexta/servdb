<matrixview show={visual}>
  <table class="table">
    <thead>
      <tr>
        <th>x/y</th>
        <th scope="col" each={ colth, chindex in baseSortTable.cols }>{colth}</th>
      </tr>
    </thead>
    <tbody>
      <tr each={ lineOf , rowinx in baseSortTable.rows }>
        <td>{rowinx}</td>
        <td each={ colname, colinx in baseSortTable.cols}>

          <div if={lineOf.lines[colname]} class="form-group row">
            <div class="col-8">
              <input type="text" class="form-control" disabled  data-toggle="tooltip" data-placement="bottom" title="Tooltip on bottom"
                      id="{lineOf.lines[colname].key}" value="{ lineOf.lines[colname].value }">
              <small if={ lineOf.lines[colname].err } class="form-text text-muted text-{lineOf.lines[colname].err.status}">
                Lr: {lineOf.lines[colname].err.msg}
              </small>
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
  that.basematrix = riotux.getter('basematrix');
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
    let tmpO = {key:toSmallMatrix[h].key,col:'',row:'',value:toSmallMatrix[h].value,disabled:true,err:''};
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
    higherOrderMatrix.push(tmpO);

    if(!(that.baseSortTable.rows[tmpO.row]||false)) {
      that.baseSortTable.rows[tmpO.row] = {lines:{}};
    }

    that.baseSortTable.rows[tmpO.row].lines[tmpO.col] = tmpO;

    if( that.baseSortTable.cols.indexOf( tmpO.col ) ===-1 ) {
      that.baseSortTable.cols.push(tmpO.col)
    }
    console.dir(that.baseSortTable.rows);
  }
};

this.subEditEntry = (rowK) => {
  let rowcol = document.getElementById(rowK.key);
  rowcol.disabled = false;
  that.baseSortTable.rows[rowK.row].lines[rowK.col].disabled = false;
  // console.dir(rowcol);
};

this.editEntry = (rowK) => {
  return () => { 
    let inputElement = document.getElementById(rowK.key);
    inputElement.disabled = false;
    rowK.disabled = false;
  };
};

this.saveEntry = (rowK) => {
  return () => {
    let inputElement = document.getElementById(rowK.key);
    inputElement.disabled = true;
    insertKeyValue(rowK.key,inputElement.value, (returnMsg) => {
      rowK.err = returnMsg;
      that.update();
    });
    setTimeout( ()=> { 
      rowK.err='';
      rowK.disabled = true;
      that.update();
    }, 3000 );
  };
};

</script>
</matrixview>