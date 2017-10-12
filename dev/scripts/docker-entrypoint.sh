#!/bin/sh
# Deluge-web entrypoint
# Using ENV set at "docker run -e"
# or "docker create -e"
# info@sinaptika.net

set -e

export TZ=${TZ}

exec /sbin/su-exec \
 ${D_UID}:${D_GID} \
  /sbin/tini -- \
   /usr/bin/deluge-web \
    --config=${D_DIR}/config \
    --port=${D_W_PORT} \
    --logfile=${D_DIR}/config/deluge-web.log \
    --loglevel ${D_W_LOG_LEVEL}

"/usr/bin/deluge-web", "--ssl", "-c", "/opt/deluge/config", "-l", "/opt/deluge/config/deluge-web.log", "-L", "warn"
