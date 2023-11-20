#!/bin/bash
###############
#Author: https://github.com/tempnana
#bash <(wget -qO- https://raw.githubusercontent.com/tempnana/Lnmp/main/change/reset.sh)
###############

# # reset PHP limit
sed -i "s:memory_limit = 128M:memory_limit = 2048M:" /usr/local/php/etc/php.ini
sed -i "s:post_max_size = 50M:post_max_size = 5000M:" /usr/local/php/etc/php.ini
sed -i "s:upload_max_filesize = 50M:upload_max_filesize = 5000M:" /usr/local/php/etc/php.ini
sed -i "s:max_file_uploads = 20:max_file_uploads = 200:" /usr/local/php/etc/php.ini

# # reset my.cnf
wget https://raw.githubusercontent.com/tempnana/Lnmp/main/change/my.cnf -O /etc/my.cnf

lnmp restart
