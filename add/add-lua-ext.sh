#!/bin/bash
###############
#Author: https://github.com/tempnana
#bash <(wget -qO- https://raw.githubusercontent.com/tempnana/Lnmp/main/add/add-lua-ext.sh)
###############

install_luajit() {
    echo "LuaJIT could not be found."
    echo "Install luajit2-2.1-20230119..."
    if [[ ! -d "/root/lnmp2.0/src/luajit2-2.1-20230119" ]]; then
        cd /root/lnmp2.0/src
        gzip -d luajit2-2.1-20230119.tar.gz
        tar -xf luajit2-2.1-20230119.tar
    fi
    cd /root/lnmp2.0/src/luajit2-2.1-20230119
    make
    sleep 5
    make install
    luajit -v
}
install_luarocks() {
    apt install luarocks -y
    luarocks install lua-cjson
}

if ! command -v luajit &>/dev/null; then
    install_luajit
else
    luajit -v
fi
if ! command -v luarocks &>/dev/null; then
    install_luarocks
fi
