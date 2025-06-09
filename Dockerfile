FROM php:8.1-apache

EXPOSE 80

RUN apt-get update -y && \
    apt-get install -y apt-utils tree htop \
    libpng-dev libjpeg-dev libfreetype6-dev \
    libc-client-dev libkrb5-dev libzip-dev zip libcurl4-openssl-dev libicu-dev libxml2-dev libonig-dev libbz2-dev && \
    rm -rf /var/lib/apt/lists/*

# Configure imap with kerberos and ssl support
RUN docker-php-ext-configure imap --with-kerberos --with-imap-ssl

# Configure gd with jpeg and freetype support
RUN docker-php-ext-configure gd --with-jpeg --with-freetype

# Install PHP extensions
RUN docker-php-ext-install -j$(nproc) imap mysqli gd zip curl mbstring xml intl bcmath fileinfo

RUN a2enmod rewrite

COPY perfex_crm/ /var/www/html/

RUN chown -R www-data:www-data /var/www/html/

RUN chmod 755 /var/www/html/uploads/ && \
    chmod 755 /var/www/html/application/config/ && \
    chmod 755 /var/www/html/application/config/config.php && \
    chmod 755 /var/www/html/application/config/app-config-sample.php && \
    chmod 755 /var/www/html/temp/
