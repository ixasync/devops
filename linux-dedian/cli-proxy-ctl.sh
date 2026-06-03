#!/bin/bash

port="$1"

open_proxy_cli=$(env|grep -c -i "_proxy")

if [ -z "$port" ];then
    if [ "$open_proxy_cli" -gt 0 ]; then
	    echo "Exists proxy for cli..."
    else
	    echo "Nothing proxy for cli..."
    fi
    echo ""
    env | grep -i "_proxy"
    exit 0
fi

# config proxy
shell_config_path=""
if echo "$SHELL"|grep -q "bash"; then
	shell_config_path="$HOME/.bashrc"
elif echo "$SHELL"|grep -q "zsh"; then
	shell_config_path="$HOME/.zshrc"
else
	echo "No support: $SHELL"
	exit 1
fi


echo "Detected shell config: $shell_config_path"

# set proxy for cli
proxy_url="http://127.0.0.1:$port"
if [ "$open_proxy_cli" -lt 0 ];then
	sed -i "/http_proxy/c export http_proxy=$proxy_url"  "$shell_config_path"
	sed -i "/https_proxy/c export https_proxy=$proxy_url" "$shell_config_path"
else
	echo "export http_proxy=$proxy_url" >> "$shell_config_path"
	echo "export https_proxy=$proxy_url" >> "$shell_config_path"
fi

# close proxy for localhost
if ! env|grep -q "no_proxy"; then
	echo 'export no_proxy="localhost;127.0.0.1;0.0.0.0"' >> "$shell_config_path"
fi

if ! env|grep -q "NO_PROXY"; then
        echo 'export NO_PROXY="localhost;127.0.0.1;0.0.0.0"' >> "$shell_config_path"
fi

echo "Success! Work after exec: source $shell_config_path"
