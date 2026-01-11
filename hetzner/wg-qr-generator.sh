#!/bin/bash

# WireGuard QR Code Generator
# Usage: wg-qr-generator.sh <client-name>

set -e

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <client-name>"
    echo "Example: $0 pixel11"
    exit 1
fi

CLIENT_NAME="$1"
WG_DIR="/etc/wireguard"
WG_INTERFACE="wg0"
SERVER_PUBLIC_KEY=$(sudo cat $WG_DIR/$WG_INTERFACE.conf | grep PrivateKey | awk '{print $3}' | wg pubkey)
SERVER_ENDPOINT="65.21.198.220:51820"
DNS_SERVER="1.1.1.1"

# Finde nächste freie IP
LAST_IP=$(sudo wg show $WG_INTERFACE allowed-ips | grep -oP '10\.200\.0\.\K[0-9]+' | sort -n | tail -1)
if [ -z "$LAST_IP" ]; then
    NEXT_IP=10
else
    NEXT_IP=$((LAST_IP + 1))
fi

CLIENT_IP="10.200.0.$NEXT_IP"

echo "Generating keys for $CLIENT_NAME..."
CLIENT_PRIVATE_KEY=$(wg genkey)
CLIENT_PUBLIC_KEY=$(echo $CLIENT_PRIVATE_KEY | wg pubkey)

echo "Adding peer to server..."
sudo wg set $WG_INTERFACE peer $CLIENT_PUBLIC_KEY allowed-ips $CLIENT_IP/32
sudo wg-quick save $WG_INTERFACE

# Erstelle Client-Konfiguration
CLIENT_CONFIG="[Interface]
PrivateKey = $CLIENT_PRIVATE_KEY
Address = $CLIENT_IP/24
DNS = $DNS_SERVER

[Peer]
PublicKey = $SERVER_PUBLIC_KEY
AllowedIPs = 10.200.0.0/24, 10.10.10.0/24, 192.168.122.0/24
Endpoint = $SERVER_ENDPOINT
PersistentKeepalive = 25"

# Speichere Konfiguration
CONFIG_FILE="/tmp/${CLIENT_NAME}.conf"
echo "$CLIENT_CONFIG" > $CONFIG_FILE

echo ""
echo "========================================"
echo "Client: $CLIENT_NAME"
echo "IP Address: $CLIENT_IP"
echo "Configuration saved to: $CONFIG_FILE"
echo "========================================"
echo ""
echo "QR Code:"
echo ""
qrencode -t ansiutf8 < $CONFIG_FILE

echo ""
echo "Configuration file content:"
cat $CONFIG_FILE

echo ""
echo "To remove this client later, run:"
echo "sudo wg set $WG_INTERFACE peer $CLIENT_PUBLIC_KEY remove"
