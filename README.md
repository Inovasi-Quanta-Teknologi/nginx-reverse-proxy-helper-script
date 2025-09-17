# Nginx Reverse Proxy Helper Script

This script automates the creation of an Nginx **reverse proxy** configuration for applications (e.g., Node.js apps).  
It will:

- Prompt for a **domain name**, **backend IP**, and **backend port**  
- Generate a config file in `/etc/nginx/sites-available/`  
- Create a symlink in `/etc/nginx/sites-enabled/`  
- Validate the Nginx configuration and reload Nginx  

## Usage
```bash
sudo chmod +x add-nginx-proxy.sh
sudo ./add-nginx-proxy.sh
```
