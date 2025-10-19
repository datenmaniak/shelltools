# 🌙 Módulo Filtro Azul (Gammastep) para Waybar

Este módulo permite activar y desactivar el filtro azul (temperatura de color cálida) desde la barra Waybar o mediante un shortcut en Sway. Está diseñado para integrarse con la estética Violet Pulse, y forma parte de la configuración modular y versionada del entorno Sway.

---

## 📁 Estructura

```
~/dotfiles/waybar/ 
├── config                # Configuración JSON de Waybar
├── style.css             # Estilos visuales 
├── toggle-gammastep.sh   # Script de activación/desactivación
```


---

## 🔧 Script: `toggle-gammastep.sh`

```bash
#!/bin/bash

# Verificar si gammastep está instalado
if ! command -v gammastep &> /dev/null; then
  notify-send "Filtro azul no disponible" "Gammastep no está instalado. Ejecuta: sudo dnf install gammastep"
  exit 1
fi

# Alternar estado de gammastep
PID=$(pgrep gammastep)

if [ -z "$PID" ]; then
  gammastep -O 3000 &
  notify-send "Filtro azul activado" "Gammastep está ahora en modo cálido (3000K)"
else
  kill "$PID"
  notify-send "Filtro azul desactivado" "Gammastep ha sido detenido"
fi
```

## ✅ Asegúrate de asignar permisos de ejecución:

```
chmod +x ~/dotfiles/waybar/toggle-gammastep.sh

```
## 🧩 Configuración en config
 
   Ajusta en:  *~/dotfiles/waybat/config*

```
"custom/filtroazul": {
  "exec": "pgrep gammastep && echo '󰖔' || echo '󰖓'",
  "tooltip": false,
  "on-click": "~/dotfiles/waybar/toggle-gammastep.sh",
  "interval": 5
}


```

 Ajusta en:  *~/dotfiles/waybar/style.css*

```
#custom-filtroazul {
  color: #a78bd7;
  padding: 0 8px;
}


```