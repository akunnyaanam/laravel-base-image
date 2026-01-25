FROM php:8.4-fpm-bookworm

LABEL org.opencontainers.image.source=https://github.com/akunnyaanam/laravel-base-image
LABEL maintainer="Khoirul Anam"
LABEL description="Base Image Laravel: PHP 8.4, Node 20, Composer, Glibc (Debian Slim)"

RUN apt-get update && apt-get install -y \
    git curl zip unzip \
    libpng-dev libonig-dev libxml2-dev libzip-dev \
    libfreetype6-dev libjpeg62-turbo-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install pdo pdo_mysql gd mbstring bcmath xml zip pcntl opcache intl

RUN docker-php-ext-configure pcntl --enable-pcntl

RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g pnpm \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www
RUN chown -R www-data:www-data /var/www
