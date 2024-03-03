#!/bin/bash

# Check if running as root
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# Check for domain name argument
if [ -z "$1" ]; then
    echo "No domain name supplied"
    exit 1
fi

# Check for port number argument
if [ -z "$2" ]; then
    echo "No port number supplied"
    exit 1
fi

# Variables
DOMAIN=$1
PORT=$2
SITES_AVAILABLE='/etc/nginx/sites-available'
SITES_ENABLED='/etc/nginx/sites-enabled'
CONFIG_FILE="${SITES_AVAILABLE}/${DOMAIN}"

# Create NGINX configuration for HTTP
cat > $CONFIG_FILE <<EOF
server {
    listen 80;
    server_name $DOMAIN;

    location / {
        proxy_pass http://localhost:$PORT;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
    }
}
EOF

# Enable site by creating symbolic link
ln -s $CONFIG_FILE $SITES_ENABLED/

# Test NGINX configuration
nginx -t

# Reload NGINX to apply the new configuration
systemctl reload nginx

echo "NGINX configuration for $DOMAIN has been added and enabled."

# Obtain SSL Certificate and Configure NGINX for HTTPS
certbot --nginx -d $DOMAIN --non-interactive --agree-tos -m your@email.com --redirect

echo "SSL Certificate has been installed and HTTPS configuration is enabled."
