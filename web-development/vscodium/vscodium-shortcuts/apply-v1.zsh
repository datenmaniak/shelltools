#!/bin/zsh

CONFIG="$HOME/.config/VSCodium/User/keybindings.json"
SHORTCUTS_FILE="./shortcuts.json"
EXTENSION_LIST=(
  "esbenp.prettier-vscode"
  "ctf0.vscode-text-power-tools"
)

print_header() {
  echo "\n🔧 VSCodium Shortcuts Installer – Violet Pulse\n"
}

install_extensions() {
  echo "📦 Verificando extensiones necesarias..."
  for ext in "${EXTENSION_LIST[@]}"; do
    if ! codium --list-extensions | grep -q "$ext"; then
      echo "➕ Instalando: $ext"
      codium --install-extension "$ext"
    else
      echo "✅ Ya instalada: $ext"
    fi
  done
}

apply_shortcuts() {
  echo "\n🧠 Aplicando shortcuts personalizados..."
  if [ -f "$SHORTCUTS_FILE" ]; then
    cp "$SHORTCUTS_FILE" "$CONFIG"
    echo "🎯 Shortcuts aplicados en: $CONFIG"
  else
    echo "⚠️ No se encontró el archivo $SHORTCUTS_FILE"
  fi
}

print_header
install_extensions
apply_shortcuts
echo "\n🎉 Listo. Reinicia VSCodium para ver los cambios.\n"

