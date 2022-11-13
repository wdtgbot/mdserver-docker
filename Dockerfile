FROM debian:10.12-slim

STOPSIGNAL SIGRTMIN+3

RUN rm -f /lib/systemd/system/multi-user.target.wants/* \
  /etc/systemd/system/*.wants/* \
  /lib/systemd/system/local-fs.target.wants/* \
  /lib/systemd/system/sockets.target.wants/*udev* \
  /lib/systemd/system/sockets.target.wants/*initctl* \
  /lib/systemd/system/sysinit.target.wants/systemd-tmpfiles-setup* \
  /lib/systemd/system/systemd-update-utmp*

# 安装面板
RUN curl -fsSL  https://raw.githubusercontent.com/midoks/mdserver-web/dev/scripts/install_dev.sh | bash

# 更改用户名密码
RUN cd /www/server/mdserver-web/ && \
    /www/server/mdserver-web/bin/python tools.py username username && \
    cd /www/server/mdserver-web/ && \
    /www/server/mdserver-web/bin/python tools.py panel password

# 安装 php nginx mysql phpmyadmin
RUN cd /www/server/mdserver-web/plugins/php && \
    bash install.sh install 74 && \
    cd /www/server/mdserver-web/plugins/openresty && \
    bash install.sh install 1.21.4.1 && \
    cd /www/server/mdserver-web/plugins/mysql && \
    bash install.sh install 5.6 && \
    cd /www/server/mdserver-web/plugins/phpmyadmin && \
    bash install.sh install 4.4.15 && \
    systemctl enable openresty && \
    systemctl enable php74 && \
    systemctl enable mysql

RUN rm -rf /www/server/mysql/data

#ADD ./start.sh /start.sh
#ADD start.service /usr/lib/systemd/system/start.service
#RUN systemctl enable start

CMD [ "/lib/systemd/systemd", "log-level=info", "unit=sysinit.target" ]

EXPOSE 7200 80 443 888

VOLUME [ "/www" ]
