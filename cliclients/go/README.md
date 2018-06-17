# The cli client in golang


## Usage

```bash {.line-numbers}
goserv.go \
  --host http://127.0.0.1 \
  --port 7423 \
  --base service.servdb.development. \
  --search % \
  --limit 64 \
  --template ../../dockerz/dev_template_local_docker-compose.yml
  --alternative ../../dockerz/dev_template_local_alternative-vars.txt
```

* set HOST with http[s]
* set PORT set always
* set BASE first part of the search and will be removed in return string
* set SEARCH % wildcard everythink after the base string
* set LIMIT the sql column return limit no order
* set TEMPLATE file with ${vars_to_be_replaced} when matching in return
* set ALTERNATIVE 

### Full Usage Options

```bash
--search value, -s value          search string with sql wildcard syntax (default: "service.hellodocker.%")
--output value, -o value          set the output type eg. text,json or env vars
--onlyval, -O                     return just the value
--base value, -b value            base for env output to cut down the long varibales
--host value                      search host as http://<url>
--port value                      http port to conect to
--path value                      set rest path of request
--type value, -t value            change the search for key<->value
--limit value, -l value           max return count of items
--config value, -c value          override the configfile path (default: "servconfig.json")
--export, -E                      if output format is env than add export infront of all vars
--template value, --tpl value     replace ${vars} inside template file
--alternative value, --alt value  fallback var values if server connection is broken [bootstrap!]
--help, -h                        show help
--version, -v                     print the version
```

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

