#!/bin/bash

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
chown -R www-data:www-data /var/www/html/
chmod -R 775 storage bootstrap/cache
chmod +x /usr/local/bin/entrypoint.sh

echo "Waiting for database connection..."
sleep 5

echo "Database is ready."

php-fpm