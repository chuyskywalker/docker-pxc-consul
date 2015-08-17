#!/bin/bash

set -x

# Reconfigure the DNS to use consul
echo "nameserver "$(grep consulserver /etc/hosts | awk '{print $1}') > /etc/resolv.conf

# See if there are other nodes to join
nslookup pxc.service.consul
if [ $? -eq 0 ]; then
  ADDR=pxc.service.consul
else
  ADDR=
fi

# Configure PXC (this is done at run time to see if the PXC service is ready for joiners vs. a boot strapper)
echo '[mysqld]
user                            = mysql
default_storage_engine          = InnoDB
basedir                         = /usr
datadir                         = /var/lib/mysql
socket                          = /var/lib/mysql/mysql.sock
port                            = 3306

innodb_autoinc_lock_mode        = 2
log_queries_not_using_indexes   = 1
max_allowed_packet              = 128M
binlog_format                   = ROW

wsrep_provider                  = /usr/lib64/libgalera_smm.so
wsrep_cluster_name              = "pxcfun"
wsrep_cluster_address           = gcomm://'$ADDR'
wsrep_slave_threads             = 4
wsrep_sst_method                = xtrabackup-v2
wsrep_sst_auth                  = "sstuser:s3cret"

[sst]
streamfmt                       = xbstream

[xtrabackup]
compress
compact
parallel                        = 2
compress_threads                = 2
rebuild_threads                 = 2

' > /etc/my.cnf

exec mysqld
