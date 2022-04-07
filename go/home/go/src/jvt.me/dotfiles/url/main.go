package main

import (
	"encoding/json"
	"fmt"
	"io"
	"net/url"
	"os"
	"strings"
)

type UrlResponse struct {
	Base        string              `json:"base"`
	Uri         string              `json:"uri"`
	Path        string              `json:"path"`
	RawFragment string              `json:"rawFragment"`
	Query       map[string][]string `json:"query"`
	Fragment    map[string][]string `json:"fragment"`
}

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

func parse(s string) map[string][]string {
	if !strings.Contains(s, "&") {
		return make(map[string][]string)
	}

	q, err := url.ParseQuery(s)
	if err != nil {
		return make(map[string][]string)
	}
	return q
}

func main() {
	input_url_bytes, err := ArgfRead()
	if err != nil {
		os.Exit(1)
	}
	input_url := strings.TrimSuffix(string(input_url_bytes), "\n")
	if len(input_url) == 0 {
		os.Exit(1)
	}

	u, err := url.Parse(input_url)
	if err != nil {
		os.Exit(1)
	}

	query := parse(u.RawQuery)
	fragment := parse(u.Fragment)

	parsed := UrlResponse{
		Uri:         u.String(),
		Base:        u.Scheme + "://" + u.Hostname(),
		Path:        u.Path,
		RawFragment: u.Fragment,
		Query:       query,
		Fragment:    fragment,
	}

	r, err := json.MarshalIndent(parsed, "", "  ")
	if err != nil {
		os.Exit(1)
	}
	fmt.Println(string(r))
}
