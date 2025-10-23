#!/bin/zsh

CONFIG="$HOME/.config/VSCodium/User/keybindings.json"
BACKUP="$CONFIG.bak.$(date +%s)"
SHORTCUTS_FILE="./shortcuts.json"
EXTENSION_LIST=(
  "esbenp.prettier-vscode"
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

backup_and_apply_shortcuts() {
  echo "\n🧠 Aplicando shortcuts personalizados..."
  if [ -f "$CONFIG" ]; then
    cp "$CONFIG" "$BACKUP"
    echo "🗂️ Backup creado: $BACKUP"
  fi

  if [ -f "$SHORTCUTS_FILE" ]; then
    cp "$SHORTCUTS_FILE" "$CONFIG"
    echo "🎯 Shortcuts aplicados en: $CONFIG"
  else
    echo "⚠️ No se encontró el archivo $SHORTCUTS_FILE"
  fi
}

print_header
install_extensions
backup_and_apply_shortcuts
echo "\n🎉 Listo. Reinicia VSCodium para ver los cambios.\n"

