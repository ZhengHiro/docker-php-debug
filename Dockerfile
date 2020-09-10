FROM php:7.4-fpm

RUN apt-get update && apt-get install -y \
        --no-install-recommends libfreetype6-dev libjpeg62-turbo-dev libpng-dev curl \
        && rm -r /var/lib/apt/lists/* \
        && docker-php-ext-configure gd \
        && docker-php-ext-install -j$(nproc) gd opcache pdo_mysql gettext sockets

RUN pecl install redis \
    && docker-php-ext-enable redis

CMD ["php-fpm","-R" ,"--nodaemonize"]

EXPOSE 9000

WORKDIR /code
