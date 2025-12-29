#!/bin/sh

connection_status() {
    if [ -f "$config" ]; then
        connection=$(sudo wg show "$config_name" 2>/dev/null | head -n 1 | awk '{print $NF }')

        if [ "$connection" = "$config_name" ]; then
            echo "1"
        else
            echo "2"
        fi
    else
        echo "3"
    fi
}

config="$HOME/Downloads/idofront.conf"
config_name=$(basename "${config%.*}")

case "$1" in
--toggle)
    if [ "$(connection_status)" = "1" ]; then
        sudo wg-quick down "$config" 2>/dev/null
    else
        sudo wg-quick up "$config" 2>/dev/null
    fi
    ;;
*)
    if [ "$(connection_status)" = "1" ]; then
        echo "%{F#89dceb}嬨 $config_name%{F-}"
    elif [ "$(connection_status)" = "3" ]; then
        echo "%{F#f38ba8}Config not found!%{F-}"
    else
        echo "%{F#9399b2}嬨 down%{F-}"
    fi
    ;;
esac
