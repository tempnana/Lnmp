#!/bin/bash
###############
#Author: https://github.com/tempnana
#bash <(wget -qO- https://raw.githubusercontent.com/tempnana/Lnmp/main/add/add-lua-ext.sh)
###############

install_luajit() {
    if ! command -v luajit &>/dev/null; then
        echo "LuaJIT could not be found."
        echo "Install luajit2-2.1-20230119..."
        cd /root/lnmp2.0/src
        tar -xf luajit2-2.1-20230119.tar
        cd /root/lnmp2.0/src/luajit2-2.1-20230119
        make
        sleep 5
        make install
        luajit -v
    else
        luajit -v
    fi
}
install_luarocks() {
    if ! command -v luarocks &>/dev/null; then
        apt install luarocks -y
        luarocks install lua-cjson
    fi
}

install_luajit
install_luarocks
