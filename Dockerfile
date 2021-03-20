FROM alpine:latest

LABEL maintainer="m3chd09 <m3chd09@protonmail.com>"

RUN apk add --no-cache \
    tar \
    wget \
    xz \
    && ss_version="$(wget --no-check-certificate -qO- https://api.github.com/repos/shadowsocks/shadowsocks-rust/releases/latest | grep 'tag_name' | cut -d\" -f4)" \
    && v2_version="$(wget --no-check-certificate -qO- https://api.github.com/repos/shadowsocks/v2ray-plugin/releases/latest | grep 'tag_name' | cut -d\" -f4)" \
    && ss_file="shadowsocks-${ss_version}.x86_64-unknown-linux-musl.tar.xz" \
    && v2_file="v2ray-plugin-linux-amd64-${v2_version}.tar.gz" \
    && ss_url="https://github.com/shadowsocks/shadowsocks-rust/releases/download/${ss_version}/${ss_file}" \
    && v2_url="https://github.com/shadowsocks/v2ray-plugin/releases/download/${v2_version}/${v2_file}" \
    && wget $ss_url \
    && tar -C /usr/bin/ -xf $ss_file \
    && wget $v2_url \
    && tar xf $v2_file \
    && mv v2ray-plugin_linux_amd64 /usr/bin/v2ray-plugin \
    && rm -f $ss_file $v2_file

CMD /usr/bin/ssserver -s "[::]:"$PORT -m "aes-256-gcm" -k $SS_PASSWORD --plugin "v2ray-plugin" --plugin-opts "server"
