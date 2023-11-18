luarocks install lua-cjson
luarocks show lua-cjson


Modules:
        cjson (/usr/lib64/lua/5.1/cjson.so)
        cjson.util (/usr/share/lua/5.1/cjson/util.lua)
        json2lua (/usr/share/lua/5.1/json2lua.lua)
        lua2json (/usr/share/lua/5.1/lua2json.lua)
        
        
        
cp -r /usr/share/lua/5.1/* /usr/local/nginx/lib/lua/       
cp /usr/lib64/lua/5.1/cjson.so /usr/local/nginx/lib/lua/        
        
Nginx:      
lua_package_cpath '/usr/local/nginx/lib/lua/?.so';     
        
        
cp /usr/share/lua/5.1/*.lua /usr/local/nginx/lib/lua/ 
