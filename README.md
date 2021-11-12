# Lnmp
Lnmp

<h2>Install:</h2>
<br>
<b>#Debian9/10</b><br>
<pre>
bash <(wget -qO- https://raw.githubusercontent.com/tempnana/Lnmp/main/install-debian.sh)
</pre>
<b>#Centos7+</b><br>
<pre>
bash <(wget -qO- https://raw.githubusercontent.com/tempnana/Lnmp/main/install-centos.sh)
</pre>

<br>
<h2>Add</h2>
<hr>
<pre>
cd /usr/local
git clone git://github.com/FRiCKLE/ngx_cache_purge.git
git clone git://github.com/yaoweibin/ngx_http_substitutions_filter_module
cd /root/lnmp1.7
sed -i "s:Nginx_Modules_Options='':Nginx_Modules_Options='--add-module=/usr/local/ngx_http_substitutions_filter_module --add-module=/usr/local/ngx_cache_purge':" lnmp.conf
./upgrade.sh nginx
#Enter a new Nginx verson number
#http://nginx.org/
</pre>
