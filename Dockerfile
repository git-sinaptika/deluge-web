#Maintainer info@sinaptika.net
#deluge http://deluge-torrent.org/
#deluge-web image
FROM alpine:3.5

ENV \
 DELUGE_VERSION=1.3.14 \
 D_DIR=/opt/deluge \
 TZ=Europe/Ljubljana \
 D_UID=1000 \
 D_GID=1000 \
 D_USER=deluge \
 D_GROUP=deluge \
 D_LOG_LEVEL=info \
 D_W_PORT=8112

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

RUN \
 apk add --no-cache \
  tzdata tini \
  openssl boost zlib geoip \
  py-setuptools py2-pip py2-openssl py2-chardet py-twisted \
  py-mako intltool && \
 apk add --no-cache \
  --repository http://dl-cdn.alpinelinux.org/alpine/edge/main \
  --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
  libtorrent-rasterbar && \
 pip install --no-cache-dir \
  service_identity && \
 cd /root && \
 wget -qO- \
  http://download.deluge-torrent.org/source/deluge-${DELUGE_VERSION}.tar.gz | tar xz && \
 cd \
  deluge-${DELUGE_VERSION}/ && \
 python setup.py -q build && \
 python setup.py -q install && \
 apk del \
  boost geoip py2-pip openssl libtorrent-rasterbar intltool && \
 rm -rf \
  /usr/lib/python2.7/site-packages/deluge-1.3.14-py2.7.egg/share/* \
  /usr/lib/python2.7/site-packages/deluge-1.3.14-py2.7.egg/deluge/data/pixmaps/* \
  /usr/lib/python2.7/site-packages/deluge-1.3.14-py2.7.egg/deluge/ui/gtkui/* \
  /usr/lib/python2.7/site-packages/deluge-1.3.14-py2.7.egg/deluge/ui/console/* \
  /usr/lib/python2.7/site-packages/deluge-1.3.14-py2.7.egg/deluge/ui/i18n/* \
  /usr/bin/deluge /usr/bin/deluged /usr/bin/deluge-gtk && \
 rm -rf \
  /root/*. && \
 chown -R ${D_USER}:${D_GROUP} \
  ${D_DIR}

EXPOSE \
 ${D_W_PORT}

ENTRYPOINT \
 ["/sbin/tini", "--"]
CMD \
 ["/usr/bin/deluge-web", "-c", "/opt/deluge", "-l", "/opt/deluge/deluge-web.log", "-L", "warn"]

LABEL \
 net.sinaptika.maintainer="info@sinaptika.net" \
 net.sinaptika.name="deluge-web" \
 net.sinaptika.branch="master" \
 net.sinaptika.from="alpine:3.5" \
 c_software_name="Deluge-web interface" \
 c_software_url="http://deluge-torrent.org/" \
 image.version="0.2" \
 date.version="6.5.2017" \
 web_interface=true \
 web_interface_port=${D_W_PORT} \
 exposed_ports=${D_W_PORT} \
 docker_volumes=${D_DIR}
