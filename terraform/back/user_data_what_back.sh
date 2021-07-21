#!/bin/bash
sudo apt -y update
wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb 
sudo dpkg -i packages-microsoft-prod.deb 
sudo apt -y update 
sudo apt -y install apt-transport-https
sudo apt -y install dotnet-runtime-3.1
sudo apt -y install nginx

echo "
server {
    listen      80;
    listen [::]:80;
#    server_name   example.com *.example.com;
    location / {
        proxy_pass         http://localhost:5000;
        proxy_http_version 1.1;
        proxy_set_header   Upgrade \$http_upgrade;
        proxy_set_header   Connection keep-alive;
        proxy_set_header   Host \$host;
        proxy_cache_bypass \$http_upgrade;
        proxy_set_header   X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header   X-Forwarded-Proto \$scheme;
    }
}
server {
    listen      443;
    listen [::]:443;
    server_name localhost;
    proxy_set_header Host \$host;
    proxy_set_header X-Forwarded-For \$remote_addr;
    location / {
        proxy_pass https://localhost:5001;
    }
}
" > /etc/nginx/sites-available/default

service nginx restart

curl -L -X GET "http://nexus-loadb-6puu3e2x3dzt-1303686621.us-east-2.elb.amazonaws.com/service/rest/v1/search/assets/download?sort=version&repository=what-back-1"\
 -H "accept: application/json" --output - | tar -xzf -  -C /opt/whatbackend


echo "
[Unit]
Description=.NET WhatAPI service
After=syslog.target network.target

[Service]
WorkingDirectory=/opt/whatbackend
ExecStart=/usr/bin/dotnet /opt/whatbackend/CharlieBackend.Api.dll
RestartSec=10
SyslogIdentifier=whatapi
User=root
Restart=always
LimitNOFILE=65536
LimitNPROC=4096
Environment=ASPNETCORE_ENVIRONMENT=Production

[Install]
WantedBy=multi-user.target
" > /etc/systemd/system/whatapi.service

sudo systemctl enable whatapi.service
sudo systemctl start whatapi.service

