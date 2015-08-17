#!/bin/bash

set -x

# At runtime, inject this health check with the correct ip
# TODO: the user/pass could be env'ed, but for demo this will suffice
# Note: The "|| exit 2" is required to translate this check from a "warn"
#       to a "fail" for consul (otherwise it's error code 1, which consul
#       treats as a warning sign instead)
cat <<EOF > /etc/consul.d/pxc.json
{
  "service": {
    "name": "pxc",
    "id": "pxc$ID",
    "tags": ["pxc", "pxc$ID"],
    "address": "$IP",
    "port": 3306,
    "check": {
      "script": "mysql -h $IP -umonitor -ps3cret -e \"show status like 'wsrep%';\" || exit 2",
      "interval": "2s"
    }
  }
}
EOF

# Now replace this shell with the consul agent who will join the `consulserver` cluster
exec consul agent -data-dir /tmp/consul -config-dir /etc/consul.d -join consulserver
