#!/bin/bash
###############
#Author: https://github.com/tempnana
#Source: https://github.com/lnmpkvemail/lnmp
###############
rM=$(($RANDOM % 59))
rH=$(($RANDOM % 12))
if [ -f /etc/debian_version ]; then
    update_install() {
        apt update && apt upgrade -y
        apt-get install curl wget ufw net-tools iftop zip unzip git lsof -y
    }
    set_crontab() {
        echo '#/etc/init.d/cron restart' >>/var/spool/cron/crontabs/root
        echo '#'$((rM)) $((rH)) "* * * /sbin/reboot" >>/var/spool/cron/crontabs/root && /etc/init.d/cron restart
    }
elif [ -f /etc/centos-release ]; then
    update_install() {
        yum update -y && yum upgrade -y
        yum install epel-release curl wget ufw net-tools iftop zip unzip git lsof -y
        echo 'v /tmp 1777 root root 3d' >/etc/tmpfiles.d/custom-tmp.conf
        systemd-tmpfiles --clean >/dev/null 2>&1 &
    }
    set_crontab() {
        echo '#/sbin/service crond start' >>/var/spool/cron/root
        echo '#'$((rM)) $((rH)) "* * * /sbin/reboot" >>/var/spool/cron/root && /sbin/service crond start
    }
else
    echo "Unsupported distribution."
fi

# # install tools
update_install

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

# # set replace
wget https://raw.githubusercontent.com/tempnana/Lnmp/main/change/fail2ban.sh -O /root/lnmp2.0/tools
wget https://raw.githubusercontent.com/tempnana/Lnmp/main/change/version.sh -O /root/lnmp2.0/include/version.sh
wget https://raw.githubusercontent.com/tempnana/Lnmp/main/change/nginx.sh -O /root/lnmp2.0/include/nginx.sh
wget https://raw.githubusercontent.com/tempnana/Lnmp/main/change/upgrade_nginx.sh -O /root/lnmp2.0/include/upgrade_nginx.sh
wget https://raw.githubusercontent.com/tempnana/Lnmp/main/change/lnmp.conf -O /root/lnmp2.0/lnmp.conf


# # install fail2ban
cd /root/lnmp2.0/tools
echo "Install fail2ban..."
. fail2ban.sh
sleep 5s

# # install lnmp
cd /root/lnmp2.0
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

# # set ufw
#Default set: deny all IN and allow all OUT
ufw default deny incoming
ufw default allow outgoing
ufw allow ssh
ufw allow 80
ufw --force enable
ufw status verbose

# # set crontab
set_crontab

# # deny ip:80
echo "deny ip:80..."
wget https://raw.githubusercontent.com/tempnana/Lnmp/main/change/nginx.conf -O /usr/local/nginx/conf/nginx.conf
local_ip=$(hostname -I | awk '{print $1}')
sed -i "s#server_name _;#server_name ${local_ip};#g" /usr/local/nginx/conf/nginx.conf

# # set mysql directory
if [[ -f /etc/cnf ]]; then
mkdir /home/dataroot
cp -R /usr/local/mysql/var /home/dataroot
wget https://raw.githubusercontent.com/tempnana/Lnmp/main/change/my.cnf -O /etc/cnf
fi

lnmp restart
