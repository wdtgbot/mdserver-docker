# MW Docker
latest默认安装 ```OpenResty 1.21.4.1``` ```PHP-74``` ```MySQL 5.6``` ```phpMyAdmin 4.4.15```

不支持目录挂载，请使用volume的方式存储文件 

容器内数据目录```/www```

默认账号 username

密码 password

Web端口 7200

docker-cli
```
docker run -itd \
    --name mw \
    --privileged=true \
    -p 7200:7200 \
    -p 80:80 \
    -p 443:443 \
    -p 888:888 \
    ddsderek/mw:latest
```
docker-compose
```
version: '3.3'
services:
    mw-server:
        container_name: mw
        privileged: true
        ports:
            - '7200:7200'
            - '80:80'
            - '443:443'
            - '888:888'
        image: 'ddsderek/mw:latest'
```
