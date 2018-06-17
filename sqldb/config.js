module.exports = {
// Field: 'id',
//   Type: 'int(11)',
//   Null: 'NO',
//   Key: 'PRI',
//   Default: null,
//   Extra: 'auto_increment'

  db: [
    {
      name: 'serv',
      tables: [
        {
          Name: 'version',
          cols: [
            {
              Field: 'id',
              Type: 'int(11)',
              Null: 'NO',
              Key: 'PRI',
              Default: null,
              Extra: 'auto_increment'
            },
            {
              Field: 'version',
              Type: 'varchar(64)',
              Null: 'NO',
              Key: '',
              Default: null,
              Extra: ''
            },
          ],
          init: [
            {cols:['version'],vals:['first avenger 0.1.2']},
            {cols:['version'],vals:['more advanced version 0.1.3']},
          ],
        },
        {
          Name: 'servtable',
          cols: [
            {
              Field: 'key',
              Type: 'varchar(3072)',
              Null: 'NO',
              Key: 'PRI',
              Default: null,
              Extra: ''
            },
            {
              Field: 'value',
              Type: 'varchar(3072)',
              Null: 'NO',
              Key: '',
              Default: null,
              Extra: ''
            },
          ],
          init: [
            {cols:['key','value'],vals:['service.servdb.testing.version','0.1.5']},
            {cols:['key','value'],vals:['service.servdb.stageing.version','0.1.4']},
            {cols:['key','value'],vals:['service.servdb.production.version','0.1.3']},
          ],
        },
        {
          Name: 'history',
          cols: [
            {
              Field: 'id',
              Type: 'int(11)',
              Null: 'NO',
              Key: 'PRI',
              Default: null,
              Extra: 'auto_increment'
            },
            {
              Field: 'key',
              Type: 'varchar(3072)',
              Null: 'NO',
              Key: '',
              Default: null,
              Extra: ''
            },
            {
              Field: 'value',
              Type: 'varchar(3072)',
              Null: 'NO',
              Key: '',
              Default: null,
              Extra: ''
            },
          ],
          init: [
            {cols:['key','value'],vals:['service.servdb.testing.version','0.0.1']},
            {cols:['key','value'],vals:['service.servdb.stageing.version','0.0.1']},
            {cols:['key','value'],vals:['service.servdb.production.version','0.0.1']},
            {cols:['key','value'],vals:['service.servdb.testing.version','0.1.1']},
            {cols:['key','value'],vals:['service.servdb.stageing.version','0.1.2']},
            {cols:['key','value'],vals:['service.servdb.production.version','0.1.3']},
            {cols:['key','value'],vals:['service.servdb.testing.version','0.1.3']},
            {cols:['key','value'],vals:['service.servdb.stageing.version','0.1.3']},
            {cols:['key','value'],vals:['service.servdb.production.version','0.1.2']},
          ],
        },
        {
          Name: 'usertoken',
          cols: [
            {
              Field: 'id',
              Type: 'int(11)',
              Null: 'NO',
              Key: 'PRI',
              Default: null,
              Extra: 'auto_increment'
            },
            {
              Field: 'username',
              Type: 'varchar(64)',
              Null: 'NO',
              Key: '',
              Default: null,
              Extra: ''
            },
            {
              Field: 'tokenstring',
              Type: 'char(64)',
              Null: 'NO',
              Key: '',
              Default: null,
              Extra: ''
            },
          ],
          init: [
            {cols:['username','tokenstring'],vals:['firstreaduser','OiWei1aiQueigo9apoyie4IeAeg0ohSauTha7aimii9weNg5woo7OfaigohSo6ah']},
            {cols:['username','tokenstring'],vals:['firstwriteuser','HC5ItQ3Ai1pbGTuIwRFRJxVfdDx2FBOLF0X3ShSoxhuh5o57w44tvWiSyacox43E']},

          ],
        },         
      ],
    },
  ],
}