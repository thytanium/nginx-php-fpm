FROM alpine:3.10

RUN apk update && apk add php7 php7-fpm php7-xml php7-xmlreader php7-xmlwriter \
    php7-session php7-mbstring php7-mcrypt php7-pdo php7-pdo_mysql php7-curl \
    php7-openssl php7-dom php7-tokenizer php7-zip php7-zlib php7-simplexml \
    php7-phar php7-gd php7-iconv php7-json php7-ctype php7-fileinfo \
    nginx supervisor

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php \
    && php -r "unlink('composer-setup.php');"

ADD ./conf/vhost.conf /etc/nginx/conf.d/default.conf
ADD ./conf/supervisord.conf /etc/supervisord.conf
ADD ./conf/php-fpm.conf /etc/php7/php-fpm.conf
ADD ./conf/php-fpm-www.conf /etc/php7/php-fpm.d/www.conf

RUN mkdir /run/nginx
RUN mkdir /var/log/supervisord

WORKDIR /var/www/html

EXPOSE 80

ENTRYPOINT ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
