<entertitletext>
  <div class="card">
    <form>
      <div class="form-group">
        <label for="titleText">Title</label>
        <input type="text" class="form-control" id="titleText" placeholder="just a small headline">
      </div>
      <div class="form-group">
        <label for="textText">Text</label>
        <input type="text" class="form-control" id="textText" placeholder="some more words here">
      </div>
      <div class="pull-right">
        <button class="btn btn-primary" onclick={ sendForm }>Submit</button>
      </div>      
    </form>
  </div>

<script>
  let that = this;
  // this.listoftitles = [];
  // superagent('get','/api/get/all').then( (res) => {
  //   that.listoftitles = res.body;
  //   that.update();
  // });

  this.sendForm = (e) => {
    e.preventDefault();
    let titleText = document.getElementById('titleText').value;
    let textText = document.getElementById('textText').value;
    console.dir({titleText,textText});


    superagent.post('/api/post')
              .set('Content-Type', 'application/json')
              .send({title:titleText,text:textText})
              .then( 
                (res) => {
                  console.dir(res);
                  titleText = "";
                  textText = "";
                });
  };


</script>
</entertitletext>