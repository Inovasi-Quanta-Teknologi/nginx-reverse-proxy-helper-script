#!/bin/bash

# Script to create Nginx reverse proxy config for Node.js apps
# Usage: sudo ./add-nginx-proxy.sh

read -p "Enter domain name (example.com): " domain
read -p "Enter backend IP [127.0.0.1]: " backend_ip
read -p "Enter backend port [3000]: " backend_port

# Set defaults if empty
backend_ip=${backend_ip:-127.0.0.1}
backend_port=${backend_port:-3000}

config_file="/etc/nginx/sites-available/$domain"

# Check if config already exists
if [ -f "$config_file" ]; then
    echo "Config file $config_file already exists!"
    exit 1
fi

# Create nginx config file
cat > "$config_file" <<EOL
server {
    listen 80;
    server_name $domain www.$domain;

    location / {
        proxy_pass http://$backend_ip:$backend_port;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
    }

    access_log /var/log/nginx/${domain}_access.log;
    error_log /var/log/nginx/${domain}_error.log;
}
EOL

# Enable site
ln -s "$config_file" "/etc/nginx/sites-enabled/" 2>/dev/null

# Test nginx config
nginx -t
if [ $? -eq 0 ]; then
    systemctl reload nginx
    echo "Reverse proxy for $domain -> $backend_ip:$backend_port added and Nginx reloaded!"
else
    echo "Nginx config test failed. Check your config."
fi
