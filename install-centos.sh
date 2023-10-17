#!/bin/bash
############### 
#Author:https://github.com/tempnana
###############
yum update -y && yum upgrade -y
##
yum install curl wget net-tools iftop zip unzip git epel-release lsof -y
cd /usr/local
git clone https://github.com/FRiCKLE/ngx_cache_purge
git clone https://github.com/yaoweibin/ngx_http_substitutions_filter_module
git clone https://github.com/openresty/headers-more-nginx-module
git clone https://github.com/yaoweibin/nginx_upstream_check_module
cd /root
#wget https://soft2.vpser.net/lnmp/lnmp1.8.tar.gz -cO lnmp1.8.tar.gz && tar zxf lnmp1.8.tar.gz
wget https://github.com/tempnana/Lnmp/raw/main/lnmp1.8.tar.gz -cO lnmp1.8.tar.gz && tar zxf lnmp1.8.tar.gz
wget https://raw.githubusercontent.com/tempnana/Lnmp/main/nginx.sh
\cp nginx.sh lnmp1.8/include/
cd /root/lnmp1.8/tools
sed -i 's#maxretry = 5#maxretry = 2#g' fail2ban.sh
#./install.sh lnmp
echo "Install fail2ban..."
. fail2ban.sh
sleep 5s
#./install.sh lnmp
cd /root/lnmp1.8
sed -i 's/soft.vpser.net/soft2.vpser.net/g' lnmp.conf
sed -i "s:Nginx_Modules_Options='':Nginx_Modules_Options='--with-http_random_index_module --add-module=/usr/local/ngx_http_substitutions_filter_module --add-module=/usr/local/ngx_cache_purge --add-module=/usr/local/headers-more-nginx-module --add-module=/usr/local/nginx_upstream_check_module':" lnmp.conf
sed -i "s/Enable_Nginx_Lua='n'/Enable_Nginx_Lua='y'/g" lnmp.conf
chmod +x *.sh
echo "Choose install:"
echo ""
echo " 1: Install full LNMP"
echo " 2: Install full LAMP"
echo " 3: Install full LNMPA"
echo " 4: Only install Nginx"
echo " 5: Only install DB"
echo ""
read -p "(Directly Enter to cancel), Enter 1 or 2,3,4,5:" install
if [[ '1' = "$install" ]]; then
    eval "./install.sh lnmp"
elif [[ '2' = "$install" ]]; then
    eval "./install.sh lamp"
elif [[ '3' = "$install" ]]; then
    eval "./install.sh lnmpa"
elif [[ '4' = "$install" ]]; then
    eval "./install.sh nginx"
elif [[ '5' = "$install" ]]; then
    eval "./install.sh db"
else
    echo "Install canceled."
    exit
fi
#Install fail2ban
#echo "Install fail2ban..."
#cd tools
#. fail2ban.sh
#sleep 3s
cd /root
#ufw
echo "Install ufw..."
#yum install ufw -y
yum install --enablerepo="epel" ufw -y
#Default set: deny all IN and allow all OUT
ufw default deny incoming
ufw default allow outgoing
ufw allow ssh
ufw allow 80
#Enable ufw
ufw --force enable
#Status checking
ufw status verbose
#crontab
rM=$(($RANDOM%59))
rH=$(($RANDOM%12))
echo '#/sbin/service crond start' >> /var/spool/cron/root
echo '#'$[rM] $[rH]  "* * * /sbin/reboot" >> /var/spool/cron/root && /sbin/service crond start
#deny ip:80
echo "deny ip:80..."
localip=$(hostname -I)
sed -i "s:server_name _;:server_name ${localip};\n return 444;:" /usr/local/nginx/conf/nginx.conf
#set PHP limit
sed -i "s:memory_limit = 128M:memory_limit = 2048M:" /usr/local/php/etc/php.ini
sed -i "s:post_max_size = 50M:post_max_size = 5000M:" /usr/local/php/etc/php.ini
sed -i "s:upload_max_filesize = 50M:upload_max_filesize = 5000M:" /usr/local/php/etc/php.ini
sed -i "s:max_file_uploads = 20:max_file_uploads = 200:" /usr/local/php/etc/php.ini
wget https://raw.githubusercontent.com/tempnana/Lnmp/main/my.cnf -0 /etc/my.cnf
lnmp restart
#rm -rf *
echo 'Add replace-filter-nginx-module:'
echo 'bash <(wget -qO- https://raw.githubusercontent.com/tempnana/Lnmp/main/add-replace-filter-nginx-module.sh)'
