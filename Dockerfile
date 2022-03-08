FROM golang:1.17-alpine AS builder

# 版本
ARG TAG=0.0.1

# 环境变量
ENV GO111MODULE=on
ENV GOPROXY=https://goproxy.cn,direct
ENV CGO_ENABLED=1
ENV GOARCH=amd64
ENV GOOS=linux

# 工作目录
ADD . /go/src/github.com/xlh001/jenkins-demo
WORKDIR /go/src/github.com/xlh001/jenkins-demo

# 编译
RUN go mod download
RUN go mod tidy -v
RUN go build -o demo_linux -ldflags "-w -s -X 'main.VERSION=$TAG' -X 'main.BUILD_TIME=`date`' -X 'main.GO_VERSION=`go version`'"
# 清理不需要的文件
RUN rm Dockerfile .gitignore go.mod go.sum main.go README.md
RUN rm -rf cache commands controllers converter .git .github graphics mail models routers utils tests

FROM alpine:latest
COPY --from=builder /go/src/github.com/xlh001/jenkins-demo /jenkins-demo
WORKDIR /jenkins-demo
EXPOSE 8080

ENTRYPOINT ['/bin/bash'.'./demo_linux']