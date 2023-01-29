FROM ddsderek/mw:base

ARG OPENRESTY_VERSION=1.21.4.1
ARG MW_USERNAME=username
ARG MW_PASSWORD=password

# Installation nginx
RUN cd /www/server/mdserver-web/plugins/openresty && \
    bash install.sh install ${OPENRESTY_VERSION} && \
    systemctl enable openresty

# Change Username Password Web Port
WORKDIR /www/server/mdserver-web
RUN /www/server/mdserver-web/bin/python tools.py username ${MW_USERNAME} && \
    /www/server/mdserver-web/bin/python tools.py panel ${MW_PASSWORD} && \
    echo 7200 > /www/server/mdserver-web/data/port.pl

WORKDIR /www

CMD ["/lib/systemd/systemd", "log-level=info", "unit=sysinit.target" ]

EXPOSE 7200 80 443 888

VOLUME [ "/www" ]
