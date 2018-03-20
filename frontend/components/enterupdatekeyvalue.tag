<enterupdatekeyvalue>
<h4>enter update key value</h4>
<hr>
<button class="btn btn-prinmary" onclick={ showhide_single() }>Single</button>
<button class="btn btn-info" onclick={ showhide_tails() }>Base Tails</button>

<form if={openclose.single} onsubmit={ setSingle }>
  <hr>
  <div class="form-group row">
    <label class="col-sm-2 col-form-label" for="singlekeyinputfield">Key</label>
    <div class="col-sm-10">
      <input type="text" class="form-control" id="singlekeyinputfield" placeholder="service.hellodocker.api" ref="singlekeystring">
    </div>
  </div>

  <div class="form-group row">
    <label class="col-sm-2 col-form-label" for="singlevalueinputfield">Value</label>
    <div class="col-sm-10">
      <input type="text" class="form-control" id="singlevalueinputfield" placeholder="0.4.23" ref="singlevaluestring">
    </div>
  </div>

  <div class="form-group row">
    <div class="col-sm-10">
      <div class="alert alert-{lastSaveReturn.status}" role="alert">
        Last save return: {lastSaveReturn.msg}
      </div>

    </div>
    <div class="col-sm-2">
      <button class="btn btn-danger mb-2">SET</button>
    </div>
  </div>
</form>


<form if={openclose.tails} onsubmit={ setTails }>
  <hr>
  <div class="form-group row">
    <label class="col-sm-1 col-form-label" for="basekeyinputfield">Base</label>
    <div class="col-sm-8">
      <input type="text" class="form-control" id="basekeyinputfield" placeholder="service.hellodocker." ref="tailsbasestring" value={base}>
    </div>
    <div class="col-sm-1">
      <button class="btn btn-success" id="setNewBase" onclick={ setNewBase }><i class="fa fa-umbrella"></i></button>
    </div>
    <div class="col-sm-2">
      <button class="btn btn-primary" onclick={ saveAllTailItems }>Save all</button>
    </div>
  </div>
  <h5>Values:</h5>

  <div class="form-group row" each={ tail, index in tails }>
    <label class="col-sm-6 col-form-label" for="tailskeyinputfield_{index}">{base}</label>
    <div class="col-sm-6">
      <input type="text" class="form-control" id="tailskeyinputfield_{index}" placeholder="service.hellodocker." ref="tailskeystring_{index}" value={tail.key}>
    </div>
    <div class="col-sm-2">
      <button class="btn btn-success" onclick={ saveTailItem }><i class="fa fa-save"></i></button>
      <button class="btn btn-danger" onclick={ delTailItem }><i class="fa fa-trash"></i></button>
    </div>
    <label class="col-sm-1 col-form-label"><i class="fa fa-arrow-right"></i></label>
    <div class="col-sm-9">
      <input type="text" class="form-control" id="tailsvalueinputfield_{index}" placeholder="service.hellodocker." ref="tailsvaluestring_{index}" value={tail.value}>
    </div>
    <div if={ returnMSG[index] } class="alert alert-{returnMSG[index].status}" role="alert">
      Last save return: {returnMSG[index].msg}
    </div>
  </div>
  
  <hr>
  
  <div class="form-group row">
    <label class="col-sm-2 col-form-label" for="addsometail">add</label>
    <div class="col-sm-8"></div>
    <div class="col-sm-2">
      <button class="btn btn-success" onclick={ addTailItem }><i class="fa fa-plus"></i></button>
    </div>
    
  </div>
</form>


<script>
  let that = this;
  this.allKeys = [];
  this.openclose = {single:true,tails:false};
  this.state = {single:'service.',tails:'',base:''};
  this.base = 'service.hellodpocker.api.';
  this.tails = [{key:'host.name',value:'api'},{key:'host.port',value:8074},{key:'network.frontend',value:'frontendNetwork'}];
  this.lastSaveReturn = '';
  this.returnMSG = [];

  superagent('get','/search/key/%25').then( (res) => {
  	that.allKeys = res.body;
    console.dir(res.body);
  	that.update();
  });

  this.insertKeyVal = (key,val) => {
    let getURL = `/insert/simple/${key}/${val}`;
    return superagent('get',getURL).then( (res) => { return res.body; } );
  };

  this.setSingle = (e) => {
    e.preventDefault();
    let keyStr = this.refs.singlekeystring.value;
    let valStr = this.refs.singlevaluestring.value;
    if(keyStr===''||valStr==='') return;

    console.log(keyStr);
    console.log(valStr);

    let getURL = `/insert/simple/${keyStr}/${valStr}`;
    superagent('get',getURL).then( (res) => {
      that.lastSaveReturn = (res.body.msg||false)? res.body : {msg:'null',status:'danger'} ;
      that.update();
    });
  };

  this.showhide_single = () => {
    return () => {
      console.log('click show/hide filter');
      this.openclose.single = !this.openclose.single;  
    };
  };

  this.showhide_tails = () => {
    return () => {
      console.log('click show/hide filter');
      this.openclose.tails = !this.openclose.tails;  
    };
  };

  this.addTailItem = (e) => {
    e.preventDefault(e);
    that.tails.push({key:'new',value:'empty'});
  };

  this.delTailItem = (e) => {
    this.updateTails();
    e.preventDefault(e);
    console.dir(this.tails);
    delInd = parseInt(e.item.index);
    this.tails.splice(delInd,1);
  };

  this.setNewBase = (e) => {
    e.preventDefault();
    if(this.refs.tailsbasestring.value==='') return;
    this.base = this.refs.tailsbasestring.value;
    this.update();
  };

  this.updateTails = () => {
    for(let i in this.tails) {
      this.tails[i].key = this.refs['tailskeystring_'+i].value;
      this.tails[i].value = this.refs['tailsvaluestring_'+i].value;
    }
  };

  this.saveTailByIndex = async (index) => {
    this.returnMSG[index] = await this.insertKeyVal(this.base+this.tails[index].key,this.tails[index].value);
    return this.returnMSG[index];
  };


  this.saveTailItem = async (e) => {
    e.preventDefault();
    this.updateTails();
    indexPressed = parseInt(e.item.index);
    this.saveTailByIndex(indexPressed);
    this.update();
  };

  this.saveAllTailItems = async (e) => {
    e.preventDefault();
    this.updateTails();
    for(let i in this.tails) {
      await this.saveTailByIndex(i);
    }
    this.update();
  };

</script>

</enterupdatekeyvalue>