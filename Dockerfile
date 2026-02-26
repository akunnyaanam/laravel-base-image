FROM php:8.4-fpm-bookworm

LABEL org.opencontainers.image.source=https://github.com/akunnyaanam/laravel-base-image
LABEL maintainer="Khoirul Anam"

RUN apt-get update && apt-get install -y --no-install-recommends \
    git curl zip unzip \
    libpng-dev libonig-dev libxml2-dev libzip-dev \
    libfreetype6-dev libjpeg62-turbo-dev libicu-dev \
    && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y --no-install-recommends nodejs \
    && npm install -g pnpm \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
    pdo_mysql gd mbstring bcmath xml zip pcntl opcache intl

COPY opcache.ini /usr/local/etc/php/conf.d/zz-opcache-custom.ini

RUN echo "memory_limit = 1024M" > /usr/local/etc/php/conf.d/memory-limit.ini

COPY fpm-production.conf /usr/local/etc/php-fpm.d/zz-production.conf

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www
RUN chown www-data:www-data /var/www
