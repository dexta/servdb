package main

import (
  "fmt"
  "os"
  "log"
  "net/url"

  "github.com/urfave/cli"
)

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
  app.Version = "0.0.5"

  app.Flags = []cli.Flag {
    cli.StringFlag{
      Name: "base, b",
      Value: "service.servdb.",
      Usage: "base for env output to cut down the long varibales",
    },
    cli.StringFlag{
      Name: "search, s",
      Value: "development",
      Usage: "search string with sql wildcard syntax",
    },
    cli.StringFlag{
      Name: "output, o",
      Value: "ENV",
      Usage: "output type eg. tpl,text,json,env",
    },
    cli.BoolFlag{
      Name: "onlyval, O",
      Usage: "return just the value",
    },
    cli.StringFlag{
      Name: "host",
      Usage: "search host as http://<url>",
    },
    cli.StringFlag{
      Name: "port",
      Usage: "http port to conect to",
    },
    // cli.StringFlag{
    //   Name: "path",
    //   Usage: "set rest path of request",
    // },
    // cli.StringFlag{
    //   Name: "type, t",
    //   Usage: "change the search for key<->value",
    // },
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
      Usage: "add export infront of all keys",
    },
    cli.StringFlag{
      Name: "template, tpl",
      Usage: "replace ${vars} inside template file",
    },
    cli.StringFlag{
      Name: "template-out, tplout",
      Usage: "write the parsed template to a file",
    },
  }

  app.Action = func(c *cli.Context) error {
  // read config after cli parameter maybe we want to override the source
    config := readConfig(c.String("config"))

    if c.String("search") != "" {
      config.Find = c.String("search")
    }

    if c.String("output") != "" {
      config.Outp = c.String("output")
    }

    if c.Bool("onlyone") {
      config.OOne = true
    }

    if c.String("base") != "" {
      config.Base = c.String("base")
    }

    if c.String("host") != "" {
      config.Host = c.String("host")
    }

    if c.String("port") != "" {
      config.Port = c.String("port")
    }    

    if c.String("path") != "" {
      config.Path = c.String("path")
    }

    if c.String("type") != "" {
      config.Type = c.String("type")
    }

    if c.String("limit") != "" {
      config.Limit = c.String("limit")
    }

    if c.Bool("export") {
      config.Export = true
    }

    if c.String("template") != "" {
      config.TemplateIn = c.String("template")
    }

    if c.String("template-out") != "" {
      config.TemplateOut = c.String("template-out")
    }

    // URLs for diffrent needs
    urlString := fmt.Sprintf(  
      "%s:%s/%s/%s",config.Host,config.Port,config.Path,
      url.QueryEscape(doTheDooot(config.Base, config.Find)))


    fmt.Println("url String by config: "+urlString)
    final := formateTheDataByConfig( getTheDataFromSomewhere(urlString), config )

    var configOutputFormat = upChar(config.Outp)
    fmt.Println("config Find  "+config.Find)
    if configOutputFormat == "ENV" {
      formateKeyValueList(final)
    } else if configOutputFormat == "JSON" {
      jsonConsoleOutput(final)
    } else if configOutputFormat == "TEXT" {
      formateKeyValueList(final)
    } else if configOutputFormat == "TPL" {
      if config.TemplateIn != "" {
        handleTemplate(final,config)  
      }  else {
        // formateKeyValueList(final)
        log.Fatal("error: no template input file defined")
      }
    }

    return nil
  }

  err := app.Run(os.Args)
  if err != nil {
    log.Fatal(err)
  }
}
