#Maintainer info@sinaptika.net
#deluge http://deluge-torrent.org/
#deluge-web image
FROM sinaptika/libtorrent:1.1.4 as builder_libtorrent

FROM alpine:3.6

#Enviroment variables for building the image.
#Enviroment variables for running the container.
#Pass at docker create or docker run (-e VARIABLE=value).
ENV \
    DELUGE_VERSION="2.0b1" \
    LIBTORRENT_VERSION="1.1.4" \
    LIBTORRENT_SO="9" \
    D_DIR="/opt/deluge" \
    D_USER="deluge" \
    D_GROUP="deluge" \
    D_W_PORT="8112" \
    D_W_LOG_LEVEL="info" \
    D_UID="1000" \
    D_GID="1000" \
    TZ="Europe/London"

#Create directory structure and add user:group.
RUN \
    mkdir -p \
        ${D_DIR} \
        ${D_DIR}/config && \
    addgroup -g \
        ${D_GID} -S ${D_GROUP} && \
    adduser \
        -h ${D_DIR} \
        -g "Deluge system user" \
        -G ${D_GROUP} \
        -S -D \
        -u ${D_UID} ${D_USER}

#Copy libtorrent-rasterbar from sinaptika/libtorrent
#Can't use old libtorrent from repo, this or we need to compile
COPY \
    --from=builder_libtorrent \
        /usr/lib/libtorrent-rasterbar.la \
        /usr/lib/libtorrent-rasterbar.so.${LIBTORRENT_SO}.0.0 \
        /usr/lib/

#Copy python bindings from sinaptika/libtorrent
COPY \
    --from=builder_libtorrent \
        /usr/lib/python2.7/site-packages/libtorrent.so \
        /usr/lib/python2.7/site-packages/python_libtorrent-${LIBTORRENT_VERSION}-py2.7.egg-info \
        /usr/lib/python2.7/site-packages/

#Copy pkgconfig
COPY \
    --from=builder_libtorrent \
        /usr/lib/pkgconfig/libtorrent-rasterbar.pc \
        /usr/lib/pkgconfig/
#deluge-web and system dependancies
#Pulling libtorrent from repo, to satsify build dependancy
#Clean-up and first run (to generate ssl cert)
RUN \
    ln -s /usr/lib/libtorrent-rasterbar.so.${LIBTORRENT_SO}.0.0 /usr/lib/libtorrent-rasterbar.so && \
    ln -s /usr/lib/libtorrent-rasterbar.so.${LIBTORRENT_SO}.0.0 /usr/lib/libtorrent-rasterbar.so.${LIBTORRENT_SO} && \
    ldconfig -n -v /usr/lib && \
    apk add --no-cache --virtual .system \
        tzdata tini && \
    apk add --no-cache --virtual .build \
        git boost geoip py2-pip openssl intltool && \
    apk add --no-cache --virtual .runtime \
        zlib py-setuptools py2-openssl py2-chardet py-twisted py-mako && \
    pip install --no-cache-dir \
        slimit automat pyxdg service_identity incremental constantly packaging && \
    cd /root && \
    git clone git://deluge-torrent.org/deluge.git && \
    cd deluge && \
    git checkout tags/deluge-${DELUGE_VERSION} && \
    python setup.py -q build && \
    python setup.py -q install && \
    /usr/bin/deluge-web \
        -f --ssl -c ${D_DIR}/config -l ${D_DIR}/config/deluge-web-init.log -L debug && \
    sleep 10 && \
    pkill -15 python && \
    apk del \
        .build && \
    rm -rf \
        /usr/lib/python2.7/site-packages/deluge-${DELUGE_VERSION}-py2.7.egg/share/* \
        /usr/lib/python2.7/site-packages/deluge-${DELUGE_VERSION}-py2.7.egg/deluge/data/pixmaps/* \
        /usr/lib/python2.7/site-packages/deluge-${DELUGE_VERSION}-py2.7.egg/deluge/ui/gtkui/* \
        /usr/lib/python2.7/site-packages/deluge-${DELUGE_VERSION}-py2.7.egg/deluge/ui/console/* \
        /usr/lib/python2.7/site-packages/deluge-${DELUGE_VERSION}-py2.7.egg/deluge/ui/i18n/* \
        /usr/bin/deluge /usr/bin/deluged /usr/bin/deluge-gtk && \
    cd && \
    rm -rf \
        /root/* && \
    chown -R ${D_USER}:${D_GROUP} \
        ${D_DIR}

EXPOSE \
    ${D_W_PORT}

USER \
    ${D_USER}
ENTRYPOINT \
    ["/sbin/tini", "--"]
CMD \
    ["/usr/bin/deluge-web", "-c", "/opt/deluge/config", "-l", "/opt/deluge/config/deluge-web.log", "-L", "info"]

LABEL \
    net.sinaptika.maintainer="info@sinaptika.net" \
    net.sinaptika.name="deluge-web" \
    net.sinaptika.branch="master" \
    net.sinaptika.from="alpine:3.6" \
    c_software_name="Deluge-web interface" \
    c_software_url="http://deluge-torrent.org/" \
    image.version="0.5" \
    date.version="12.10.2017" \
    web_interface=true \
    web_interface_port=${D_W_PORT} \
    exposed_ports=${D_W_PORT} \
    docker_volumes=${D_DIR}
