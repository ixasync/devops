#!/bin/bash

### Self Signed Certificate ###

count=$(echo "$*"|grep -c "\-h")
if [ "$count" -eq "1" ];then
	echo "ssh <domain> <ip_list> <algo> <expire_days>"
	echo "    ssh - Self Signed Certificate "
	echo "    version: v1.0.0"
	echo ""
	echo "    --- args ---"
	echo "    arg1 domain likes: example.com, localhost"
	echo "    arg2 ip_list likes: 127.0.0.1"
	echo "    arg3 algo likes: rsa default ed25519"
	echo "    arg4 expire_days likes 30,90,180 default 366"
	exit 0
fi

# --- 1. args ---

NAME=${1:-"localhost"}       # arg1：domain
IP_LIST=${2:-"127.0.0.1"}    # arg2：IP
ALGO=${3:-"ed25519"}         # arg3：algoritm
EXPIRE_DAYS=${4:-366}         # arg4: expire days

# --- 2. build SAN (Subject Alternative Name) ---
# The modern browser must require SAN
EXT="subjectAltName = DNS:${NAME}, IP:${IP_LIST}"

# --- 3. gen ---
echo "domain= ${NAME}  ips=${IP_LIST}  algo=${ALGO} EXPIRE_DAYS=${EXPIRE_DAYS} is creating..."

openssl req -x509 \
    -newkey "$ALGO" \
    -nodes \
    -keyout "key.pem" \
    -out "cert.pem" \
    -days ${EXPIRE_DAYS} \
    -subj "/CN=${NAME}" \
    -addext "${EXT}"

echo "✅ success to create "
