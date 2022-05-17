//go:generate oapi-codegen -generate types --package=main  -o ./bitly.gen.go https://dev.bitly.com/v4/v4.json

package main

import (
	"encoding/json"
	"fmt"
	"io"
	"io/ioutil"
	"net/http"
	"os"
	"strings"

	"github.com/spf13/viper"
)

const (
	API_URL = "https://api-ssl.bitly.com/v4/shorten"
)

func ArgfRead() (string, error) {
	var bytes []byte
	var err error

	if len(os.Args) >= 2 {
		bytes, err = os.ReadFile(os.Args[1])
	} else {
		bytes, err = io.ReadAll(os.Stdin)
	}

	if err != nil {
		return "", err
	}
	return strings.TrimSuffix(string(bytes), "\n"), nil
}

func main() {
	viper.SetConfigName("config")
	viper.SetConfigType("toml")
	viper.AddConfigPath("$HOME/.config/bitly")
	err := viper.ReadInConfig()
	if err != nil {
		panic(fmt.Errorf("Fatal error config file: %w \n", err))
	}
	if !viper.IsSet("access_token") {
		panic(fmt.Errorf("No access_token set"))
	}

	url, err := ArgfRead()
	if err != nil {
		panic(err)
	}
	shortenBody := Shorten{
		LongUrl: url,
	}
	bytes, err := json.Marshal(shortenBody)
	if err != nil {
		panic(err)
	}

	payload := strings.NewReader(string(bytes))

	req, _ := http.NewRequest("POST", API_URL, payload)

	req.Header.Add("Content-Type", "application/json")
	req.Header.Add("Authorization", "Bearer "+viper.GetString("access_token"))

	res, err := http.DefaultClient.Do(req)
	if err != nil {
		panic(err)
	}

	defer res.Body.Close()
	body, err := ioutil.ReadAll(res.Body)
	if err != nil {
		panic(err)
	}

	if 200 != res.StatusCode {
		panic(fmt.Errorf("HTTP %d returned, with body: %s", res.StatusCode, string(body)))
	}

	var response BitlinkUpdate
	err = json.Unmarshal(body, &response)
	if err != nil {
		panic(err)
	}

	fmt.Println(*response.Link)
}
