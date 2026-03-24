# 🐳 Laravel Base Image (PHP 8.4)

![Build Status](https://img.shields.io/github/actions/workflow/status/akunnyaanam/laravel-base-image/build-push.yml?branch=main)
![License](https://img.shields.io/github/license/akunnyaanam/laravel-base-image)
![Release](https://img.shields.io/github/v/release/akunnyaanam/laravel-base-image?include_prereleases)

A highly optimized, lightweight, production-ready Docker base image designed for **Laravel applications**.
Built on top of **Alpine Linux** to ensure minimal image size while maintaining compatibility with PHP extensions through musl libc.

This image is intended to be used as a parent image (`FROM`) to speed up deployment pipelines for Laravel projects.

## 🚀 Features & Specifications

This image comes pre-installed with the standard stack required for modern Laravel applications (API, traditional, or hybrid):

### 🛠 System Foundation

- **OS:** Alpine Linux (lightweight, security-focused)
- **Base Image:** `php:8.4-fpm-alpine`
- **Architecture:** `amd64` / `arm64` (Multi-arch ready)
- **C Library:** musl libc - Minimal footprint with excellent PHP extension support
- **Image Size:** Significantly smaller than Debian-based alternatives
- **Timezone:** UTC (Configurable via your application)

### 🐘 PHP Environment

- **Version:** PHP 8.4 FPM
- **Memory Limit:** 1024M
- **Extensions Installed:**
    - `pdo_mysql` - MySQL database support
    - `gd` - Image processing with JPEG & Freetype support
    - `mbstring` - Multibyte string support
    - `bcmath` - Arbitrary precision arithmetic
    - `xml` - XML parsing
    - `zip` - ZIP file handling
    - `pcntl` - Process control
    - `opcache` - Opcode caching with JIT enabled
    - `intl` - Internationalization support

### ⚡ Performance Optimizations

- **OPCache:** Enabled with JIT (tracing mode), 256MB memory allocation
- **FPM Configuration:** Production-optimized with dynamic process management
    - Max children: 40
    - Start servers: 5
    - Min/Max spare servers: 5/10
    - Request terminate timeout: 60s
- **Build Optimization:** Multi-stage build process to remove build dependencies and minimize final image size

### 📦 Included Tools & Libraries

- **Composer:** Latest version (v2.x) from official image
- **System Tools:** `git`, `curl`, `zip`, `unzip`, `bash`
- **Runtime Libraries:** Freetype, libjpeg-turbo, libpng, ICU, Oniguruma, libzip
- **Minimal Footprint:** Build dependencies are removed after compilation

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

If you need Node.js and npm for frontend building, use a multi-stage build:

```dockerfile
# Multi-stage build with Node.js
FROM node:20-alpine as frontend
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
- ✅ Containerized deployments where image size matters
- ⚠️ Applications with strict musl libc requirements (most are compatible)

---

## 📋 Image Size Benefits

By using Alpine Linux instead of Debian, this image provides:

- **Minimal base size** - Significantly smaller than Debian-based PHP images
- **Faster downloads** - Quicker pulls from container registries
- **Reduced storage** - Less disk space required on container hosts
- **Faster startup** - Quick container initialization
- **Production-ready** - Alpine is widely used in production environments

---

## 🔧 Configuration Files

The image includes the following pre-configured files:

- **`fpm-production.conf`** - Optimized PHP-FPM worker process configuration
- **`opcache.ini`** - OPCache settings with JIT compilation enabled

---

## ⚠️ Compatibility Notes

- **Alpine Linux uses musl libc** instead of glibc - Most PHP extensions and applications work seamlessly, but some binary-dependent packages may require testing
- **No system package manager** pre-installed in final image - Keep your Dockerfile lean and efficient
- **Some tools unavailable** - Common Linux tools available in Debian may not be in Alpine (e.g., curl, git are included, but others may need to be added)

---

## 📋 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 👨‍💻 Maintainer

**Khoirul Anam** - [GitHub](https://github.com/akunnyaanam)

---

## 🤝 Contributing

Contributions are welcome! Feel free to open issues or submit pull requests to improve this base image.
