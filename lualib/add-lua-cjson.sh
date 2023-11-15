#!/bin/bash
############### 
#Author: https://github.com/tempnana
#Source: https://github.com/openresty/lua-cjson
###############
## bash <(wget -qO- https://raw.githubusercontent.com/tempnana/Lnmp/main/lualib/add-lua-cjson.sh)
###############
mkdir /root/lnmp2.0/src-lualib
cd /root/lnmp2.0/src-lualib
git clone https://github.com/tempnana/lua-cjson
make
make install
