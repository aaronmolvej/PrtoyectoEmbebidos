#!/bin/bash

# Script de montaje automático (pmount)
# Nombre de la carpeta en /media/
LABEL="usb_drive"
DEVICE="/dev/sda1"

while true; do
    if [ -e "$DEVICE" ]; then
        if ! mountpoint -q "/media/$LABEL"; then
            pmount "$DEVICE" "$LABEL"
        fi
    else
        if mountpoint -q "/media/$LABEL"; then
            pumount "$LABEL"
        fi
    fi

    sleep 2
done
