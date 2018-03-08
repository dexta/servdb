const fs = require('fs');
const path = require('path');

const keys = {
	privateKey: fs.readFileSync(path.join(__dirname,"privateKey.pem"), { encoding: 'utf-8' }),
	certificate: fs.readFileSync(path.join(__dirname,"certificate.pem"), { encoding: 'utf-8' })
};


module.exports = keys;