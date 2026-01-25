# 🐳 Laravel Base Image (PHP 8.4 + Node 20)

![Build Status](https://img.shields.io/github/actions/workflow/status/akunnyaanam/laravel-base-image/build-push.yml?branch=main)
![Size](https://img.shields.io/docker/image-size/ghcr.io/akunnyaanam/laravel-base-image/latest)

A highly optimized, production-ready Docker base image designed for **Laravel applications**.
Built on top of **Debian Bookworm Slim** (Glibc) to ensure maximum compatibility with PHP extensions and Node.js libraries while keeping the image size reasonable.

This image is intended to be used as a parent image (`FROM`) to speed up deployment pipelines for Laravel projects.

## 🚀 Features & Specifications

This image comes pre-installed with the standard stack required for modern Laravel applications (TALL, VILT, or API):

### 🛠 System Foundation

- **OS:** Debian 12 (Bookworm) Slim
- **Architecture:** `amd64` / `arm64` (Multi-arch ready)
- **Library:** Glibc - Ensures compatibility with `sharp`, `imagick`, etc. "sane".
- **Timezone:** UTC (Configurable via App)

### 🐘 PHP Environment

- **Version:** PHP 8.4 FPM
- **Extensions Installed:**
    - `pdo_mysql`
    - `gd` (with JPEG & Freetype support)
    - `mbstring`
    - `bcmath`
    - `xml`
    - `zip`
    - `pcntl`
    - `opcache`
    - `intl`

### 📦 Dependencies & Tools

- **Composer:** Latest version (v2.x)
- **Node.js:** v20 (LTS)
- **Package Managers:** `npm` and `pnpm` (Global)
- **System Tools:** `git`, `curl`, `zip`, `unzip`, `bash`

---

## 📖 How to Use

In your Laravel project's `Dockerfile`, simply point to this image. You no longer need to install system dependencies, PHP extensions, or Node.js manually.

### Example `Dockerfile` for Your App

```dockerfile
# Point to your GitHub Container Registry image
FROM ghcr.io/akunnyaanam/laravel-base-image:latest

WORKDIR /var/www

# 1. Copy Application Code
COPY . .

# 2. Build Frontend (Node.js/Vite)
#    Dependencies (Node & PNPM) are already present in the base image!
RUN pnpm install \
    && pnpm run build \
    && rm -rf node_modules

# 3. Install Backend (Composer)
RUN composer install --no-dev --optimize-autoloader --no-interaction

# 4. Final Permissions
RUN chown -R www-data:www-data /var/www \
    && chmod -R 775 storage bootstrap/cache

EXPOSE 9000
CMD ["php-fpm"]
```
