#!/usr/bin/env bash

# 🟣 Violet Pulse VSCodium Setup Script (modularizado)
# Ruta: ~/shelltools/web-development/vscodium/setup.sh

set -e

echo "🔍 Verificando si VSCodium está instalado..."

if ! command -v codium &> /dev/null; then
  echo "⚠️ VSCodium no está instalado en este sistema."
  echo "ℹ️ Instálalo manualmente desde:"
  echo "   https://github.com/VSCodium/vscodium/releases"
  echo "🚫 Este módulo requiere VSCodium para continuar. Saliendo..."
  exit 1
fi

echo "📦 Instalando extensiones para lenguajes y herramientas..."

extensions=(
  "mads-hartmann.bash-ide-vscode"
  "foxundermoon.shell-format"
  "ms-python.python"
  "ms-python.black-formatter"
  "ms-python.isort"
  "bmewburn.vscode-intelephense-client"
  "syler.sass-indented"
  "ecmel.vscode-html-css"
  "stylelint.vscode-stylelint"
  "dbaeumer.vscode-eslint"
  "esbenp.prettier-vscode"
  "xabikos.javascriptsnippets"
  "abusaidm.html-snippets"
  "vscode-emmet-helper"
  "yzhang.markdown-all-in-one"
  "redhat.vscode-yaml"
  "ms-azuretools.vscode-docker"
  "eamodio.gitlens"
  "oderwat.indent-rainbow"
  "coenraads.bracket-pair-colorizer-2"
  "zhuangtongfa.material-theme"
  "pkief.material-icon-theme"
)

for ext in "${extensions[@]}"; do
  codium --install-extension "$ext" || echo "⚠️ Falló: $ext"
done

echo "🎨 Aplicando tema Violet Pulse claro..."

mkdir -p ~/.config/VSCodium/User

cat <<EOF > ~/.config/VSCodium/User/settings.json
{
  "workbench.colorTheme": "One Light Pro",
  "workbench.iconTheme": "material-icon-theme",
  "editor.fontFamily": "Fira Code, monospace",
  "editor.fontLigatures": true,
  "editor.tabSize": 2,
  "editor.formatOnSave": true,
  "editor.lineHeight": 16,
  "files.autoSave": "onFocusChange",
  "terminal.integrated.fontFamily": "monospace",
  "editor.tokenColorCustomizations": {
    "textMateRules": [
      {
        "scope": ["keyword", "storage"],
        "settings": { "foreground": "#9b59b6" }
      },
      {
        "scope": ["variable", "string"],
        "settings": { "foreground": "#8e44ad" }
      }
    ]
  }
}
EOF

echo "✅ VSCodium configurado con Violet Pulse y soporte para múltiples lenguajes."
