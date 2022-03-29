package main

import (
	"fmt"
	"io"
	"net/url"
	"os"
	"regexp"
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

func replace(s string) string {
	if len(s) == 0 {
		return "_"
	}
	pattern := regexp.MustCompile(`[^a-zA-Z0-9-]`)
	return pattern.ReplaceAllString(s, "_")
}

func main() {
	input_url_bytes, err := io.ReadAll(os.Stdin)
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

	sb := strings.Builder{}
	sb.WriteString(u.Host)
	sb.WriteString("/")
	sb.WriteString(replace(u.Path))
	if len(u.RawQuery) > 0 {
		sb.WriteString(replace("?"))
		sb.WriteString(replace(u.RawQuery))
	}
	if len(u.Fragment) > 0 {
		sb.WriteString(replace("?"))
		sb.WriteString(replace(u.Fragment))
	}
	sb.WriteString(".json")

	fmt.Println(sb.String())
}
