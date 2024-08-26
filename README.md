# Nginx Forward Proxy

Nginx forward proxy settings using ```ngx_http_proxy_connect_module```.

## Nginx License

See https://nginx.org/LICENSE

## ngx_http_proxy_connect_module License

See https://github.com/chobits/ngx_http_proxy_connect_module

## Dockerfile License

It's just free. (Public Domain)

See https://github.com/yidigun/nginx-forward-proxy

## Supported OS/Arch

* ```linux/amd64```
* ```linux/arm64```

## Changelog

* 2024-08-26 - Upgrade nginx version and add documentation

## Use Image

You can choose only one config file of two:

* Opt-out (default) - [```/usr/local/nginx/conf/nginx-blacklist.conf```](https://github.com/yidigun/nginx-forward-proxy/blob/master/nginx-blacklist.conf)
* Opt-in - [```/usr/local/nginx/conf/nginx-whitelist.conf```](https://github.com/yidigun/nginx-forward-proxy/blob/master/nginx-whitelist.conf)

These files are shipped with this image, or you can download from GitHub.

```shell
# download blacklist.conf or whitelist.conf
curl -O https://raw.githubusercontent.com/yidigun/nginx-forward-proxy/master/nginx-blacklist.conf

# edit to customize
vim nginx-blacklist.conf

# Run container
docker run -d 
    -v nginx-blacklist.conf:/usr/local/nginx/conf/nginx.conf \
    yidigun/nginx-forward-proxy:latest
```
