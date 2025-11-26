#!/bin/bash

sudo plymouth quit
# Forzar pantalla negra
sudo sh -c 'echo 0 > /sys/class/graphics/fb0/blank'
sudo sh -c 'echo 1 > /sys/class/graphics/fb0/blank'

cd /home/pi/proyecto_final

# Definir el driver de video para todo el ciclo
export SDL_VIDEODRIVER=kmsdrm
export SDL_GAMECONTROLLERCONFIG="030000004c050000cc09000011810000,PS4 Controller Custom,platform:Linux,a:b1,b:b0,x:b3,y:b2,back:b8,start:b9,guide:b10,leftshoulder:b4,rightshoulder:b5,leftstick:b11,rightstick:b12,leftx:a0,lefty:a1,rightx:a3,righty:a4,lefttrigger:a2,righttrigger:a5,dpup:h0.1,dpright:h0.2,dpdown:h0.4,dpleft:h0.8,"

# Bucle
while true; do
    # Ejecutar con ruta relativa
    ./build/retro-console

    if [ -f /tmp/run_game.sh ]; then
         # Limpiar pantalla
         sudo sh -c 'echo 0 > /sys/class/graphics/fb0/blank'
         sudo sh -c 'echo 1 > /sys/class/graphics/fb0/blank'

         /bin/bash /tmp/run_game.sh
         rm /tmp/run_game.sh
    else
         break
    fi
    sleep 1
done
