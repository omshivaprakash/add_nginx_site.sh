To add a new NGINX configuration for a new site using a script, you can write a Bash script that automates the process of creating a new configuration file in the /etc/nginx/sites-available/ directory, creating a symbolic link to it in the /etc/nginx/sites-enabled/ directory, and then testing and reloading NGINX to apply the new configuration. Below is a step-by-step guide on how to do this.

Step 1: Create the Bash Script
Create a new Bash script file on your server. You can name it anything you like, for example, add_nginx_site.sh.

sudo nano add_nginx_site.sh


Step 2: Script Content
Paste the following script into the file. This script takes two arguments: the domain name for the new site ($1) and the port number your application is running on ($2). It then creates a basic NGINX configuration file for reverse proxying to the specified port.

Step 3: Make the Script Executable
Change the script's permissions to make it executable.

sudo chmod +x add_nginx_site.sh

Step 4: Run the Script
Now, you can run the script with sudo (the script requires root privileges to modify NGINX configurations and reload the service). Replace yourdomain.com with your actual domain name and 3000 with the port number your application is running on.


sudo ./add_nginx_site.sh yourdomain.com 3000


The script will create a new NGINX configuration file for your site, enable it by creating a symbolic link in the sites-enabled directory, test the NGINX configuration for syntax errors, and reload NGINX to apply the changes.

Note:
This script is a basic example for creating a simple reverse proxy configuration. Depending on your specific requirements (e.g., SSL configuration, logging, more complex location directives), you might need to modify the script to include additional NGINX directives.
Always ensure your scripts are tested in a safe environment before running them on a production server, especially when they require root privileges.

To extend the script to add a Let's Encrypt SSL certificate and configure NGINX to serve the site over HTTPS by default, you can utilize Certbot, a free, open-source software tool for automatically using Let’s Encrypt certificates. This updated script will first set up an NGINX site configuration for HTTP, then use Certbot to obtain an SSL certificate, and automatically update the NGINX configuration to redirect HTTP traffic to HTTPS.

Prerequisites:
Ensure NGINX is installed.
Install Certbot and its NGINX plugin. The installation method varies by operating system. On Ubuntu, you can use:

To extend the script to add a Let's Encrypt SSL certificate and configure NGINX to serve the site over HTTPS by default, you can utilize Certbot, a free, open-source software tool for automatically using Let’s Encrypt certificates. This updated script will first set up an NGINX site configuration for HTTP, then use Certbot to obtain an SSL certificate, and automatically update the NGINX configuration to redirect HTTP traffic to HTTPS.

Prerequisites:
Ensure NGINX is installed.
Install Certbot and its NGINX plugin. The installation method varies by operating system. On Ubuntu, you can use:

sudo apt update
sudo apt install certbot python3-certbot-nginx
Important Notes:
Email Address: Replace your@email.com with your actual email address. This email will be used by Let's Encrypt for important notifications.

Domain Verification: Certbot will perform domain verification to prove you control the domain. Ensure the domain points to your server's IP address in DNS.

Certbot Non-Interactive: This script uses non-interactive flags for Certbot (--non-interactive, --agree-tos, -m). Ensure you understand and agree to the terms of service before using these options.

Script Execution: Run the script as root or with sudo to ensure it has the necessary permissions for installing certificates and modifying NGINX configurations.

DNS Propagation: Ensure that DNS changes have propagated and that the domain correctly points to your server's IP before running this script, as Certbot needs to verify domain ownership.

By running this script, you automate the process of setting up an NGINX site configuration, obtaining a Let's Encrypt SSL certificate, and redirecting HTTP traffic to HTTPS, making your site secure by default.
