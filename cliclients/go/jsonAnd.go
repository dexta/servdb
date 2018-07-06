package main

import (
  "fmt"
  "os"
  "io/ioutil"
  "log"
  "encoding/json"
  // "net/url"
  "strings"
  "regexp"

  "github.com/parnurzeal/gorequest"
)

type KeyValue struct {
  Key     string `json:"key"`
  Value   string `json:"value"`
}

type Conf struct {
  Host          string
  Port          string
  Path          string
  Type          string
  Outp          string
  Base          string
  Find          string
  Limit         string
  Alternative   string
  TemplateIn    string
  TemplateOut   string
  Export        bool
  OOne          bool
}

var config Conf

var jsonContent []KeyValue

// func main() {
//   config = readConfig("servconfig.json")
//   doOneAll := getTheDataFromSomewhere("%s:%s/search/%s/%s/%s",config.Host,config.Port,config.Type,config.Limit,url.QueryEscape(config.Base+config.Find))
//   final := formateTheDataByConfig(doOneAll)
//   // formateKeyValueList(final)
//   handleTemplate(final)
// } 

func formateKeyValueList(kvlist []KeyValue) {
  for _, element := range kvlist {
    fmt.Printf("%s=%s\n", element.Key, element.Value)
  }
}

func doTheDooot(base string, tail string) string {
  return strings.Replace(base+"."+tail, "..", ".",-1)
}

func upChar(whatever string) string {
  return strings.ToUpper(whatever)
}

// 
// Write the new structure here
// 
func getTheDataFromSomewhere(urlString string) []KeyValue {
  var newKeyValueList []KeyValue

  // urlString := fmt.Sprintf("%s:%s/search/%s/%s/%s",config.Host,config.Port,config.Type,config.Limit,url.QueryEscape(config.Base+config.Find))

  newKeyValueList = getURL(urlString)
  if len(newKeyValueList) == 0 {
    newKeyValueList = readJsonDataFile(config.Alternative)
    if len(newKeyValueList) == 0 {
      log.Fatal("error: no data found")
    }
  }
  return newKeyValueList
}

func formateTheDataByConfig(kvlist []KeyValue, freshConfig Conf) []KeyValue {
  
  var newKeyValueList []KeyValue
  
  fts := regexp.MustCompile("\\%[0-9]*$")
  Search := fts.ReplaceAllString(freshConfig.Find,"")
  Base := doTheDooot(freshConfig.Base, Search)

  r, _ := regexp.Compile(Base)

  for _, element := range kvlist {
    if ! r.MatchString(element.Key) {
      fmt.Println("not match ",Base ,element.Key,element.Value)
      continue
    }

    if Base != "" {
      element.Key = strings.Replace(element.Key, Base, "", 1)
    }

    element.Key = strings.ToUpper(element.Key)
    element.Key = strings.Replace(element.Key, ".", "_", -1)

    if freshConfig.Export {
      element.Key = "export "+element.Key
    }

    newKeyValueList = append(newKeyValueList,element)
  }
  return newKeyValueList
}

func jsonConsoleOutput(kvlist []KeyValue) {
  m, _ := json.Marshal(kvlist)
  fmt.Println( string( m ) )
}

// 
// Read/Get Data 
// 

func readConfig(filename string) Conf {
  file, _ := os.Open(filename)
  defer file.Close()
  decoder := json.NewDecoder(file)
  configuration := Conf{}
  err := decoder.Decode(&configuration)
  if err != nil {
    log.Fatal("error read config:", err)
  }
  // fmt.Println(configuration)
  // config = configuration
  return configuration
}

func getURL(url string) []KeyValue {
  // fmt.Println("start get url ",url)
  var newKeyValueList []KeyValue
  request := gorequest.New()
  resp, body, err := request.Get(url).End()
  if err != nil || resp.Status != "200 OK" {
    // fmt.Println("cant get urlString")
    return newKeyValueList
  }
  json.Unmarshal([]byte(body), &jsonContent)
  fmt.Println(jsonContent)
  return jsonContent
}

func readJsonDataFile(filename string) []KeyValue {
  var newKeyValueList []KeyValue
  file, err := os.Open(filename)
  if err != nil {
    return newKeyValueList
  }

  defer file.Close()  
  byteValue, _ := ioutil.ReadAll(file)

  json.Unmarshal(byteValue, &newKeyValueList)
  return newKeyValueList
}

func handleTemplate(kvlist []KeyValue, freshConfig Conf) {
  bigTemplateString := openTemplate(freshConfig)
  regVarTest, _ := regexp.Compile("\\${[A-Z_]+}")

  for _, element := range kvlist {
    seekKey := "${"+element.Key+"}"
    bigTemplateString = strings.Replace(bigTemplateString, seekKey, element.Value, -1) 
  }
  
  if regVarTest.MatchString(bigTemplateString) {
    log.Fatal("error:", "there are some discofans left here tonight")
  }

  if freshConfig.TemplateOut != "" {
    writeTempate(bigTemplateString, freshConfig)
  } else {
    fmt.Println(bigTemplateString)
  }  

}

func openTemplate(config Conf) string {
  bigTemplateString, err := ioutil.ReadFile(config.TemplateIn)
  if err != nil {
    log.Fatal("error open template ["+config.TemplateIn+"]", err)
  }
  return string(bigTemplateString)
}

func writeTempate(bigTemplateString string, config Conf) {
  err := ioutil.WriteFile(config.TemplateOut, []byte(bigTemplateString), 0644)
  if err != nil {
    log.Fatal("error write template: ",err)
  }
}