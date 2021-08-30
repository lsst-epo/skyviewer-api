# FROM php:7.2-fpm-alpine3.11

# LABEL maintainer="erosas@lsst.org"

# USER root

# RUN set -ex \
#     && apk add --update --no-cache \
#     freetype \
#     libpng \
#     libjpeg-turbo \
#     freetype-dev \
#     libpng-dev \
#     libjpeg-turbo-dev \
#     libxml2-dev \
#     autoconf \
#     g++ \
#     imagemagick \
#     imagemagick-dev \
#     libtool \
#     make \
#     pcre-dev \
#     postgresql-dev \
#     postgresql \
#     libintl \
#     icu \
#     icu-dev \
#     bash \
#     jq \
#     git \
#     findutils \
#     gzip \
#     vim \
#     && docker-php-ext-configure gd \
#     --with-freetype-dir=/usr/include/ \
#     --with-png-dir=/usr/include/ \
#     --with-jpeg-dir=/usr/include/ \
#     && docker-php-ext-install bcmath mbstring iconv gd soap zip intl pdo_pgsql \
#     && pecl install imagick redis \
#     && docker-php-ext-enable imagick redis \
#     && rm -rf /tmp/pear \
#     && apk del freetype-dev libpng-dev libjpeg-turbo-dev autoconf g++ libtool make pcre-dev

# RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# RUN apk add gnu-libiconv --update-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/community/ --allow-untrusted
# ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php

# COPY ./config-env/php.ini /usr/local/etc/php/

# COPY ./db/skyviewer.sql /var/www/db/
# RUN chown -R www-data:www-data /var/www/db 

# COPY scripts/ /scripts/
# RUN chown -R www-data:www-data /scripts \
#     && chmod -R +x /scripts

# WORKDIR /var/www/html
# RUN mkdir logs
# RUN chown -R www-data:www-data .    

# RUN chown -R www-data:www-data /var/www/html/
# #USER www-data

# VOLUME [ "/var/www/html" ]

# ENTRYPOINT [ "/scripts/run.sh" ]

# CMD [ "docker-php-entrypoint", "php-fpm"]

# composer dependencies
FROM composer:2 as vendor
COPY craftcms/composer.json composer.json
COPY craftcms/composer.lock composer.lock
COPY custom-plugins/ ../custom-plugins/
RUN composer install --ignore-platform-reqs --no-interaction --prefer-dist

# Runtime container
FROM php:apache

# Install dependencies
USER root 
RUN apt-get update && apt-get -qq install libpq-dev libmagickwand-dev libzip-dev libmemcached-dev jq libonig-dev
RUN pecl install imagick memcached && \
    docker-php-ext-install -j "$(nproc)" opcache iconv bcmath mbstring pdo_pgsql gd zip intl \
    && docker-php-ext-enable imagick memcached
RUN a2enmod rewrite

# Configure PHP
RUN sed -ri -e 's/memory_limit = 128M/memory_limit = 256M/' $PHP_INI_DIR/php.ini-production  && \
    sed -ri -e 's/max_execution_time = 30/max_execution_time = 120/' $PHP_INI_DIR/php.ini-production && \
    mv $PHP_INI_DIR/php.ini-production $PHP_INI_DIR/php.ini

ENV CRAFT_STREAM_LOG true
ENV APACHE_DOCUMENT_ROOT /var/www/html/web

# Update the Apache config
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf && \
    sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf && \
    sed -ri -e 's/80/${PORT}/g' /etc/apache2/sites-available/000-default.conf /etc/apache2/ports.conf && \
    sed -ri -e 's/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf

# Enable mod_remoteip
RUN a2enmod remoteip \
    && echo "LoadModule remoteip_module modules/mod_remoteip.so" >> /etc/apache2/apache2.conf \
    && echo "RemoteIPHeader X-Forwarded-For" >> /etc/apache2/apache2.conf


# Copy in custom code from the host machine.
WORKDIR /var/www/html
COPY --chown=www-data:www-data craftcms/ ./
COPY --from=vendor --chown=www-data:www-data /app/vendor /var/www/html/vendor
RUN [ -d /var/www/html/storage ] || mkdir /var/www/html/storage \
    && chown www-data:www-data /var/www/html/storage && chmod u+w /var/www/html/storage

USER www-data

ENTRYPOINT ["./docker-entrypoint.sh"]

CMD ["apache2-foreground"]