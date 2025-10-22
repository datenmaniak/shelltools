#!/usr/bin/env bash
# Violet Pulse - Instalador de temas para VSCodium
# Requiere: VSCodium con CLI habilitado (`codium` en PATH)

set -euo pipefail

echo "🎨 Instalando temas recomendados para reducir fatiga visual..."

# Lista de extensiones de temas
themes=(
  "akamud.vscode-theme-onedark"           # One Dark Pro (suave, legible)
  "zhuangtongfa.Material-theme"           # One Dark+ y variantes Material
  "GitHub.github-vscode-theme"            # GitHub Dark Dimmed
  "dracula-theme.theme-dracula"           # Dracula (contraste equilibrado)
  "teabyii.ayu"                           # Ayu Mirage (tono cálido)
)

for theme in "${themes[@]}"; do
  echo "➤ Instalando $theme..."
  codium --install-extension "$theme" --force
done

echo "✅ Temas instalados. Puedes cambiar entre ellos en Preferencias → Tema de Color."

