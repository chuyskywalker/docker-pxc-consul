FROM centos:6

# Install requisits
RUN yum install -y epel-release \
 && yum install -y http://www.percona.com/downloads/percona-release/redhat/0.1-3/percona-release-0.1-3.noarch.rpm \
 && yum install -y Percona-XtraDB-Cluster-56 \
 && yum install -y which \
 && yum install -y qpress

# Get the start.sh ready and able
ADD start.sh /start.sh
RUN chmod +x /start.sh

# During build, install sst and monitoring users
# TODO: This priviledge set is waaaaay too much, but for demo purposes works
RUN /etc/init.d/mysql start \
 && mysql -uroot -e "GRANT ALL ON *.* TO 'sstuser'@'localhost' IDENTIFIED BY 's3cret';" \
 && mysql -uroot -e "GRANT ALL ON *.* TO 'monitor'@'%'         IDENTIFIED BY 's3cret';" \
 && /etc/init.d/mysql stop

# How we roll, bruh
CMD [ "/start.sh" ]
