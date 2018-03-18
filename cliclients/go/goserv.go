package main

import (
  "fmt"
  "os"
  "log"
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
  Limit string
}

var config Conf

func main() {
  config := readConfig()
  app := cli.NewApp()
  app.Name = "servDB"
  app.Usage = "ask one how can know it !"
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
      Name: "onlyone, O",
      Usage: "the first match will return just One",
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
      Usage: "set the output type eg. text,json or env vars",
    },
    cli.StringFlag{
      Name: "type, t",
      Usage: "change the seach for key<->value",
    },
    cli.StringFlag{
      Name: "limit, l",
      Usage: "max return count of items",
    },
  }


  app.Action = func(c *cli.Context) error {

    searchString := "service.hellodocker.%"
    if c.String("search") != "" {
      searchString = c.String("search")
    }

    searchOutp := config.Outp
    if c.String("output") != "" {
      searchOutp = c.String("output")
    }

    searchOne := false
    if c.Bool("onlyone") {
      // urlString = fmt.Sprintf("%s:%s/onevalue/%s",searchHost,searchPort,url.QueryEscape(searchString))
      searchOne = true
    }

    searchBase := ""
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

    searchLimit := config.Limit
    if c.String("limit") != "" {
      searchLimit = c.String("limit")
    }



    // URLs for diffrent needs
    urlString := fmt.Sprintf("%s:%s/%s/%s",searchHost,searchPort,searchPath,url.QueryEscape(searchString))

    if searchOutp=="env" && searchBase != "" {
      if(searchOne) { searchLimit = "1" }
      urlString = fmt.Sprintf("%s:%s/env/%s/%s/%s",searchHost,searchPort,searchLimit,searchBase,url.QueryEscape(searchString))
    } else if searchOutp=="json" {
      urlString = fmt.Sprintf("%s:%s/search/%s/%s/%s",searchHost,searchPort,searchType,searchLimit,url.QueryEscape(searchString))
    }
    // fmt.Println("fire the url string")
    fmt.Println( getURL( urlString)  )
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

func readConfig() Conf {
  file, _ := os.Open("./config.json")
  defer file.Close()
  decoder := json.NewDecoder(file)
  configuration := Conf{}
  err := decoder.Decode(&configuration)
  if err != nil {
    fmt.Println("error:", err)
  }
  // fmt.Println(configuration)
  return configuration
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