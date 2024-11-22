#!/bin/bash
# Update and install Apache, PHP, and WordPress dependencies
sudo apt-get update -y
sudo apt-get install -y apache2 php libapache2-mod-php php-mysql wget unzip

# Enable and start Apache service
sudo systemctl enable apache2
sudo systemctl start apache2

# Download and setup WordPress
wget https://wordpress.org/latest.tar.gz -O /tmp/wordpress.tar.gz
sudo tar -xvzf /tmp/wordpress.tar.gz -C /var/www/html/
sudo mv /var/www/html/wordpress/* /var/www/html/
cd /var/www/html
sudo chown -R www-data:www-data /var/www/html/
sudo chmod -R 755 /var/www/html/
sudo rm -rf index.html
sudo cp wp-config-sample.php wp-config.php
# Configure WordPress to connect to the MySQL DB
# Use the db_ip variable passed from Terraform
DB_IP="${db_ip}"
DB_NAME="wordpress"
DB_USER="wordpressuser"
DB_PASSWORD="wordpresspassword"

# Set up the wp-config.php file with the MySQL DB credentials
sudo sed -i "s/database_name_here/$DB_NAME/" /var/www/html/wp-config.php
sudo sed -i "s/username_here/$DB_USER/" /var/www/html/wp-config.php
sudo sed -i "s/password_here/$DB_PASSWORD/" /var/www/html/wp-config.php
sudo sed -i "s/localhost/$DB_IP/" /var/www/html/wp-config.php

echo "WordPress setup complete."
sudo apt update -y
sudo apt upgrade -y