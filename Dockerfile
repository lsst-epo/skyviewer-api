# Composer dependencies
ARG BASE_TAG=latest
FROM composer:2 as vendor
COPY api/composer.json composer.json
COPY api/composer.lock composer.lock
RUN composer install --ignore-platform-reqs --no-interaction --prefer-dist --classmap-authoritative

# Runtime container
FROM us-central1-docker.pkg.dev/skyviewer/public-images/craft-base-image:$BASE_TAG

USER root 

# Copy in custom code from the host machine.
WORKDIR /var/www/html
COPY --chown=www-data:www-data api/ ./
COPY --from=vendor --chown=www-data:www-data /app/vendor /var/www/html/vendor
RUN mkdir /var/secrets && [ -d /var/www/html/storage ] || mkdir /var/www/html/storage

# Make sure the www-data user has the correct directory ownership
RUN chown -R www-data:www-data /var/www

USER www-data

CMD ["supervisord"]