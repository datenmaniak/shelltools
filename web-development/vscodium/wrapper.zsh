#!/usr/bin/env zsh

# 🟣 Violet Pulse Wrapper para VSCodium Setup
# Ruta: ~/shelltools/web-development/vscodium/wrapper.zsh

SCRIPT_DIR="${0:A:h}"
SETUP_SCRIPT="$SCRIPT_DIR/setup.sh"

# 🎨 Branding
echo "\n🟣 VSCodium Setup - Violet Pulse Edition"
echo "──────────────────────────────────────────"

# 🔍 Validación de entorno gráfico
if [[ -z "$DISPLAY" ]]; then
  echo "⚠️ No se detectó entorno gráfico. Este módulo requiere interfaz visual para aplicar temas."
  exit 1
fi

# 🐚 Validación de shell
if [[ "$SHELL" != *zsh* && "$SHELL" != *bash* ]]; then
  echo "⚠️ Shell no compatible detectado: $SHELL"
  echo "ℹ️ Usa Bash o Zsh para ejecutar este módulo."
  exit 1
fi

# 🧪 Opciones interactivas
echo "\nSelecciona una opción:"
echo "  [1] Instalar extensiones y aplicar configuración completa"
echo "  [2] Solo instalar extensiones"
echo "  [3] Salir"
read "opcion?👉 Opción: "

case $opcion in
  1)
    bash "$SETUP_SCRIPT"
    ;;
  2)
    codium --install-extension zhuangtongfa.material-theme
    codium --install-extension pkief.material-icon-theme
    echo "✅ Extensiones clave instaladas. Puedes aplicar configuración manualmente si lo deseas."
    ;;
  *)
    echo "🚪 Saliendo del módulo VSCodium Setup."
    exit 0
    ;;
esac

# 🔔 Notificación KDE/GNOME
if command -v notify-send &> /dev/null; then
  notify-send "VSCodium Setup" "Instalación completada con Violet Pulse 💜"
fi

echo "\n🎉 ¡Entorno VSCodium listo para desarrollo web modular!"
