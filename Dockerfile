FROM tykio/tyk-plugin-compiler:v5.2.1 AS build

COPY go.mod go.sum plugin.go /plugin-source/

RUN /build.sh /out/plugin.so

FROM scratch
COPY --from=build /out/plugin.so /
