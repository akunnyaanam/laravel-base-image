FROM php:8.4-fpm-alpine

LABEL org.opencontainers.image.source=https://github.com/akunnyaanam/laravel-base-image
LABEL maintainer="Khoirul Anam"

RUN apk add --no-cache \
    freetype \
    libjpeg-turbo \
    libpng \
    icu-libs \
    oniguruma \
    libzip \
    bash

RUN apk add --no-cache --virtual .build-deps \
    freetype-dev \
    libjpeg-turbo-dev \
    libpng-dev \
    icu-dev \
    oniguruma-dev \
    libxml2-dev \
    libzip-dev \
    linux-headers \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
        pdo_mysql \
        gd \
        mbstring \
        bcmath \
        xml \
        zip \
        pcntl \
        opcache \
        intl \
    && apk del .build-deps \
    && rm -rf /var/cache/apk/*

COPY opcache.ini /usr/local/etc/php/conf.d/zz-opcache-custom.ini
RUN echo "memory_limit = 1024M" > /usr/local/etc/php/conf.d/memory-limit.ini
COPY fpm-production.conf /usr/local/etc/php-fpm.d/zz-production.conf

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www

RUN chown -R www-data:www-data /var/www
