
#!/bin/bash

# Install and start nginx server
yum search nginx 
amazon-linux-extras install nginx1 -y
systemctl start nginx
systemctl enable nginx
  
# Print the hostname on nginx homepage  
sudo echo Hello from `hostname -f` > /usr/share/nginx/html/index.html
