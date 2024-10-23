FROM tykio/tyk-plugin-compiler:v5.6.1 AS build

COPY go.mod go.sum plugin.go /plugin-source/

RUN /build.sh plugin.so && \
    ls /plugin-source/ 

FROM tykio/tyk-gateway:v5.6.1 AS bundle

RUN mkdir -p /bundle
WORKDIR /bundle
COPY --from=build /plugin-source/plugin_v5.6.1_linux_amd64.so ./
RUN tyk-cli bundle build -output bundle-latest.zip

FROM scratch
COPY --from=bundle /bundle/bundle-latest.zip /
