<inventoryDetails>
<h1>inventory details from {invlist.searchEntry}</h1>
<div class="row" each={ val,key in invlist} if={ key!='searchEntry' }>
  <div class="col-6">
    <ul class="list-group">
      <li class="list-group-item">Hostname: {key}</li>
      <li class="list-group-item">Distribution: {val.os.distri}</li>
      <li class="list-group-item">Version: {val.os.version}</li>
      <li class="list-group-item">Kernel: {val.os.kernel}</li>
    </ul>
  </div>
  <div class="col-6" each={ dbindex, dbname in val.service.databases}>   
    <ul class="list-group">
      <li class="list-group-item">{dbname}</li>
      <li class="list-group-item" each={ dbval,dbkey in dbindex }>
        {dbkey}: {dbval}
      </li>
      <li class="list-group-item d-flex justify-content-between align-items-center">Version: {dbindex.version}</li>
    </ul>
  </div>
</div>

<script>
let that = this;
this.invlist = {
  "searchEntry":"lxmore",
  "lxmoretest": {
    "os": {
      "distri": "debian",
      "version": "9.5",
      "kernel": "4.9.0-8-amd64 #1 SMP Debian 4.9.110-3+deb9u5 (2018-09-30) x86_64 GNU/Linux"
    },
    "hw":{
      "network": {
        "eth0": {
          "ip4":     "10.0.8.8",
          "status": "down"
        },
        "eth1": {
          "ip4":"192.168.23.1",
          "status": "up"
          }
      },
      "cpu": {
        "count": 4,
        "mhz": 3890
      },
      "ram": {
        "mb": 8196
      },
      "disk": {
        "sda": {
          "gb": 40000
        }
      }
    },
    "service": {
      "databases": {
        "mongo": {
          "version": "3.2.21",
          "port": "27017",
          "auth": "none",
          "mode": "single",
          "role": "master"
        },
        "mysql": {
          "version": "5.7.23",
          "derivate": "percona",
          "port": "3306",
          "auth": "password",
          "mode": "single",
          "role": "master"
        },
      },
      "runtimes": {
        "version": "8.10",
        "npm_version": "6.0",
        "global_bin": {
          "version": "2.3",
          "path": "/usr/local/bin/nodemon"
        }
      },
      "http": {
        "nginx": {
          "version": "1.4"
        }
      }
    },
    "application": {
      "hellodocker": {
        "version": "0.0.1",
        "port": "7423"
      }
    }
  }
};

riotux.subscribe(that, 'invViewList', function( state, state_value ) {
  that.invlist = riotux.getter('invViewList');
  that.update();
});

this.testVal = (v) => {
  // return () => {
    console.dir(v);
  // };
};

</script>

</inventoryDetails>