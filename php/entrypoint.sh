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
until mysqladmin ping -h db -u user -p'password' > /dev/null 2>&1; do
    echo "Waiting for database connection..." >> /var/log/database.log
    sleep 5
done

echo "Database is ready."

# Check if migrations have already been applied
if ! php artisan migrate:status | grep -q "No migrations."; then
    echo "Running migrations and seeders..."
    php artisan migrate:fresh --seed
    echo "Migrations and seeders executed successfully."
else
    echo "Database is already up-to-date."
fi

# Start PHP-FPM and capture logs for debugging
echo "Starting PHP-FPM..."
php-fpm -D -R > /var/log/php-fpm.log 2>&1

# Keep the container running and redirect logs
tail -f /var/log/php-fpm.log
