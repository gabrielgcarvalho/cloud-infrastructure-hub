#!/bin/bash
yum update -y
amazon-linux-extras install epel -y
yum install -y nginx

cat > /etc/nginx/conf.d/hello.conf << EOL
${base64decode(nginx_conf)}
EOL

cat > /usr/share/nginx/html/index.html << EOL
${base64decode(webpage)}
EOL

systemctl restart nginx
nginx -t