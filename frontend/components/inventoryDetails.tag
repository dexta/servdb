<inventoryDetails>
<h1>inventory details</h1>
<ul>
	<li each={val,key in invlist}>
		<ul if={ typeof val === 'object'}>
      <li each={ val_1,key_1 in val }>
        <ul if={ typeof val_1 === 'object'}>
          <li each={ val_2,key_2 in val_1 }>
            <ul if={ typeof val_2 === 'object'}>
              <li each={ val_3,key_3 in val_2 }>
                <ul if={ typeof val_2 === 'object'}>
                  <li each={ val_3,key_3 in val_2 }>
                    {key} :{val}
                  </li>
                </ul
                {key_3} :<span hide={typeof val_3 === 'object'}> {val_2}</span>
              </li>
            </ul>
            {key_2} :<span hide={typeof val_2 === 'object'}> {val_2}</span>
          </li>
        </ul>
        {key_1} :<span hide={typeof val_1 === 'object'}> {val_1}</span>
      </li>
    </ul>
    {key} : <span hide={typeof val === 'object'}>{val}</span>
	</li>
</ul>

<script>
let that = this;
this.invlist = {
  "searchEntry":"lxmore",
  "lxmoretest": {
    "network": {
      "eth1": {
        "ip":     "8.8.8.8",
        "status": "down"
      },
      "eth2": {
        "ip":"192.168.23.1"
        }
      },
      "service": {
        "db": {
          "mongo":"v3.1"
        }
      }
    }
  };

riotux.subscribe(that, 'invViewList', function( state, state_value ) {
  that.invlist = riotux.getter('invViewList');
  that.update();
});
</script>

</inventoryDetails>