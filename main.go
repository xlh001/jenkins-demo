package main

import (
	_ "jenkins-demo/routers"

	beego "github.com/beego/beego/v2/server/web"
)

func main() {
	beego.Run()
}
