FROM alpine:latest

LABEL maintainer="m3chd09 <m3chd09@protonmail.com>"

ARG SSVER=v1.11.2
ARG V2VER=v1.3.1

RUN apk add --no-cache tar wget xz \
    && ss_file="shadowsocks-${SSVER}.x86_64-unknown-linux-musl.tar.xz" \
    && v2_file="v2ray-plugin-linux-amd64-${V2VER}.tar.gz" \
    && ss_url="https://github.com/shadowsocks/shadowsocks-rust/releases/download/${SSVER}/${ss_file}" \
    && v2_url="https://github.com/shadowsocks/v2ray-plugin/releases/download/${V2VER}/${v2_file}" \
    && wget $ss_url \
    && tar -C /usr/bin/ -xf $ss_file \
    && wget $v2_url \
    && tar xf $v2_file \
    && mv v2ray-plugin_linux_amd64 /usr/bin/v2ray-plugin \
    && rm -f $ss_file $v2_file

CMD /usr/bin/ssserver -s "[::]:"$PORT -m "aes-256-gcm" -k $SS_PASSWORD --plugin "v2ray-plugin" --plugin-opts "server"
