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
      ],
    },
  ],
}