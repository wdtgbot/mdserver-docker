FROM ddsderek/mw:base

ARG PHP_VERSION=74
ARG MW_USERNAME=username
ARG MW_PASSWORD=password

# Installation php
RUN cd /www/server/mdserver-web/plugins/php && \
    bash install.sh install ${PHP_VERSION} && \
    systemctl enable php${PHP_VERSION}

# Change Username Password Web Port
WORKDIR /www/server/mdserver-web
RUN /www/server/mdserver-web/bin/python tools.py username ${MW_USERNAME} && \
    /www/server/mdserver-web/bin/python tools.py panel ${MW_PASSWORD} && \
    echo 7200 > /www/server/mdserver-web/data/port.pl

WORKDIR /www

CMD ["/lib/systemd/systemd", "log-level=info", "unit=sysinit.target" ]

EXPOSE 7200 80 443 888

VOLUME [ "/www" ]
