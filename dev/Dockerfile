#Maintainer info@sinaptika.net
#deluge http://deluge-torrent.org/
#deluge-web image
FROM alpine:3.6

ENV \
#Enviroment variables for building the image.
 DELUGE_VERSION="1.3.15" \
 D_DIR="/opt/deluge" \
 D_USER="deluge" \
 D_GROUP="deluge" \
 D_W_PORT="8112" \
 D_W_LOG_LEVEL="warn" \
 D_UID="1000" \
 D_GID="1000" \
#Enviroment variables for running the container.
#Pass at docker create or docker run (-e VARIABLE=value).
 TZ="Europe/London"

RUN \
#Create directory structure and add user:group.
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

RUN \
#deluge-web and system dependencies
 apk add --no-cache --virtual .system \
  tzdata tini su-exec && \
 apk add --no-cache --virtual .build \
  boost geoip py2-pip openssl intltool && \
#Pulling old libtorrent from repo, to satsify dependancies during build
 apk add --no-cache --virtual .libtorrent \
 --repository http://dl-cdn.alpinelinux.org/alpine/edge/main \
 --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
  libtorrent-rasterbar && \
 apk add --no-cache --virtual .runtime \
  zlib py-setuptools py2-openssl py2-chardet py-twisted py-mako && \
 pip install --no-cache-dir \
  automat pyxdg service_identity incremental constantly packaging && \
 cd /root && \
 wget -qO- \
  http://download.deluge-torrent.org/source/deluge-${DELUGE_VERSION}.tar.gz | tar xz && \
 cd \
  deluge-${DELUGE_VERSION}/ && \
 python setup.py -q build && \
 python setup.py -q install && \
#Need to move this to entrypoint,
#so certificate gets created on run, not on build
# /usr/bin/deluge-web \
#  --ssl --fork  \
#  --config=${D_DIR}/config \
#  --logfile=/opt/deluge/config/first_init.log \
#  --loglevel=debug && \
# sleep 5 && \
# pkill -TERM python && \
#Cleanup.
 apk del \
  .libtorrent .build && \
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
 ["/usr/bin/deluge-web", "--ssl", "-c", "/opt/deluge/config", "-l", "/opt/deluge/config/deluge-web.log", "-L", "warn"]

LABEL \
 net.sinaptika.maintainer="info@sinaptika.net" \
 net.sinaptika.name="deluge-web" \
 net.sinaptika.branch="master" \
 net.sinaptika.from="alpine:3.6" \
 c_software_name="Deluge-web interface" \
 c_software_url="http://deluge-torrent.org/" \
 image.version="0.4" \
 date.version="27.8.2017" \
 web_interface=true \
 web_interface_port=${D_W_PORT} \
 exposed_ports=${D_W_PORT} \
 docker_volumes=${D_DIR}