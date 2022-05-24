package main

import (
	"fmt"
	"os"
	"regexp"
)

func main() {
	var re = regexp.MustCompile(`content/posts/([\d]+)-([\d]+)-([\d]+)-(.*)\.md`)
	fmt.Println(re.ReplaceAllString(os.Args[1], "https://www.jvt.me/posts/$1/$2/$3/$4/"))
}
