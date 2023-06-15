#!/bin/bash
############### 
#Author:https://github.com/tempnana
###############
##https://www.techrepublic.com/article/how-to-install-google-pagespeed-to-improve-nginx-performance/
##https://www.moewah.com/archives/3705.html
# CentOS 7
# yum install gcc-c++ pcre-devel zlib-devel make unzip libuuid-devel
# Ubuntu / Debian
apt-get install build-essential zlib1g-dev libpcre3 libpcre3-dev unzip uuid-dev -y
wget https://raw.githubusercontent.com/tempnana/Lnmp/main/files/pagespeed/add.pagespeed.conf -O /usr/local/nginx/conf/add.pagespeed.conf
# "include add.pagespeed.conf;" on server{}
cd /usr/local
git clone https://github.com/apache/incubator-pagespeed-ngx.git
cd /usr/local/incubator-pagespeed-ngx
git checkout latest-stable
#wget https://github.com/tempnana/Lnmp/raw/main/files/pagespeed/1.13.35.2-x64.tar.gz
wget https://dl.google.com/dl/page-speed/psol/1.13.35.2-x64.tar.gz
tar xvf 1.13.35.2-x64.tar.gz
sleep 5s
#Re-install nginx
cd /root/lnmp1.8
sed -i "s:Nginx_Modules_Options=':Nginx_Modules_Options='--add-module=/usr/local/incubator-pagespeed-ngx :" lnmp.conf
chmod +x *.sh
echo 'Re-install Nginx to support "pagespeed-ngx-module"'
./upgrade.sh nginx
