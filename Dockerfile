FROM tykio/tyk-plugin-compiler:v5.3.5 AS build

COPY go.mod go.sum plugin.go /plugin-source/

RUN mkdir -p /bundle
RUN /build.sh plugin.so && \
    ls /plugin-source/ && \
    mv /plugin-source/plugin_v5.3.5_linux_amd64.so /bundle/

FROM tykio/tyk-gateway:v5.3.5 AS bundle

SHELL ["/usr/bin/sh", "-c"]
RUN mkdir -p /bundle
WORKDIR /bundle
COPY --from=build /bundle/plugin_v5.3.5_linux_amd64.so ./
RUN /opt/tyk-gateway/tyk bundle build -output bundle-latest.zip

FROM scratch
COPY --from=bundle /bundle/bundle-latest.zip /
