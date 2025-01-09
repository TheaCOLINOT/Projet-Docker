#!/bin/bash

set -e

# Navigate to the application directory
cd /var/www/html

# Copie le fichier d'environment
echo "Creating .env file from .env.example..."
cp -f .env.example .env

# Install PHP dependencies with Composer
if [ ! -d "vendor" ]; then
    echo "Installing PHP dependencies..."
    composer install --no-dev --optimize-autoloader
fi

# Install Node.js dependencies and build assets
if [ ! -d "node_modules" ]; then
    echo "Installing Node.js dependencies..."
    npm install
    echo "Building assets..."
    npm run build
fi

# Run Laravel setup commands
echo "Running Laravel setup..."
php artisan key:generate --force

if [ "$RUN_MIGRATIONS" = "true" ]; then
    php artisan migrate:fresh --seed --force
fi

# Start PHP-FPM
exec "$@"