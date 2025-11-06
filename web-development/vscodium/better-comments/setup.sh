#!/usr/bin/env bash

EXTENSION_ID="aaron-bond.better-comments"
VSCODIUM_CONFIG_DIR="$HOME/.config/VSCodium/User"
SETTINGS_FILE="$VSCODIUM_CONFIG_DIR/settings.json"
BACKUP_FILE="$SETTINGS_FILE.bak.$(date +%Y%m%d%H%M%S)"

echo "🔍 Verificando VSCodium..."
if ! command -v codium &> /dev/null; then
  echo "❌ VSCodium no está instalado."
  exit 1
fi

echo "📦 Instalando extensión Better Comments si no está presente..."
if ! codium --list-extensions | grep -q "$EXTENSION_ID"; then
  codium --install-extension "$EXTENSION_ID"
  echo "✅ Extensión instalada."
else
  echo "✅ Extensión ya instalada."
fi

echo "📁 Verificando archivo settings.json..."
mkdir -p "$VSCODIUM_CONFIG_DIR"
[ ! -f "$SETTINGS_FILE" ] && echo "{}" > "$SETTINGS_FILE"

cp "$SETTINGS_FILE" "$BACKUP_FILE"
echo "📦 Respaldo creado: $BACKUP_FILE"

echo "🧠 Insertando configuración de etiquetas personalizadas..."
jq '. + {
  "better-comments.tags": [
  {
    "tag": "TODO",
    "color": "#FFFFFF",
    "backgroundColor": "#7700F0",
    "bold": true
  },
  {
    "tag": "REMOVE",
    "color": "#FFFFFF",
    "backgroundColor": "#FF0033",
    "bold": true
  },
  {
    "tag": "LEARN",
    "color": "#000000",
    "backgroundColor": "#FF9900",
    "bold": true
  },
   {
    "tag": "BEGIN",
    "color": "#000000",
    "backgroundColor": "#EDF000",
    "bold": true
  },
  {
    "tag": "END",
    "color": "#000000",
    "backgroundColor": "#EDF000",
    "bold": true
  }
]
}' "$SETTINGS_FILE" > "$SETTINGS_FILE.tmp" && mv "$SETTINGS_FILE.tmp" "$SETTINGS_FILE"

echo "🎉 ¡Listo! Reinicia VSCodium y abre preview-snippets.code para validar los colores Violet Pulse."
