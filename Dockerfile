ARG PROXY_PORT=8888

FROM docker.io/library/centos:7 AS build

RUN yum install -y gcc make patch pcre-devel zlib-devel git && \
    cd /usr/src && \
    curl http://nginx.org/download/nginx-1.17.3.tar.gz | tar zxf - && \
    git clone https://github.com/chobits/ngx_http_proxy_connect_module && \
    cd nginx-1.17.3 && \
    cat ../ngx_http_proxy_connect_module/patch/proxy_connect_rewrite_101504.patch | patch -p1 && \
    ./configure --prefix=/usr/local/nginx --add-module=../ngx_http_proxy_connect_module && \
    make && \
    make install

COPY nginx-whitelist.conf nginx-blacklist.conf /usr/local/nginx/conf/
COPY nginx-blacklist.conf /usr/local/nginx/conf/nginx.conf

FROM docker.io/library/alpine:3 AS product

ENV PROXY_PORT=$PROXY_PORT

RUN apk add --update pcre libc6-compat && \
    rm -rf /var/cache/apk/*

COPY --from=build /usr/local/nginx /usr/local/nginx

EXPOSE $PROXY_PORT/tcp

CMD /usr/local/nginx/sbin/nginx
