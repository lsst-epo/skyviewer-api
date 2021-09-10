# Composer dependencies
FROM composer:2 as vendor
COPY craftcms/composer.json composer.json
COPY craftcms/composer.lock composer.lock
COPY custom-plugins/ ../custom-plugins/
RUN composer install --ignore-platform-reqs --no-interaction --prefer-dist

# Runtime container
FROM php:fpm

# Install dependencies
USER root 
RUN apt-get update && apt-get -qq install libpq-dev libmagickwand-dev libzip-dev libmemcached-dev jq libonig-dev nginx supervisor
RUN pecl install imagick memcached && \
    docker-php-ext-install -j "$(nproc)" opcache iconv bcmath mbstring pdo_pgsql gd zip intl \
    && docker-php-ext-enable imagick memcached

# Configure PHP
RUN sed -ri -e 's/memory_limit = 128M/memory_limit = 256M/' $PHP_INI_DIR/php.ini-production  && \
    sed -ri -e 's/max_execution_time = 30/max_execution_time = 120/' $PHP_INI_DIR/php.ini-production && \
    mv $PHP_INI_DIR/php.ini-production $PHP_INI_DIR/php.ini

# Tell CraftCMS to stream logs to stdout/stderr. https://craftcms.com/docs/3.x/config/#craft-stream-log
ENV CRAFT_STREAM_LOG true

# Configure Nginx
COPY config/nginx.conf /etc/nginx/nginx.conf

# Configure PHP-FPM
COPY config/fpm-pool.conf /usr/local/etc/php-fpm.d/zz-docker.conf

# Configure supervisor
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Copy in custom code from the host machine.
WORKDIR /var/www/html
COPY --chown=www-data:www-data craftcms/ ./
COPY --from=vendor --chown=www-data:www-data /app/vendor /var/www/html/vendor
COPY custom-plugins/ /custom-plugins
RUN [ -d /var/www/html/storage ] || mkdir /var/www/html/storage

# Make sure the www-data user has the correct directory ownership
RUN chown -R www-data:www-data /var/www /run /var/lib/nginx /var/log/nginx

USER www-data

ENTRYPOINT ["./docker-entrypoint.sh"]

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]