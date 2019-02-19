FROM php:7.2-apache

MAINTAINER Jen Pollock <jen@jenpollock.ca>

RUN apt-get update && apt-get install -y \
	zlib1g-dev \
	unzip

RUN docker-php-ext-install zip pdo_mysql

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer 

COPY 000-default.conf /etc/apache2/sites-available

# Allow composer to create cache
RUN chown -R www-data:www-data /var/www

USER root

EXPOSE 80

CMD ["apache2-foreground"]

WORKDIR /var/www/html/nrdb
