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
  console.log("test db table ->  "+tableName);
  let doesItExist = await db.pquery(`SELECT * FROM ${tableName} LIMIT 1;`)
                    .catch((err) => {
                      return {err:`no table with name ${tableName}`};
                    });

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

shema.testKeysValues = async (db,tabname,keyval,testonly) => {
  if(keyval.cols.length!=keyval.vals.length) return {err:'diffrent '};
  let justtest = (testonly||false)? true : false;
  let sel = `SELECT * FROM ${tabname} WHERE `;
  let insK = `INSERT INTO ${tabname} (`;
  let insV = ` VALUES (`;
  for(let kv=0,kvl=keyval.cols.length;kv<kvl;kv++) {
    sel += '`'+keyval.cols[kv]+'` = "'+keyval.vals[kv]+'" AND ';
    insK += (kv!=0)? ',':'';
    insK += ' `'+keyval.cols[kv]+'`';
    insV += (kv!=0)? ',':'';
    insV += ' "'+keyval.vals[kv]+'"';
  }
  insK += ')';
  insV += ')';
  
  sel = sel.replace(/\sAND\s$/i,'');

  console.log("test key val select query "+sel);
  let urThere = await db.pquery(sel).catch( (err) => { return err; });

  console.log("test Key Value  ->");
  console.dir(urThere);
  if( !(urThere||false) || (urThere.length===0) ) {
    if(justtest) return true;
    console.log("insert query ");
    console.log(insK+' '+insV);
    await db.pquery(insK+' '+insV);
    return true;
  }
  return false;
};

shema.checkSQLstate = async (db,ckObj) => {
  console.log("start check the state");
  console.dir(ckObj);

  for(let a in ckObj.db[0].tables) {
    let tab = ckObj.db[0].tables[a];
    let hasTable = await shema.testDbTable(db,tab.Name);
    if(hasTable.err||false) {
      let crOb = {dropTable:true,tableName:tab.Name,primaryKey:tab.cols[0].Field,col:[]};
      for(let c in tab.cols) {
        crOb.col.push({name:tab.cols[c].Field,type:tab.cols[c].Type,options:' NOT NULL '+tab.cols[c].Extra});
        if(tab.cols[c].Key==='PRI') crOb.primaryKey = tab.cols[c].Field;
      }
      await shema.createTable(db,crOb);
    }

    if(tab.init||false) {
      for(let i in tab.init) {
        await shema.testKeysValues(db,tab.Name,tab.init[i]);
      }
    }
  }

  console.log("end check the state");
  return;
};

module.exports = shema;