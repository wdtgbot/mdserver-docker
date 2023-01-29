FROM ddsderek/mw:base

ARG PHP_VERSION=74
ARG OPENRESTY_VERSION=1.21.4.1
ARG MYSQL_VERSION=5.6
ARG PHPMYADMIN_VERSION=4.4.15
ARG MW_USERNAME=username
ARG MW_PASSWORD=password

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
