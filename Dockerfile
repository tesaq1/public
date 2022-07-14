# Use the official PHP 7.3 image.
# https://hub.docker.com/_/php
FROM php:5.6-apache

# Copy local code to the container image.
COPY . /var/www/html/

# Use the PORT environment variable in Apache configuration files.
#RUN sed -i 's/80/${PORT}/g' /etc/apache2/sites-available/000-default.conf /etc/apache2/ports.conf
RUN ln -s /etc/apache2/mods-available/rewrite.load /etc/apache2/mods-enabled/rewrite.load \
    && sed -i 's/AllowOverride None/AllowOverride All/g' /etc/apache2/apache2.conf
# Configure PHP for development.
# Switch to the production php.ini for production operations.
# RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
# https://hub.docker.com/_/php#configuration
RUN sed -e '13c\Header set Access-Control-Allow-Origin *' /etc/apache2/sites-available/000-default.conf
RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"
#RUN chmod -R 777 APP/Runtime/
RUN apt-get update && apt-get install -y libpng-dev zlib1g-dev \
    && docker-php-ext-install gd
RUN apt-get install -y vim
RUN docker-php-ext-install pdo pdo_mysql
RUN docker-php-ext-install mysqli pdo pdo_mysql
#RUN mkdir /var/www/html/Uploads/Scode
#RUN chmod -R 777  Uploads/Scode/
RUN a2enmod headers
CMD ["apachectl", "-DFOREGROUND"]