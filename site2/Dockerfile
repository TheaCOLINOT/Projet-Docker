FROM php:8.1-fpm

# Installer les dépendances système et PHP
RUN apt-get update && apt-get install -y \
    git nano curl libjpeg-dev libpng-dev libfreetype6-dev libxml2-dev libonig-dev zip unzip \
    && curl -sL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install pdo pdo_mysql mbstring exif pcntl bcmath gd \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Copier Composer depuis l'image officielle
COPY --from=composer:2.6 /usr/bin/composer /usr/bin/composer

# Copier le code source
COPY . /var/www/html/site2

# Définir le répertoire de travail
WORKDIR /var/www/html/site2

# Configurer les permissions
RUN chown -R www-data:www-data /var/www/html/site2 \
    && chmod -R 775 storage bootstrap/cache

# Installer les dépendances PHP et Node.js
RUN composer install --no-dev --optimize-autoloader \
    && npm install && npm run build

# Générer la clé de l'application Laravel
RUN php artisan key:generate

# Exposer le port PHP-FPM
EXPOSE 9000

# Démarrer PHP-FPM
CMD ["php-fpm"]