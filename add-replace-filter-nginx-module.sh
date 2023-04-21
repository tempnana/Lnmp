#!/bin/bash
############### 
#Author:https://github.com/tempnana
###############
##
#make install sregex
cd /usr/local
git clone https://github.com/openresty/sregex
cd /usr/local/sregex
echo 'Waiting make install sregex...'
make
sleep 5s
make install
if [ ! -f "libsregex.so.0" ];then
  echo "No libsregex.so.0 file"
  exit
fi
ls
#ldd $(which /usr/sbin/nginx)
cp /usr/local/sregex/libsregex.so.0 /lib/x86_64-linux-gnu/
sleep 5s
#get replace-filter-nginx-module
cd /usr/local
git clone https://github.com/openresty/replace-filter-nginx-module
#Re-install nginx
cd /root/lnmp1.8
sed -i "s:Nginx_Modules_Options=':Nginx_Modules_Options='--add-module=/usr/local/replace-filter-nginx-module :" lnmp.conf
chmod +x *.sh
echo 'Re-install Nginx to support "replace-filter-nginx-module"'
./upgrade.sh nginx
