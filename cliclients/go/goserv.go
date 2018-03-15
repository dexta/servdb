package main

import (
  "fmt"
  "log"
  "os"

  "github.com/urfave/cli"
  "github.com/parnurzeal/gorequest"
)

type keyValue struct {
  key string
  value string
}

type KeyValues []keyValue

var col = fmt.Println


func main() {
  app := cli.NewApp()
  app.Name = "boom"
  app.Usage = "make an explosive entrance"
  app.Action = func(c *cli.Context) error {
    // fmt.Println(getURL("http://localhost:7423/onevalue/service.%25.version"))
    fmt.Println(getURL("http://localhost:7423/search/key/service.hellodocker%25"))
    return nil
  }

  err := app.Run(os.Args)
  if err != nil {
    log.Fatal(err)
  }
}


func getURL(url string) string {
  fmt.Println("start get url ",url)
  request := gorequest.New()
  resp, body, errs := request.Get(url).End()
  if errs != nil {
    log.Fatal(errs)
  }
  fmt.Println(resp.Status)
  // fmt.Println("### resp ###")
  // fmt.Println(resp)
  // fmt.Println("### body ###")
  // fmt.Println(body)
  // return body

  return body
}