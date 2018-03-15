let spi = {};

spi.insertEntry = async (db,data) => {
  if(data||false) {
    let seekKeyString = db.connection.escape(data.key);
    let seekValueString = db.connection.escape(data.value);
    let testExists = await db.pquery(`SELECT * FROM servtable WHERE \`key\`=${seekKeyString};`);
    if(testExists[0]||false) {
      let testSame = await db.pquery(`SELECT * FROM servtable WHERE \`key\`=${seekKeyString} AND \`value\`=${seekValueString};`);
      if(testSame[0]||false) {
        return {info:'same key/value skip'};
      } else {
        let copyOld = await db.pquery(`INSERT INTO history (\`key\`,\`value\`) SELECT * FROM servtable WHERE \`key\`=${seekKeyString};`);
        let updateState = await db.pquery(`UPDATE servtable SET \`value\`=${seekValueString} WHERE \`key\`=${seekKeyString};`);
        return {success:'update value and save entry to history'};
      }
    } else {
      reInsert = await db.pquery(`INSERT INTO servtable (\`key\`,\`value\`) VALUES(${seekKeyString}, ${seekValueString});`);
      return {success:'happy little clouds and every tree needs a friend'};
    }
  } else {
    return {error:"some is wrong with data"};
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


spi.getOneValue = async (db,searchKey) => {
  let seekKeyString = db.connection.escape(searchKey);
  let fireSearch = await db.pquery(`SELECT value FROM servtable WHERE \`key\` like ${seekKeyString} LIMIT 1;`);
  return fireSearch[0]['value'];
};



module.exports = spi;