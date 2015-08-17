FROM centos:6

# Install consul and ui; not much else going on here
RUN yum install -y wget \
 && yum install -y unzip \
 && wget -q https://dl.bintray.com/mitchellh/consul/0.5.2_linux_amd64.zip \
 && unzip 0.5.2_linux_amd64.zip \
 && rm -f 0.5.2_linux_amd64.zip \
 && mv consul /usr/bin/ \
 && wget -q https://dl.bintray.com/mitchellh/consul/0.5.2_web_ui.zip \
 && unzip 0.5.2_web_ui.zip \
 && rm -f 0.5.2_web_ui.zip \
 && mv dist ui \
 && mkdir /etc/consul.d /config /data

ADD config.json /config/config.json

CMD [ "consul", "help" ]
