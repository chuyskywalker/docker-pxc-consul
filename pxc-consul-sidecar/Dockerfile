FROM consul

# Add mysql for health checking
RUN yum install -y mysql

ADD start.sh /start.sh
RUN chmod +x /start.sh

CMD [ "/start.sh" ]
