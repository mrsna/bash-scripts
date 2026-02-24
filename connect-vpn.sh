#!/bin/bash

# This script automatically manages a VPN connection based on the current Wi-Fi network.
# It checks every 30 seconds to see if the system is connected to a specified Wi-Fi network.
# If connected to the target Wi-Fi, it disconnects the VPN; if not, it connects the VPN.
# 
# Configuration:
# To ensure the script functions correctly, you need to set the following variables:
#   - `TARGET_WIFI`: The name of the target Wi-Fi network you want to monitor (e.g., "MyHomeWiFi").
#   - `WG_CONNECTION`: The name of the VPN connection you wish to manage (e.g., "MyVPNConnection").

TARGET_WIFI="WIFI-NAME"
WG_CONNECTION="WG-NAME"
CHECK_INTERVAL=30  # seconds

while true; do
    CURRENT_WIFI=$(nmcli -t -f active,ssid dev wifi | grep '^yes' | cut -d: -f2)

    WG_ACTIVE=$(nmcli -t -f NAME,TYPE,DEVICE connection show --active | grep "^$WG_CONNECTION:")

    if [ "$CURRENT_WIFI" == "$TARGET_WIFI" ]; then
        echo "CONNECT-VPN: Connected to $TARGET_WIFI"

        if [ -n "$WG_ACTIVE" ]; then
            echo "CONNECT-VPN: Disconnecting VPN $WG_CONNECTION..."
            nmcli connection down "$WG_CONNECTION"
        else
            echo "CONNECT-VPN: VPN already disconnected."
        fi
    else
        echo "CONNECT-VPN: Not connected to $TARGET_WIFI"

        if [ -z "$WG_ACTIVE" ]; then
            echo "CONNECT-VPN: Connecting VPN $WG_CONNECTION..."
            nmcli connection up "$WG_CONNECTION"
        else
            echo "CONNECT-VPN: VPN already connected."
        fi
    fi

    sleep "$CHECK_INTERVAL"
done
