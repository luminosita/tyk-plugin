FROM tykio/tyk-plugin-compiler:v5.2.1 AS build

RUN go get -u github.com/TykTechnologies/tyk-cli

COPY go.mod go.sum plugin.go /plugin-source/

RUN mkdir -p /bundle

RUN /build.sh plugin.so && \
    ls /plugin-source/ && \
    mv /plugin-source/plugin_v5.2.1_linux_amd64.so /bundle

WORKDIR /bundle
RUN tyk-cli bundle build -output bundle-latest.zip

FROM scratch
COPY --from=build /bundle/bundle-latest.zip /
