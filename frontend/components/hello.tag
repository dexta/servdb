<hello>
<!-- <div> -->
	<div class="card">
		<img class="card-img-top" src="/img/docker_head.png" style="width:320px" alt="Docker Logo">
	  <ul class="list-group list-group-flush">
      <li class="list-group-item">build Version: {hostdata.buildversion}</li>
	    <li class="list-group-item">Hostname: {hostdata.hostname}</li>
      <li class="list-group-item">Hostip/eth0: {hostdata.hostip}</li>
	    <li class="list-group-item">
        Time of session: {timeleft}</li>
      <li class="list-group-item">
        <div class="form-check">
          <label class="form-check-label col-5">
            <input class="form-check-input" type="checkbox" checked={checkedautoreload} onclick={ toggleAuto }> Auto
          </label>
          <button class="btn btn-danger col-5" onclick={ reloadContainer }>Reload</button>
        </div>
      </li>
	  </ul>
	</div>
<!-- </div> -->

<script>
  let that = this;

  this.hostdata = {};
  this.timeleft = 0;
  this.checkedautoreload = (localStorage.autoreload==="true"||false);

  this.toggleAuto = () => {
    localStorage.autoreload = !this.checkedautoreload;
  }

  this.reloadContainer = () => {
    window.location.href = window.location.href;
  }

  superagent('get','/hostdata').then( (res) => {
  	that.hostdata = res.body;
  	that.update();
  });
  
  this.con = (tn) => { 
  	if(tn<=0&&that.checkedautoreload) that.reloadContainer();
    that.timeleft = tn;
  	setTimeout( ()=> { if(tn>0) that.con(tn-1); },1000 );
  	that.update();
  }; 

  this.con(30);
</script>

</hello>