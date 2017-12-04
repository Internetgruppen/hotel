FROM php:5.6-apache

# Install basic extensions
RUN apt-get update && apt-get install -y libpq-dev && apt-get -y purge exim4 && apt-get -y autoremove && apt-get clean
RUN docker-php-ext-install opcache && docker-php-ext-install mysql && apt-get purge gcc -y && rm -fr /usr/lib/gcc/

# Enable/disable apache modules
RUN a2enmod rewrite && a2dismod -f deflate

ADD php.ini /usr/local/etc/php/php.ini
ADD apache2.conf /etc/apache2/apache2.conf

RUN rm -fr /var/lock && rm -fr /var/run
