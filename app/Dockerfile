FROM centos:6

RUN yum install -y php-cli
RUN yum install -y php-mysql
RUN mkdir /app
WORKDIR /app
RUN curl -sS https://getcomposer.org/installer | php
RUN php composer.phar init --require=react/http:0.3.* -n
RUN php composer.phar install --no-dev --prefer-dist

ADD app.php /app/app.php

CMD [ "php", "/app/app.php" ]