#!/bin/bash
###############
#Author: https://github.com/tempnana
#bash <(wget -qO- https://raw.githubusercontent.com/tempnana/Lnmp/main/add/add-lib-lua-htmlparser.sh)
###############

install_luarocks_DEBIAN() {
    default_lua_pat='/usr/local/share/lua/5.1'
    apt install luarocks -y
    luarocks install htmlparser
    # luarocks show htmlparser
    cp ${default_lua_path}/htmlparser.lua /usr/local/nginx/lib/lua/
    cp -r ${default_lua_path}/htmlparser /usr/local/nginx/lib/lua/
}
install_luarocks_CENTOS() {
    default_lua_path='/usr/share/lua/5.1'
    default_lua_cpath='/usr/lib64/lua/5.1'
    yum install luarocks lua-devel -y
    luarocks install lua-cjson
    # luarocks show lua-cjson
    cp ${default_lua_path}/htmlparser.lua /usr/local/nginx/lib/lua/
    cp -r ${default_lua_path}/htmlparser /usr/local/nginx/lib/lua/
}

set_path_to_NGINX() {
    lnmp nginx restart
}
if [ -f /etc/debian_version ]; then
    install_luarocks_DEBIAN
    set_path_to_NGINX
elif [ -f /etc/centos-release ]; then
    install_luarocks_CENTOS
    set_path_to_NGINX
else
    echo "Unsupported distribution."
fi
