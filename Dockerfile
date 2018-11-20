FROM php:apache

MAINTAINER Jen Pollock <jen@jenpollock.ca>

EXPOSE 80

RUN apt-get update && apt-get install -y \
	zlib1g-dev \
	unzip \
	git

RUN docker-php-ext-install zip
RUN docker-php-ext-install pdo_mysql

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer 

COPY 000-default.conf /etc/apache2/sites-available

USER www-data

WORKDIR /var/www/html
RUN git clone https://github.com/Alsciende/netrunnerdb.git nrdb
WORKDIR nrdb
RUN git clone https://github.com/Alsciende/netrunner-cards-json.git cards

COPY --chown=www-data:www-data dev-parameters.yml app/config/parameters.yml

RUN composer install

# overwrite default app_dev.php with one that has
# the "does this look like a dev setup?" security check
# commented out
COPY --chown=www-data:www-data app_dev.php web

# redirect everything to app_dev.php rather than app.php
COPY --chown=www-data:www-data .htaccess web

USER root

CMD ["apache2-foreground"]

