FROM php:8.1-apache

EXPOSE 80

# Install system dependencies and PHP extensions
RUN apt-get update -y && \
    apt-get install -y apt-utils tree htop \
    libpng-dev libc-client-dev libkrb5-dev \
    libzip-dev zip \
    libxml2-dev libicu-dev libonig-dev libcurl4-openssl-dev \
    --no-install-recommends 

# Install PHP extensions
RUN docker-php-ext-configure imap --with-kerberos --with-imap-ssl && \
    docker-php-ext-configure gd --with-jpeg && \
    docker-php-ext-install -j$(nproc) imap mysqli gd zip curl mbstring xml intl bcmath fileinfo

# Enable Apache modules
RUN a2enmod rewrite

# Copy your app
COPY perfex_crm/ /var/www/html/

# Set correct permissions
RUN chown -R www-data:www-data /var/www/html/ && \
    chmod 755 /var/www/html/uploads/ && \
    chmod 755 /var/www/html/application/config/ && \
    chmod 755 /var/www/html/application/config/config.php && \
    chmod 755 /var/www/html/application/config/app-config-sample.php && \
    chmod 755 /var/www/html/temp/
