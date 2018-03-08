HowTo Gen A Certificate
=======================

Generate a Private Key
======================
```
openssl genrsa -out privateKey.pem 4096
```

Create a Certificate Signing Request
====================================
```
openssl req -new -key privateKey.pem -out csr.pem
```

now answer some questions in the interactive dialog:
* Country Name (2 Letter Code) DE,FR,ES,US,UK,JP,.....
* State or Province Name (full name) Hamburg
* Locality Name (eg, city) [] Hamburg
* Organization Name (eg, company) [Internet Widgits Pty Ltd] your Company
* Organizational Unit Name (eg, section) [] if there is any
* Common Name (e.g. server FQDN or YOUR name) [] your server domain/URL ... we did localhost
* Email Address [] for response form anyone 
* A challenge password [] can be empty if not needed
* An optional company name [] for more special not needed also

And now the real Certificate file
=================================
```
openssl x509 -in csr.pem -out certificate.pem -req -signkey privateKey.pem -days 365
```
* input is our csr.pem
* outfile is certificate.pem
* new request with -req
* sign it with our key privateKey.pem
* and it is valid for 365 -days
