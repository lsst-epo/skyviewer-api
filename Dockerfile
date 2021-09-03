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