#!/bin/bash

LOG="/tmp/wd.log"
echo "Iniciando vigilancia..." > $LOG

while true; do
    if mountpoint -q /media/usb_drive; then

        if pgrep -f "mednafen" > /dev/null; then

            echo "Alerta: USB conectada durante juego. Matando..." >> $LOG
            pkill -9 -f "mednafen"

            while pgrep -f "mednafen" > /dev/null; do 
                sleep 0.1
            done
            echo "Juego terminado." >> $LOG
        fi
    fi
    sleep 1
done
