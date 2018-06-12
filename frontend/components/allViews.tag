<allviews>
  <tableview visual="false">
  </tableview>
  <matrixview visual="false">
  </matrixview>
  <inputoutputview visual="true">
  </inputoutputview>
<script>

let that = this;
this.sideOpen = {search:false,edit:false,setup:true};
this.openShow = {
  tableview:false,matrixview:false,inputoutoutview:true,
};

riotux.subscribe(that, 'sideOpen', function ( state, state_value ) {
  that.sideOpen = riotux.getter('sideOpen');
  for(let ce in that.childElements) { 
    // console.dir(that.childElements[ce]._tag);
    that.childElements[ce]._tag.visual = false;
    }
  if(that.sideOpen.search) {
    that.childElements.tableview._tag.visual = true;
  } else if(that.sideOpen.edit) {
    that.childElements.matrixview._tag.visual = true;
  } else if(that.sideOpen.setup) {
    that.childElements.inputoutoutview._tag.visual = true;
  }
  for(let ce in that.childElements) { that.childElements[ce]._tag.update(); }
  that.update();
});


this.childElements = {};

this.on('mount', () => {
  that.childElements.tableview = document.querySelector('tableview');
  that.childElements.matrixview = document.querySelector('matrixview');
  that.childElements.inputoutoutview = document.querySelector('inputoutputview');
  // console.dir(document.querySelector('inputoutoutview')._tag);
});

this.on('update', () => {

});


this.toggleOpen = () => {
  that.open = !that.open;
};

</script>

</allviews>