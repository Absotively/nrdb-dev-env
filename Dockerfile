FROM php:apache

MAINTAINER Jen Pollock <jen@jenpollock.ca>

RUN apt-get update && apt-get install -y \
	zlib1g-dev \
	unzip \
	git

RUN docker-php-ext-install zip pdo_mysql

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer 

COPY 000-default.conf /etc/apache2/sites-available

# Allow composer to create cache
RUN chown -R www-data:www-data /var/www

USER www-data

WORKDIR /var/www/html

# Copy over nrdb repos
COPY --chown=www-data:www-data netrunnerdb nrdb/
WORKDIR nrdb
COPY --chown=www-data:www-data netrunner-cards-json cards/

COPY --chown=www-data:www-data dev-parameters.yml app/config/parameters.yml

# Install dependencies
RUN composer install

# overwrite default app_dev.php with one that has
# the "does this look like a dev setup?" security check
# commented out
COPY --chown=www-data:www-data app_dev.php web

# redirect everything to app_dev.php rather than app.php
COPY --chown=www-data:www-data .htaccess web

USER root

EXPOSE 80

CMD ["apache2-foreground"]
