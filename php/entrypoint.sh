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
    echo "PHP dependencies installed successfully."
fi

# Install Node.js dependencies and build assets
if [ ! -d "node_modules" ]; then
    echo "Installing Node.js dependencies..."
    npm install
    echo "Building assets..."
    npm run build
    echo "Node.js dependencies installed and assets built successfully."
fi

# Wait for database connection
echo "Waiting for database connection..."
until php artisan migrate:status > /dev/null 2>&1; do
    sleep 5
done
echo "Database is ready."

# Run Laravel setup commands
echo "Running Laravel setup..."
php artisan key:generate --force
echo "Running migrations and seeders..."
php artisan migrate:fresh --seed --force

# Start PHP-FPM
exec "$@"
