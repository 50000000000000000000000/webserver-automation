#!/bin/bash

# Function to handle errors
function error_exit() {
  local message="$1"
  echo "Error: $message" >&2
  exit 1
}

# Function to update and upgrade packages (replace with actual source if needed)
function update_packages() {
  sudo apt update && sudo apt upgrade -y || error_exit "Failed to update package lists"
}

# Function to install LAMP stack
function install_lamp() {
  sudo apt install apache2 mysql-server php libapache2-mod-php git -y || error_exit "Failed to install LAMP stack"
}

# Function to configure MySQL (adjust database name, username, and password)
function configure_mysql() {
  local root_password="your_mysql_root_password"
  local database_name="mydatabase"
  local user_name="appuser"
  local user_password="yourapp_password"

  # Consider using environment variables for security (replace with actual commands)
  sudo mysql -uroot -p"$root_password" -e "CREATE DATABASE $database_name DEFAULT CHARACTER SET utf8;" || error_exit "Failed to create database"
  sudo mysql -uroot -p"$root_password" -e "GRANT ALL PRIVILEGES ON $database_name.* TO $user_name@localhost IDENTIFIED BY '$user_password';" || error_exit "Failed to create MySQL user"
}

# Function to clone application and install dependencies
function deploy_application() {
  local git_repo="https://github.com/gaurav-aditya/iNotes.git"  # Replace with your actual Git repository URL
  local app_dir="/var/www/html"

  git clone "$git_repo" "$app_dir" || error_exit "Failed to clone application"

  # Replace with the actual dependency installation command based on your application's needs
  composer install --no-dev --prefer-dist --working-dir="$app_dir" || error_exit "Failed to install application dependencies"
}

# Function to set permissions
function set_permissions() {
  local app_dir="/var/www/html"
  sudo chown -R www-data:www-data "$app_dir" || error_exit "Failed to set ownership"
  sudo chmod -R 755 "$app_dir" || error_exit "Failed to set permissions"
}

# Function to restart Apache
function restart_apache() {
  sudo systemctl restart apache2 || error_exit "Failed to restart Apache"
}

# Main script execution

# Call functions for deployment steps
update_packages
install_lamp
configure_mysql  # Update placeholders with your actual credentials
deploy_application  # Update Git repository URL if needed
set_permissions
restart_apache

echo "Deployment completed!"
