# The cli client in golang


## Build

First setup your go enviroment, if it isnt already, follow the steps [here](https://golang.org/doc/install)
all steps done on a Linux 64bit system, take a look in the documentaion how to build ELF executables 

### Build static (eq alpine)

```bash
CGO_ENABLED=0 go build -a -installsuffix cgo goserv.go
```

it solve my probleme to execute the binary in a alpine container.




## Docker DinD

its the test container if the binary works independently
```bash
docker build -t dind_test_serv:0.1 -f Docker-DinD .
docker run -it dind_test_serv:0.1 /bin/sh

> cd /home/servTest
> goserv -s %
```

