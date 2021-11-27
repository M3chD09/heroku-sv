FROM golang:1.16 AS go-build

WORKDIR /app

ARG CGO_ENABLED=0

RUN apt-get update \
    && apt-get install -y git upx \
    && git clone "https://github.com/shadowsocks/v2ray-plugin.git" \
    && cd v2ray-plugin \
    && VERSION=$(git describe --tags) \
    && go build -ldflags "-X main.VERSION=$VERSION -s -w -buildid=" -o "v2ray-plugin" \
    && upx -9 v2ray-plugin


FROM alpine:latest

LABEL maintainer="m3chd09 <m3chd09@protonmail.com>"

ARG SSVER=v1.12.3

RUN apk add --no-cache tar wget xz \
    && ss_file="shadowsocks-${SSVER}.x86_64-unknown-linux-musl.tar.xz" \
    && ss_url="https://github.com/shadowsocks/shadowsocks-rust/releases/download/${SSVER}/${ss_file}" \
    && wget $ss_url \
    && tar -C /usr/bin/ -xf $ss_file \
    && rm -f $ss_file

COPY --from=go-build /app/v2ray-plugin/v2ray-plugin /usr/bin/v2ray-plugin

CMD /usr/bin/ssserver -s "[::]:"$PORT -m "aes-256-gcm" -k $SS_PASSWORD --plugin "v2ray-plugin" --plugin-opts "server"
