# 🐳 Laravel Base Image (PHP 8.4)

![Build Status](https://img.shields.io/github/actions/workflow/status/akunnyaanam/laravel-base-image/build-push.yml?branch=main)
![License](https://img.shields.io/github/license/akunnyaanam/laravel-base-image)
![Release](https://img.shields.io/github/v/release/akunnyaanam/laravel-base-image?include_prereleases)

A highly optimized, production-ready Docker base image designed for **Laravel applications**.
Built on top of **Debian Bookworm** (Glibc) to ensure maximum compatibility with PHP extensions while keeping the image size reasonable.

This image is intended to be used as a parent image (`FROM`) to speed up deployment pipelines for Laravel projects.

## 🚀 Features & Specifications

This image comes pre-installed with the standard stack required for modern Laravel applications (API, traditional, or hybrid):

### 🛠 System Foundation

- **OS:** Debian 12 (Bookworm)
- **Base Image:** `php:8.4-fpm-bookworm`
- **Architecture:** `amd64` / `arm64` (Multi-arch ready)
- **Library:** Glibc - Ensures compatibility with various PHP extensions
- **Timezone:** UTC (Configurable via your application)

### 🐘 PHP Environment

- **Version:** PHP 8.4 FPM
- **Memory Limit:** 1024M
- **Extensions Installed:**
    - `pdo_mysql`
    - `gd` (with JPEG & Freetype support)
    - `mbstring`
    - `bcmath`
    - `xml`
    - `zip`
    - `pcntl`
    - `opcache` (with JIT enabled)
    - `intl`

### ⚡ Performance Optimizations

- **OPCache:** Enabled with JIT (tracing mode), 256MB memory allocation
- **FPM Configuration:** Production-optimized with dynamic process management
    - Max children: 40
    - Start servers: 5
    - Min/Max spare servers: 5/10
    - Request terminate timeout: 60s

### 📦 Dependencies & Tools

- **Composer:** Latest version (v2.x) from official image
- **System Tools:** `git`, `curl`, `zip`, `unzip`
- **Development Libraries:** PNG, XML, Freetype, JPEG, ICU support

---

## 📖 How to Use

In your Laravel project's `Dockerfile`, simply point to this image. You no longer need to install most system dependencies or PHP extensions manually.

### Example `Dockerfile` for Your App

```dockerfile
# Use the Laravel base image
FROM ghcr.io/akunnyaanam/laravel-base-image:latest

WORKDIR /var/www

# Copy application code
COPY . .

# Install PHP dependencies
RUN composer install --no-dev --optimize-autoloader --no-interaction

# Set proper permissions
RUN chown -R www-data:www-data /var/www \
    && chmod -R 775 storage bootstrap/cache

EXPOSE 9000
CMD ["php-fpm"]
```

### Example with Frontend Build (Node.js)

If you need Node.js and npm for frontend building, add your own Node.js setup:

```dockerfile
# Multi-stage build with Node.js
FROM node:20-bookworm as frontend
WORKDIR /build
COPY . .
RUN npm install && npm run build

# Laravel application stage
FROM ghcr.io/akunnyaanam/laravel-base-image:latest
WORKDIR /var/www

COPY . .
COPY --from=frontend /build/public/build ./public/build

RUN composer install --no-dev --optimize-autoloader --no-interaction

RUN chown -R www-data:www-data /var/www \
    && chmod -R 775 storage bootstrap/cache

EXPOSE 9000
CMD ["php-fpm"]
```

---

## 🎯 Use Cases

This base image is perfect for:

- ✅ RESTful API applications
- ✅ Traditional Laravel applications with server-side rendering
- ✅ Applications requiring specific PHP extensions
- ✅ Production deployments with optimized FPM configuration
- ⚠️ Frontend-heavy applications (consider adding Node.js in a multi-stage build)

---

## 🔧 Configuration Files

The image includes the following pre-configured files:

- **`fpm-production.conf`** - Optimized PHP-FPM worker process configuration
- **`opcache.ini`** - OPCache settings with JIT compilation enabled

---

## 📋 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 👨‍💻 Maintainer

**Khoirul Anam** - [GitHub](https://github.com/akunnyaanam)

---

## 🤝 Contributing

Contributions are welcome! Feel free to open issues or submit pull requests to improve this base image.
