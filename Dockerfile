# build image
FROM centos:7 AS buildimg

RUN yum install -y gcc make patch pcre-devel zlib-devel git && \
    cd /usr/src && \
    curl http://nginx.org/download/nginx-1.17.3.tar.gz | tar zxf - && \
    git clone https://github.com/chobits/ngx_http_proxy_connect_module && \
    cd nginx-1.17.3 && \
    cat ../ngx_http_proxy_connect_module/patch/proxy_connect_rewrite_101504.patch | patch -p1 && \
    ./configure --prefix=/usr/local/nginx --add-module=../ngx_http_proxy_connect_module && \
    make && \
    make install && \
    cd /usr/local/nginx && \
    rmdir logs && \
    mkdir /var/log/nginx && \
    ln -s /var/log/nginx logs
COPY nginx-whitelist.conf nginx-blacklist.conf /usr/local/nginx/conf/
COPY nginx-blacklist.conf /usr/local/nginx/conf/nginx.conf

# production image
FROM alpine
COPY --from=buildimg /usr/local/nginx /usr/local/nginx
RUN apk add --update pcre libc6-compat && \
    rm -rf /var/cache/apk/* && \
    mkdir /var/log/nginx && \
    cd /var/log/nginx && \
    ln -s /dev/stdout access.log && \
    ln -s /dev/stderr error.log
CMD /usr/local/nginx/sbin/nginx
EXPOSE 8888
VOLUME /var/log/nginx

