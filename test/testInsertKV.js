const http = require('http');

const giveRanChar = (ccount) => {
  const abc = 'abcdefghijklmnopqrstuvwxyz';
  let mnchr = '';
  for(let i=0; i<=ccount; i++) {
    mnchr += abc[Math.floor(Math.random()*abc.length)];
  }
  return mnchr;
}

const sendRequest = (key,val) => {
  return new Promise ((resolve, reject) => {
    let options = {host:'localhost',port:'7423',path:'/insert/simple/'};
    options.path += key+'/'+val;
    let reBody = '';
    let req = http.get(options, (req) => {
      req.on('data', (d) => {
        reBody += d;
      });

      req.on('end', () => {
        resolve(reBody);
      });      
    });
  });
};



const massSend = async (mCount) => {
  let startTime = new Date()*1;
  console.log(`we will send ${mCount} inserts`);

  for(let m=0; m<=mCount; m++) {
    let nKey = 'test.test.test.'+giveRanChar(5);
    let nVal = giveRanChar(15);
    let firstPing = await sendRequest(nKey,nVal);
  }
 
  // if(firstPing.indexOf(''))


  let endTime = new Date()*1;
  console.log(`Time diff ${endTime-startTime}`);
};


massSend(1000);

