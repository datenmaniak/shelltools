#!/bin/zsh

CONFIG="$HOME/.config/VSCodium/User/keybindings.json"
EXTENSION_LIST=(
  "esbenp.prettier-vscode"
  "tombonnike.vscode-remove-empty-lines"
)

SHORTCUTS='[
  {
    "key": "ctrl+alt+j",
    "command": "editor.action.formatDocument"
  },
  {
    "key": "ctrl+alt+m",
    "command": "editor.action.selectHighlights"
  },
  {
    "key": "ctrl+shift+t",
    "command": "workbench.action.terminal.toggleTerminal"
  },
  {
    "key": "ctrl+alt+e",
    "command": "editor.action.removeEmptyLines"
  },
  {
    "key": "ctrl+shift+o",
    "command": "workbench.action.gotoSymbol"
  },
  {
    "key": "ctrl+alt+p",
    "command": "workbench.action.openFolder"
  }
]'

echo "🔧 Verificando extensiones necesarias..."
for ext in "${EXTENSION_LIST[@]}"; do
  if ! codium --list-extensions | grep -q "$ext"; then
    echo "📦 Instalando extensión: $ext"
    codium --install-extension "$ext"
  else
    echo "✅ Extensión ya instalada: $ext"
  fi
done

echo "🧠 Agregando shortcuts a VSCodium..."
echo "$SHORTCUTS" > "$CONFIG"

echo "🎉 Shortcuts aplicados. Puedes reiniciar VSCodium para ver los cambios."

