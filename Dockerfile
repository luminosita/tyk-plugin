FROM tykio/tyk-plugin-compiler:v5.6.1 AS build

COPY go.mod go.sum plugin.go /plugin-source/

RUN /build.sh plugin.so && \
    ls /plugin-source/ 

FROM golang:1.23 AS bundle

RUN go install github.com/TykTechnologies/tyk-cli@latest

WORKDIR /usr/src/app

COPY --from=build /plugin-source/plugin_v5.6.1_linux_amd64.so ./
RUN tyk-cli bundle build -output bundle-latest.zip

FROM scratch
COPY --from=bundle /tmp/bundle/bundle-latest.zip /
