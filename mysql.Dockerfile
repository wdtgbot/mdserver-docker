FROM ddsderek/mw:base

ARG MYSQL_VERSION=5.6
ARG MW_USERNAME=username
ARG MW_PASSWORD=password

# Installation mysql
RUN cd /www/server/mdserver-web/plugins/mysql && \
    bash install.sh install ${MYSQL_VERSION} && \
    systemctl enable mysql

# Change Username Password Web Port
WORKDIR /www/server/mdserver-web
RUN /www/server/mdserver-web/bin/python tools.py username ${MW_USERNAME} && \
    /www/server/mdserver-web/bin/python tools.py panel ${MW_PASSWORD} && \
    echo 7200 > /www/server/mdserver-web/data/port.pl

WORKDIR /www

CMD ["/lib/systemd/systemd", "log-level=info"]

EXPOSE 7200 80 443 888

VOLUME [ "/www" ]
