let spi = {};

spi.insertEntry = async (db,data) => {
  if(data||false) {
    let seekKeyString = db.connection.escape(data.key);
    let seekValueString = db.connection.escape(data.value);
    let testExists = await db.pquery(`SELECT * FROM servtable WHERE \`key\`=${seekKeyString};`);
    if(testExists[0]||false) {
      let testSame = await db.pquery(`SELECT * FROM servtable WHERE \`key\`=${seekKeyString} AND \`value\`=${seekValueString};`);
      if(testSame[0]||false) {
        return {msg:'same key/value skip',status:'info'};
      } else {
        let copyOld = await db.pquery(`INSERT INTO history (\`key\`,\`value\`) SELECT * FROM servtable WHERE \`key\`=${seekKeyString};`);
        let updateState = await db.pquery(`UPDATE servtable SET \`value\`=${seekValueString} WHERE \`key\`=${seekKeyString};`);
        return {msg:'update value and save entry to history',status:'success'};
      }
    } else {
      reInsert = await db.pquery(`INSERT INTO servtable (\`key\`,\`value\`) VALUES(${seekKeyString}, ${seekValueString});`);
      return {msg:'happy little clouds and every tree needs a friend',status:'success'};
    }
  } else {
    return {msg:"some is wrong with data",status:'danger'};
  }
};


spi.searchKey = async (db,keyString) => {
  let seekKeyString = db.connection.escape(keyString);
  console.log('search key debug:');
  console.log(seekKeyString);
  let fireSearch = await db.pquery(`SELECT * FROM servtable WHERE \`key\` like ${seekKeyString}`);
  console.log('search resulte');
  console.dir(fireSearch);
  return fireSearch;
};


spi.searchValue = async (db,valueString) => {
  let seekValueString = db.connection.escape(valueString);
  console.log('search value debug:');
  console.log(seekValueString);
  let fireSearch = await db.pquery(`SELECT * FROM servtable WHERE \`value\` like ${seekValueString}`);
  console.log('search resulte');
  console.dir(fireSearch);
  return fireSearch;
};


spi.searchKeyValLimit = async (db,opt) => {
  let limit = parseInt(opt.limit);
  let searchBy = opt.by||'key';
  let searchStr = db.connection.escape(opt.search||'%');

  let fireSearch = await db.pquery(`SELECT * FROM servtable WHERE \`${searchBy}\` like ${searchStr} LIMIT ${limit}`);
  return fireSearch;
};



spi.getOneValue = async (db,searchKey) => {
  let seekKeyString = db.connection.escape(searchKey);
  let fireSearch = await db.pquery(`SELECT value FROM servtable WHERE \`key\` like ${seekKeyString} LIMIT 1;`);
  return fireSearch[0]['value'];
};



module.exports = spi;