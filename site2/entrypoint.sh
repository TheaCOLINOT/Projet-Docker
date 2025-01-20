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
sleep 15

echo "Database is ready."

if ! php artisan migrate:status | grep -q "No migrations."; then
    echo "Running migrations and seeders..."
    php artisan migrate:fresh --seed
    echo "Migrations and seeders executed successfully."
else
    echo "Database is already up-to-date."
fi

# Run Laravel setup commands
echo "Running Laravel setup..."
php artisan key:generate 
echo "Running migrations and seeders..."
php artisan migrate:fresh --seed 

php-fpm