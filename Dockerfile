FROM php:7.4.10-fpm-alpine

ENV PHPREDIS_VERSION 4.1.1
ENV PHPMONGODB_VERSION 1.5.2
ENV PHPPDOMYSQL_VERSION 1.0.2

RUN apk add --update \
    # redis \
    php5-mysql \
    gcc \
    g++ \
    make \
    libpng \
    autoconf \
    libpng-doc \
    libpng-utils \
    libpng-dev \
    libjpeg \
    libjpeg-turbo \
    libjpeg-turbo-doc \
		libjpeg-turbo-dev \
    libjpeg-turbo-utils \
    freetype \
		freetype-dev \
    freetype-doc \
		libwebp-dev \
		postgresql-dev \
    && rm -rf /var/cache/apk/* \
    && mkdir -p /usr/src/php/ext \
    && curl -L -o /tmp/redis.tar.gz https://github.com/weiwh/php-extension/raw/master/redis-$PHPREDIS_VERSION.tgz \
    && curl -L -o /tmp/mongodb.tar.gz https://github.com/weiwh/php-extension/raw/master/mongodb-$PHPMONGODB_VERSION.tgz \
    && curl -L -o /tmp/PDO_MYSQL.tar.gz https://github.com/weiwh/php-extension/raw/master/PDO_MYSQL-$PHPPDOMYSQL_VERSION.tgz \
    && tar zxvf /tmp/redis.tar.gz \
    && tar zxvf /tmp/mongodb.tar.gz \
    && tar zxvf /tmp/PDO_MYSQL.tar.gz \
    && pecl install xhprof-0.9.4 && docker-php-ext-enable xhprof \
    && mv redis-$PHPREDIS_VERSION /usr/src/php/ext/redis \
    && mv mongodb-$PHPMONGODB_VERSION /usr/src/php/ext/mongodb \
    && mv PDO_MYSQL-$PHPPDOMYSQL_VERSION /usr/src/php/ext/pdo_mysql \
    && docker-php-ext-install redis mongodb pdo_mysql zip iconv \
    && docker-php-ext-configure gd --with-webp-dir=/usr/include/ --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ --with-png-dir=/usr/include/ \
    && docker-php-ext-install gd \
    && docker-php-ext-configure bcmath \
    && docker-php-ext-install bcmath \
    && rm -r /tmp/redis.tar.gz \
    && rm -r /tmp/mongodb.tar.gz \
    && rm -r /tmp/PDO_MYSQL.tar.gz \
    && rm -rf /usr/src/php

CMD ["php-fpm","-R" ,"--nodaemonize"]

EXPOSE 9000 

WORKDIR /code
