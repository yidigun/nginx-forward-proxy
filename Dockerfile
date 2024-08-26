FROM docker.io/yidigun/ubuntu-build:24.04 AS build

ARG IMG_TAG=1.27.1
ENV IMG_TAG=$IMG_TAG

RUN apt-get -y update && \
    DEBIAN_FRONTEND=noninteractive \
        apt-get -y install libpcre3-dev zlib1g-dev && \
    apt-get clean && \
    mkdir /tmp/nginx && \
    cd /tmp/nginx && \
    curl https://nginx.org/download/nginx-${IMG_TAG}.tar.gz | \
        tar zxf - && \
    git clone https://github.com/chobits/ngx_http_proxy_connect_module.git && \
    cd nginx-${IMG_TAG} && \
    cat ../ngx_http_proxy_connect_module/patch/proxy_connect_rewrite_102101.patch | \
        patch -p1 && \
    ./configure --prefix=/usr/local/nginx --add-module=../ngx_http_proxy_connect_module && \
    make && \
    make install

COPY nginx-whitelist.conf nginx-blacklist.conf /usr/local/nginx/conf/
COPY nginx-blacklist.conf /usr/local/nginx/conf/nginx.conf

FROM docker.io/library/alpine:latest AS product

ARG PROXY_PORT=8888
ENV PROXY_PORT=$PROXY_PORT

RUN apk add --update pcre libc6-compat && \
    rm -rf /var/cache/apk/*

COPY --from=build /usr/local/nginx /usr/local/nginx

EXPOSE ${PROXY_PORT}/tcp

CMD [ "/usr/local/nginx/sbin/nginx" ]

