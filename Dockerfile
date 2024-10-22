FROM tykio/tyk-plugin-compiler:v5.2.1 AS build

COPY go.mod go.sum plugin.go /plugin-source/

RUN mkdir -p /out
WORKDIR /out
RUN /build.sh plugin.so

FROM scratch
COPY --from=build /out/plugin_v5.2.1_linux_amd64.so /
