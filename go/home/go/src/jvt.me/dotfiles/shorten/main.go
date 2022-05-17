//go:generate oapi-codegen -generate types,client --package=main  -o ./bitly.gen.go https://dev.bitly.com/v4/v4.json

package main

import (
	"context"
	"fmt"
	"io"
	"os"
	"strings"

	"github.com/deepmap/oapi-codegen/pkg/securityprovider"
	"github.com/spf13/viper"
)

const (
	API_URL = "https://api-ssl.bitly.com/v4"
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
	bearerTokenProvider, err := securityprovider.NewSecurityProviderBearerToken(viper.GetString("access_token"))
	if err != nil {
		panic(err)
	}

	url, err := ArgfRead()
	if err != nil {
		panic(err)
	}
	shortenBody := CreateBitlinkJSONRequestBody{
		LongUrl: url,
	}

	client, err := NewClientWithResponses(API_URL, WithRequestEditorFn(bearerTokenProvider.Intercept))
	if err != nil {
		panic(err)
	}

	req, err := client.CreateBitlinkWithResponse(context.Background(), shortenBody)
	if err != nil {
		panic(err)
	}

	if req.StatusCode() != 200 {
		panic(fmt.Errorf("failed to create Bitlink: HTTP %d", req.StatusCode()))
	}

	fmt.Println(*req.JSON200.Link)
}
