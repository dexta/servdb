<inventoryDetails>
<h1>inventory details</h1>
<ul>
	<li each={val,key in invlist}>
		{key} : {val}
	</li>
</ul>

<script>
let that = this;
this.invlist = {test:1,"moer.test":3};

riotux.subscribe(that, 'invViewList', function( state, state_value ) {
  that.invlist = riotux.getter('invViewList');
  that.update();
});
</script>

</inventoryDetails>