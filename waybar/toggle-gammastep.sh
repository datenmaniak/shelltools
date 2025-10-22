#!/bin/bash

# Verificar si gammastep está instalado
if ! command -v gammastep &> /dev/null; then
  notify-send "Filtro azul no disponible" "Gammastep no está instalado. Ejecuta: sudo dnf install gammastep"
  exit 1
fi

# Alternar estado de gammastep
PID=$(pgrep gammastep)

if [ -z "$PID" ]; then
  gammastep -O 3800 &
  notify-send "Filtro azul activado" "Gammastep está ahora en modo cálido (3800K)"
else
  kill "$PID"
  notify-send "Filtro azul desactivado" "Gammastep ha sido detenido"
fi
