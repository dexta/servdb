let fiha = {};

const readline = require('readline');
const fs = require('fs');


fiha.filte2list = (filename) => {
  let rl = readline.createInterface({
    input: fs.createReadStream(filename)
  });
  let lines = [];

  return new Promise( (resolve, reject) => {
    rl.on('line', (line) => {
      lines.push(line);
    });
    rl.on('close', () => {
      resolve(lines);
    });
  });

};



// mySQLfile.on('line', (line) => {
//   console.dir(line);
//   let reIn = await sql.pquery(line);
//   console.dir(reIn);
// });


// and export all
module.exports = fiha;