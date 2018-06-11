<alloptions>
<div class="form-group row">
  <button type="button" class="btn btn-warning btn-lg btn-block" onclick={toggleOpen}>
    <span class="badge badge-warning pull-left">
      <i show={open} class="fa fa-minus-square"></i>
      <i hide={open} class="fa fa-plus-square"></i>
    </span>
                Edit View Control
  </button>
</div>
<form onsubmit={ updateSearch } show={open}>
  <div class="form-group row">
    <div class="col-4">
      <button type="button" class="btn btn-success btn-block" onclick={changeOpenSideTo('search')}>
        <span class="badge badge-success pull-left">
          <i show={sideOpen.search} class="fa fa-check-square fa-2x"></i>
          <i hide={sideOpen.search} class="fa fa-square fa-2x"></i>
        </span>
                    Search
      </button>
    </div>

    <div class="col-4">
      <button type="button" class="btn btn-danger btn-block" onclick={changeOpenSideTo('edit')}>
        <span class="badge badge-danger pull-left">
          <i show={sideOpen.edit} class="fa fa-check-square fa-2x"></i>
          <i hide={sideOpen.edit} class="fa fa-square fa-2x"></i>
        </span>
                    Edit
      </button>
    </div>
    <div class="col-4">
      <button type="button" class="btn btn-info btn-block" onclick={changeOpenSideTo('setup')}>
        <span class="badge badge-info pull-left">
          <i show={sideOpen.setup} class="fa fa-check-square fa-2x"></i>
          <i hide={sideOpen.setup} class="fa fa-square fa-2x"></i>
        </span>
                    Setup
      </button>
    </div>    
  </div>
</form>

  <baseoptions open="false">
  </baseoptions>
<!-- <hr> -->
  <searchoptions open="false">
  </searchoptions>
<!-- <hr> -->
  <envireditoptions open="false">
  </envireditoptions>
<!-- <hr> -->
  <inputoutputoptions open="true">
  </inputoutputoptions>

<script>

let that = this;
this.sideOpen = {search:false,edit:false,setup:true};
this.openShow = {baseoptions:false,searchoptions:false,envireditoptions:false,inputoutputoptions:true};

this.open = true;

this.childElements = {};

this.on('mount', () => {
  that.childElements.baseoptions = document.querySelector('baseoptions');
  that.childElements.searchoptions = document.querySelector('searchoptions');
  that.childElements.envireditoptions = document.querySelector('envireditoptions');  
  that.childElements.inputoutputoptions = document.querySelector('inputoutputoptions');
});



riotux.subscribe(that, 'sideOpen', function ( state, state_value ) {
  that.sideOpen = riotux.getter('sideOpen');
  that.update();
});



this.changeOpenSideTo = (varName) => {
  return () => {
    
    for(let os in that.openShow) { 
      that.openShow[os] = false;    
    }

    for(let so in that.sideOpen) { that.sideOpen[so]=false; }

    that.sideOpen[varName] = true;
      
    if(varName==='search') {
      that.openShow.baseoptions = true;
      that.openShow.searchoptions = true;
    } else if(varName==='edit') {
      that.openShow.baseoptions = true;
      that.openShow.envireditoptions = true;
    } else if(varName==='setup') {
      console.log("here we are to hold the place "+varName);
      that.openShow.inputoutputoptions = true;
    }

    for(let ce in that.childElements) {
      that.childElements[ce]._tag.open = that.openShow[ce];
      that.childElements[ce]._tag.update();
    }

    riotux.action('sideOpen', 'setSideOpened', that.sideOpen);
  };
};


this.toggleOpen = () => {
  that.open = !that.open;
};
</script>

</alloptions>