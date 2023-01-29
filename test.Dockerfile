FROM debian:11

ENV container docker
ARG DEBIAN_FRONTEND noninteractive

ARG PHP_VERSION=74
ARG OPENRESTY_VERSION=1.21.4.1
ARG MYSQL_VERSION=5.6
ARG PHPMYADMIN_VERSION=4.4.15
ARG MW_USERNAME=username
ARG MW_PASSWORD=password

COPY --chmod=755 ./rootfs /

# Enable systemd.
RUN apt-get update ; \
    apt-get install -y systemd systemd-sysv; \
    apt-get clean ; \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* ; \
    rm -rf /lib/systemd/system/multi-user.target.wants/* ; \
    rm -rf /etc/systemd/system/*.wants/* ; \
    rm -rf /lib/systemd/system/local-fs.target.wants/* ; \
    rm -rf /lib/systemd/system/sockets.target.wants/*udev* ; \
    rm -rf /lib/systemd/system/sockets.target.wants/*initctl* ; \
    rm -rf /lib/systemd/system/sysinit.target.wants/systemd-tmpfiles-setup* ; \
    rm -rf /lib/systemd/system/systemd-update-utmp*

# Installation panel
RUN apt update -y && \
    apt install -y curl procps wget unzip zip && \
    curl -fsSL https://raw.githubusercontent.com/midoks/mdserver-web/dev/scripts/install.sh | bash

# Installation php
RUN cd /www/server/mdserver-web/plugins/php && \
    bash install.sh install ${PHP_VERSION} && \
    systemctl enable php${PHP_VERSION}

# Installation nginx
RUN cd /www/server/mdserver-web/plugins/openresty && \
    bash install.sh install ${OPENRESTY_VERSION} && \
    systemctl enable openresty

# Installation mysql
RUN cd /www/server/mdserver-web/plugins/mysql && \
    bash install.sh install ${MYSQL_VERSION} && \
    systemctl enable mysql

# Installation phpmyadmin
RUN cd /www/server/mdserver-web/plugins/phpmyadmin && \
    bash install.sh install ${PHPMYADMIN_VERSION}

# Change Username Password Web Port
WORKDIR /www/server/mdserver-web
RUN /www/server/mdserver-web/bin/python tools.py username ${MW_USERNAME} && \
    /www/server/mdserver-web/bin/python tools.py panel ${MW_PASSWORD} && \
    echo 7200 > /www/server/mdserver-web/data/port.pl

WORKDIR /www

CMD ["/lib/systemd/systemd", "log-level=info", "unit=sysinit.target" ]

EXPOSE 7200 80 443 888

VOLUME [ "/www" ]
