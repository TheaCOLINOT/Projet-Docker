#!/bin/bash

set -e

# Navigate to the application directory
cd /var/www/html

# Check if .env file exists, if not copy .env.example to .env
if [ ! -f .env ]; then
    echo "Creating .env file from .env.example..."
    cp .env.example .env
fi

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