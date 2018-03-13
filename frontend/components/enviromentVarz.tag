<enviromentVarz class="row">
<div class="col-lg-3 col-md-6 col-sm-12" each={ block,index in envlist }>
	<div class="card">
		<b>Index: { index }</b>
    <ul class="list-group list-group-flush" each={ value,key in block }>
			<li class="list-group-item">{key} : { short(value) }</li>
		</ul>
	</div>
</div>

<script>
let that = this;
this.envlist = [];

superagent('get','/test/env').then( (res) => {
	that.envlist = [];
  let counter = 0;
  let blockmax = 6;
  let blockcount = 0;
  that.envlist[blockcount] = {};
  let biglist = res.body;
  
  for(let el in biglist) {
    that.envlist[blockcount][el] = biglist[el]||"error";
    counter++;
    if(counter%blockmax===0) {
      blockcount++;
      that.envlist[blockcount] = {};
    }
  }
	that.update();
});

this.short = (toshorting) => {
	return toshorting.substr(0,64);
};

</script>

</enviromentVarz>