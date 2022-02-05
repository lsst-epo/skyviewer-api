# Composer dependencies
FROM composer:2 as vendor
COPY craftcms/composer.json composer.json
COPY craftcms/composer.lock composer.lock
COPY custom-plugins/ ../custom-plugins/
RUN composer install --ignore-platform-reqs --no-interaction --prefer-dist --classmap-authoritative

# Runtime container
FROM us-central1-docker.pkg.dev/skyviewer/public-images/craft-base-image@sha256:2ff13d039e1245c172210d5c609dd17c85a5e9bb197e3db055b2e1291a35acd1

USER root 

# Copy in custom code from the host machine.
WORKDIR /var/www/html
COPY --chown=www-data:www-data craftcms/ ./
COPY --from=vendor --chown=www-data:www-data /app/vendor /var/www/html/vendor
COPY custom-plugins/ /custom-plugins
RUN [ -d /var/www/html/storage ] || mkdir /var/www/html/storage

# Make sure the www-data user has the correct directory ownership
RUN chown -R www-data:www-data /var/www

USER www-data