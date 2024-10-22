FROM tykio/tyk-plugin-compiler:v5.2.1 AS build

USER root
RUN apt-get update
RUN apt-get -y install tree 

COPY go.mod go.sum plugin.go /plugin-source/

RUN mkdir -p /out 
WORKDIR /out
RUN /build.sh plugin.so && \
    echo $(pwd) && \
    tree -a ./

FROM scratch
COPY --from=build /out/plugin_v5.2.1_linux_amd64.so /
