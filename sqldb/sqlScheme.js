let shema = {};

// shema.testDbConection = function testDbConection() {
//   return new Promise( (resolve, reject) => {
//     this.connection.connect( (err, data) => {
//       if (err) reject(err);        
//       resolve(this.connection.threadId);
//     });
//   });
// };

shema.testDbTable = async (db,tableName) => {
  let doesItExist = await db.pquery(`SELECT * FROM ${tableName} LIMIT 1;`);
  if(doesItExist.length===0) {
    return {err:`no table with name ${tableName}`};
  }
  return doesItExist;
};

shema.showColumnsFrom = async (db,nameTable) => {
  let columns = await db.pquery(`show columns from ${nameTable}; `);
  if(columns.length===0) {
    console.log(`no columns in table with name ${nameTable}`);
  } else {
    console.log(`table here with name: ${nameTable} columns`);
    console.dir(columns);
  }
  return columns;
};


shema.createTable = async (db,createObj) => {
  // DROP TABLE IF EXISTS `history`;
    
  // CREATE TABLE `history` (
  //   `id` INTEGER NOT NULL AUTO_INCREMENT,
  //   `key` VARCHAR(3072) NOT NULL,
  //   `value` VARCHAR(3072) NOT NULL,
  //   PRIMARY KEY (`id`)
  // );
  // createObj = {};
  // createObj.dropTable=true;
  // createObj.tableName='history';
  // createObj.primaryKey='id';
  // createObj.col = [];
  // createObj.col[0] = {name:'id',type:'INTEGER',options:' NOT NULL AUTO_INCREMENT'};
  // createObj.col[1] = {name:'key',type:'VARCHAR(3072)',options:'NOT NULL'},
  // createObj.col[2] = {name:'value',type:'VARCHAR(3072)',options:'NOT NULL'},
  // createObj.col[3] = {name:'',type:'',options:''},

  console.log("create Object ");
  console.dir(createObj);

  let createQuery = '';
  let colList = '';
  if(createObj.dropTable) {
    let dropedTable = await db.pquery('DROP TABLE IF EXISTS `'+createObj.tableName+'`;');
    console.log(`dropping table ${createObj.tableName}`);
    console.dir(dropedTable);
  }

  for(let c=0,cl=createObj.col.length;c<cl;c++) {
    let colI = createObj.col[c];
    colList += '`'+colI.name+'` '+colI.type+' '+colI.options+',';
  }
  colList += 'PRIMARY KEY (`'+createObj.primaryKey+'`)';

  createQuery += 'CREATE TABLE `'+createObj.tableName+'` (';
  createQuery += colList;
  createQuery += ');'
  
  console.log("create Table Query");
  console.log(createQuery);

  let crtaCall = await db.pquery(createQuery);
  return crtaCall;
};


shema.checkSQLstate = async (db,ckObj) => {
  console.log("start check the state");
  console.dir(ckObj);

  for(let a in ckObj.db[0].tables) {
    let tab = ckObj.db[0].tables[a];
    console.log("table name "+tab.Name);
    let hasTable = await shema.testDbTable(db,tab.Name);
    if(hasTable.err||false) {
      let crOb = {dropTable:true,tableName:tab.Name,primaryKey:tab.cols[0].Field,col:[]};
      for(let c in tab.cols) {
        crOb.col.push({name:tab.cols[c].Field,type:tab.cols[c].Type,options:' NOT NULL '+tab.cols[c].Extra});
        if(tab.cols[c].Key==='PRI') crOb.primaryKey = tab.cols[c].Field;
      }
      await shema.createTable(db,crOb);
    }
    // console.log(hasTable);
    // console.dir(tab);
  }



  console.log("end check the state");
  return;
};

module.exports = shema;