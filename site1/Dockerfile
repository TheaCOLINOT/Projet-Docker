# ./site1/Dockerfile

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
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh

# Définir le répertoire de travail
WORKDIR /var/www/html/

ENTRYPOINT [ "sh" , "/usr/local/bin/entrypoint.sh" ]
