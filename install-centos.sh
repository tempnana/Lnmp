#!/bin/bash
############### 
#Author: https://github.com/tempnana
#Source: https://github.com/lnmpkvemail/lnmp
###############

# # install tools
yum update -y && yum upgrade -y
yum install curl wget net-tools iftop zip unzip git epel-release lsof -y

# # get script file
cd /root
wget https://github.com/tempnana/Lnmp/raw/main/lnmp2.0.tar.gz -cO lnmp2.0.tar.gz && tar zxf lnmp2.0.tar.gz

# # get module file
mkdir /root/lnmp2.0/src-c
cd /root/lnmp2.0/src-c
git clone https://github.com/FRiCKLE/ngx_cache_purge
git clone https://github.com/yaoweibin/ngx_http_substitutions_filter_module
git clone https://github.com/openresty/headers-more-nginx-module
git clone https://github.com/yaoweibin/nginx_upstream_check_module
git clone https://github.com/replay/ngx_http_lower_upper_case

# # install fail2ban
cd /root/lnmp2.0/tools
sed -i 's#maxretry = 5#maxretry = 2#g' fail2ban.sh
echo "Install fail2ban..."
. fail2ban.sh
sleep 5s

# # set replace
cd /root/lnmp2.0
wget https://raw.githubusercontent.com/tempnana/Lnmp/main/change/version.sh -O /root/lnmp2.0/include/version.sh
wget https://raw.githubusercontent.com/tempnana/Lnmp/main/change/nginx.sh -O /root/lnmp2.0/include/nginx.sh
wget https://raw.githubusercontent.com/tempnana/Lnmp/main/change/upgrade_nginx.sh -O /root/lnmp2.0/include/upgrade_nginx.sh

sed -i 's/soft.vpser.net/soft2.vpser.net/g' lnmp.conf
sed -i "s:Nginx_Modules_Options='':Nginx_Modules_Options='--with-http_random_index_module --add-module=/root/lnmp2.0/src-c/ngx_http_substitutions_filter_module --add-module=/root/lnmp2.0/src-c/ngx_cache_purge --add-module=/root/lnmp2.0/src-c/headers-more-nginx-module --add-module=/root/lnmp2.0/src-c/nginx_upstream_check_module --add-module=/root/lnmp2.0/src-c/ngx_http_lower_upper_case':" lnmp.conf
sed -i "s/Enable_Nginx_Lua='n'/Enable_Nginx_Lua='y'/g" lnmp.conf

# # install lnmp
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

# # install ufw
cd /root
echo "Install ufw..."
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


# # set crontab
rM=$(($RANDOM%59))
rH=$(($RANDOM%12))
echo '#/sbin/service crond start' >> /var/spool/cron/root
echo '#'$[rM] $[rH]  "* * * /sbin/reboot" >> /var/spool/cron/root && /sbin/service crond start

# # deny ip:80
echo "deny ip:80..."
localip=$(hostname -I)
sed -i "s:server_name _;:server_name ${localip};\n return 444;:" /usr/local/nginx/conf/nginx.conf

# # set PHP limit
sed -i "s:memory_limit = 128M:memory_limit = 2048M:" /usr/local/php/etc/php.ini
sed -i "s:post_max_size = 50M:post_max_size = 5000M:" /usr/local/php/etc/php.ini
sed -i "s:upload_max_filesize = 50M:upload_max_filesize = 5000M:" /usr/local/php/etc/php.ini
sed -i "s:max_file_uploads = 20:max_file_uploads = 200:" /usr/local/php/etc/php.ini
wget https://raw.githubusercontent.com/tempnana/Lnmp/main/change/my.cnf -O /etc/my.cnf
lnmp restart

echo 'Add replace-filter-nginx-module:'
echo 'bash <(wget -qO- https://raw.githubusercontent.com/tempnana/Lnmp/main/add-replace-filter-nginx-module.sh)'
