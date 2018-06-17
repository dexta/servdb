package main

import (
  "bufio"
  "fmt"
  "strings"
  "os"
  "log"
  "io/ioutil"
  "encoding/json"
  "net/url"

  "github.com/urfave/cli"
  "github.com/parnurzeal/gorequest"
)

type Conf struct {
  Host  string
  Port  string
  Path  string
  Type  string
  Outp  string
  Base  string
  Limit string
  Export  bool
  OOne    bool
}

var config Conf

func IfThenElse(condition bool, a interface{}, b interface{}) interface{} {
  if condition {
    return a
  }
  return b
}

func main() {
  
  app := cli.NewApp()
  app.Name = "servDB"
  app.Usage = "ask one who can know it !"
  app.Version = "0.0.3"

  app.Flags = []cli.Flag {
    cli.StringFlag{
      Name: "search, s",
      Value: "service.hellodocker.%",
      Usage: "search string with sql wildcard syntax",
    },
    cli.StringFlag{
      Name: "output, o",
      Usage: "set the output type eg. text,json or env vars",
    },
    cli.BoolFlag{
      Name: "onlyval, O",
      Usage: "return just the value",
    },
    cli.StringFlag{
      Name: "base, b",
      Usage: "base for env output to cut down the long varibales",
    },
    cli.StringFlag{
      Name: "host",
      Usage: "search host as http://<url>",
    },
    cli.StringFlag{
      Name: "port",
      Usage: "http port to conect to",
    },
    cli.StringFlag{
      Name: "path",
      Usage: "set rest path of request",
    },
    cli.StringFlag{
      Name: "type, t",
      Usage: "change the search for key<->value",
    },
    cli.StringFlag{
      Name: "limit, l",
      Usage: "max return count of items",
    },
    cli.StringFlag{
      Name: "config, c",
      Value: "servconfig.json",
      Usage: "override the configfile path",
    },
    cli.BoolFlag{
      Name: "export, E",
      Usage: "if output format is env than add export infront of all vars",
    },
    cli.StringFlag{
      Name: "template, tpl",
      Usage: "replace ${vars} inside template file",
    },
    cli.StringFlag{
      Name: "alternative, alt",
      Usage: "fallback var values if server connection is broken [bootstrap!]",
    },
  }



  app.Action = func(c *cli.Context) error {
  // read config after cli parameter maybe we want to override the source
    config := readConfig(c.String("config"))

    searchString := "service.hellodocker.%"
    if c.String("search") != "" {
      searchString = c.String("search")
    }

    searchOutp := config.Outp
    if c.String("output") != "" {
      searchOutp = c.String("output")
    }

    searchOne := config.OOne
    if c.Bool("onlyone") {
      // urlString = fmt.Sprintf("%s:%s/onevalue/%s",searchHost,searchPort,url.QueryEscape(searchString))
      searchOne = true
    }

    searchBase := config.Base
    if c.String("base") != "" {
      searchBase = c.String("base")
    }

    searchHost := config.Host
    if c.String("host") != "" {
      searchHost = c.String("host")
    }

    searchPort := config.Port
    if c.String("port") != "" {
      searchPort = c.String("port")
    }    

    searchPath := config.Path
    if c.String("path") != "" {
      searchPath = c.String("path")
    }

    searchType := config.Type
    if c.String("type") != "" {
      searchType = c.String("type")
    }


    searchLimit := IfThenElse((config.Limit!=""),string(config.Limit),"100")
    // searchLimit := "100"
    // searchLimit := config.Limit
    if c.String("limit") != "" {
      searchLimit = c.String("limit")
    }

    searchExport := config.Export
    if c.Bool("export") {
      searchExport = true
    }

    searchTemplate := ""
    if c.String("template") != "" {
      searchTemplate = c.String("template")
    }

    alternativeFileData := ""
    if c.String("alternative") != "" {
      alternativeFileData = c.String("alternative")
    }

    // URLs for diffrent needs
    urlString := fmt.Sprintf("%s:%s/%s/%s",searchHost,searchPort,searchPath,url.QueryEscape(searchString))

    if searchOutp=="env" && searchBase != "" {
      if(searchOne) { searchLimit = "1" }
      if(searchExport) {
        urlString = fmt.Sprintf("%s:%s/env/%s/%s/%s/true",searchHost,searchPort,searchLimit,searchBase,url.QueryEscape(searchString))
      } else {
        urlString = fmt.Sprintf("%s:%s/env/%s/%s/%s",searchHost,searchPort,searchLimit,searchBase,url.QueryEscape(searchString))
      }

    } else if searchOutp=="json" {
      urlString = fmt.Sprintf("%s:%s/search/%s/%s/%s",searchHost,searchPort,searchType,searchLimit,url.QueryEscape(searchString))
    }

    if(searchTemplate != "") {
      multLine := canBeAlternate(urlString, alternativeFileData)
      replMap := map[string]string{}
      for _, line := range strings.Split(strings.TrimSuffix(multLine, "\n"), "\n") {
        keyVal := strings.Split(line, "=")
        replMap[keyVal[0]] = keyVal[1]
      }
      // fmt.Println(replMap)

      openTemplate(searchTemplate, replMap)

      return nil
    } else if(searchOne) {
      toCut := getURL( urlString)
      isCut := strings.Split(strings.TrimSuffix(toCut, "\n"), "\n")[0]
      fmt.Println( strings.Split(isCut,"=")[1] )
    } else {
      fmt.Println( getURL( urlString)  )    
    }


    // fmt.Println("fire the url string")
    // fmt.Println(urlString)
    
    // fmt.Println("end of active stuff")
    // fmt.Println(getURL("http://localhost:7423/onevalue/service.%25.version"))
    // fmt.Println(getURL("http://localhost:7423/search/key/service.hellodocker%25"))
    // fmt.Println("conf host "+config.Host)
    return nil
  }

  err := app.Run(os.Args)
  if err != nil {
    log.Fatal(err)
  }
}

func readConfig(filename string) Conf {
  file, _ := os.Open(filename)
  defer file.Close()
  decoder := json.NewDecoder(file)
  configuration := Conf{}
  err := decoder.Decode(&configuration)
  if err != nil {
    log.Fatal("error:", err)
  }
  // fmt.Println(configuration)
  return configuration
}

func openTemplate(filename string, replst map[string]string) string {
  file, err := os.Open(filename)
  if err != nil {
    if os.IsNotExist(err) {
      log.Fatal("File does not exist.")
    } else if os.IsPermission(err) {
      log.Println("Error: Read permission denied.")
    } else {
      fmt.Println(err)  
    }
    
    os.Exit(1)
  }
  defer file.Close()

  scanner := bufio.NewScanner(file)
  for scanner.Scan() {
    wrkLine := scanner.Text()
    for k, v := range replst {
      sStringKey := "${"+k+"}"
      temlLine := strings.Replace(wrkLine, sStringKey, v, -1)
      wrkLine = temlLine
    }
    fmt.Println(wrkLine)
  }


  return ""
}

func canBeAlternate(url string, altFilename string) string {
  request := gorequest.New()
  resp, body, errs := request.Get(url).End()
  if errs != nil || resp.Status != "200 OK" {
    if altFilename != "" {
      altbody, err := ioutil.ReadFile(altFilename)
      if err != nil {
        log.Fatal("error:", err)
      }
      return string(altbody)
    } else {
      log.Fatal(errs)
    }    
  }
  return body
}

func getURL(url string) string {
  // fmt.Println("start get url ",url)
  request := gorequest.New()
  resp, body, errs := request.Get(url).End()
  if errs != nil || resp.Status != "200 OK" {
    log.Fatal(errs)
  }
  // fmt.Println(resp.Status)

  return body
}