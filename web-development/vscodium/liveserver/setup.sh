#!/bin/bash

# setup-liveserver.sh
# Configura el navegador de Live Server en VSCodium o VSCode.
# Genera o documenta index.html con tabla de configuración.
# Requiere: jq, xdg-utils

# Detectar instalación de VSCodium o VSCode
if command -v codium &>/dev/null; then
  CONFIG_PATH="$HOME/.config/VSCodium/User/settings.json"
  EDITOR="VSCodium"
elif command -v code &>/dev/null; then
  CONFIG_PATH="$HOME/.config/Code/User/settings.json"
  EDITOR="VSCode"
else
  echo "❌ Ni VSCodium ni VSCode están instalados. Abortando."
  exit 1
fi

# Lista de navegadores disponibles
declare -A browsers=(
  ["1"]="chrome"
  ["2"]="firefox"
  ["3"]="firefox-developer"
  ["4"]="brave"
  ["5"]="edge"
  ["6"]="chromium"
  ["7"]="none"
  ["8"]="default"
  ["9"]="salir"
)

# Comandos esperados para cada navegador
declare -A browser_commands=(
  ["chrome"]="google-chrome"
  ["firefox"]="firefox"
  ["firefox-developer"]="firefox-aurora"
  ["brave"]="brave-browser"
  ["edge"]="microsoft-edge-stable"
  ["chromium"]="chromium-browser"
  ["none"]=""
  ["default"]=""
  ["salir"]=""
)

# Función para mapear navegador predeterminado
map_default_browser() {
  case "$1" in
    "microsoft-edge.desktop") echo "microsoft-edge-stable" ;;
    "firefox.desktop") echo "firefox" ;;
    "google-chrome.desktop") echo "google-chrome" ;;
    "brave-browser.desktop") echo "brave-browser" ;;
    "chromium-browser.desktop") echo "chromium-browser" ;;
    *) echo "" ;;
  esac
}

echo "🧭 Editor detectado: $EDITOR"
echo "Selecciona el navegador para Live Server:"
for i in $(seq 1 ${#browsers[@]}); do
  echo "$i) ${browsers[$i]}"
done

read -p "Opción: " choice
selected_browser="${browsers[$choice]}"
browser_cmd="${browser_commands[$selected_browser]}"

if [ "$selected_browser" == "salir" ]; then
  echo "🚪 Saliendo sin realizar cambios."
  exit 0
fi

if [ -z "$selected_browser" ]; then
  echo "❌ Opción inválida. Abortando."
  exit 1
fi

# Detectar navegador predeterminado si se elige 'default'
if [ "$selected_browser" == "default" ]; then
  default_browser=$(xdg-settings get default-web-browser 2>/dev/null)
  browser_cmd=$(map_default_browser "$default_browser")
  if [ -z "$browser_cmd" ]; then
    echo "⚠️ No se pudo mapear el navegador predeterminado del sistema."
    exit 1
  fi
  echo "🌐 Navegador predeterminado detectado: $browser_cmd"
fi

# Validar si el navegador está instalado (excepto 'none')
if [ "$selected_browser" != "none" ]; then
  if ! command -v "$browser_cmd" &>/dev/null; then
    echo "⚠️ El navegador '$browser_cmd' no está instalado o no se encuentra en el PATH."
    echo "Puedes instalarlo o elegir otro navegador."
    exit 1
  fi
fi



generate_css() {
  local CSS_PATH="./style.css"
   echo "📄 Generando nuevo style.css ..."
     cat <<EOF > "$CSS_PATH"
/* style.css — Estilos para index.html generado por setup-liveserver.sh */
body {
  font-family: "Segoe UI", sans-serif;
  background-color: #f9f9f9;
  color: #333;
  margin: 2rem;
}
h1 {
  color: #4b0082;
  font-size: 1.8rem;
  margin-bottom: 1rem;
}

section {
  margin-top: 1.5rem;
}

table {
  width: 100%;
  border-collapse: collapse;
  background-color: #fff;
  box-shadow: 0 0 8px rgba(0, 0, 0, 0.1);
}

thead th {
  background-color: #4b0082;
  color: #fff;
  font-weight: bold;
  padding: 0.75rem;
  text-align: left;
}

tbody td {
  padding: 0.75rem;
  border: 1px solid #ccc;
}

tbody tr:nth-child(even) {
  background-color: #f0f0f0;
}

tbody td[colspan="2"] {
  text-align: center;
  font-weight: bold;
  color: #666;
  background-color: #eaeaea;
  border-top: 2px solid #4b0082;
  border-bottom: 2px solid #4b0082;
}
EOF
}

# REMOVE 
# # Validar estructura JSON antes de modificar
# if ! jq empty "$CONFIG_PATH" 2>/dev/null; then
#   echo "⚠️ El archivo settings.json está corrupto. Se regenerará."
#   echo "{}" > "$CONFIG_PATH"
# fi

# # Crear respaldo del settings.json antes de modificar
# BACKUP_PATH="${CONFIG_PATH}.bak.$(date +%Y%m%d%H%M%S)_before_${browser_cmd}"
# cp "$CONFIG_PATH" "$BACKUP_PATH"
# echo "🗂️ Respaldo creado en: $BACKUP_PATH"
# remove 

# Crear respaldo del settings.json antes de modificar
BACKUP_PATH="${CONFIG_PATH}.bak.$(date +%Y%m%d%H%M%S)_before_${browser_cmd}"
cp "$CONFIG_PATH" "$BACKUP_PATH"
echo "🗂️ Respaldo creado en: $BACKUP_PATH"

# Validar estructura JSON después de respaldar
if ! jq empty "$CONFIG_PATH" 2>/dev/null; then
  echo "⚠️ El archivo settings.json está corrupto. Se regenerará desde cero."
  echo "{}" > "$CONFIG_PATH"
fi



# Fusión segura con configuración existente
jq --arg browser "$browser_cmd" \
  '. + { "liveServer.settings.CustomBrowser": $browser }' \
  "$CONFIG_PATH" > "$CONFIG_PATH.tmp" && mv "$CONFIG_PATH.tmp" "$CONFIG_PATH"

echo "✅ Navegador '$browser_cmd' asociado correctamente a Live Server en $EDITOR."
echo "🔁 Reinicia $EDITOR para que los cambios surtan efecto."

# Función para generar o documentar index.html con tabla
generar_index_html() {
  local INDEX_PATH="./index.html"
  local fecha_actual=$(date +"%d/%m/%Y %H:%M")

  # Genera los estilos si no existe
  if [ ! -f "$CSS_PATH" ]; then
      generate_css
    echo "✅ style.css creado."

  fi
    

  if [ ! -f "$INDEX_PATH" ]; then
    echo "📄 Generando nuevo index.html..."
    cat <<EOF > "$INDEX_PATH"
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <title>Live Server Configurado</title>
  <link rel="stylesheet" href="style.css">
</head>
<body>
  <h1>Live Server configurado</h1>
  <section>
    <table border="1" cellpadding="6" cellspacing="0">
      <thead>
        <tr><th colspan="2">Detalles de configuración</th></tr>
      </thead>
      <tbody>
        <tr><td colspan="2">──────────────</td></tr>
        <tr><td>Navegador asignado</td><td>$browser_cmd ($fecha_actual)</td></tr>
        <tr><td>Editor detectado</td><td>$EDITOR</td></tr>
        <tr><td>Archivo modificado</td><td>$CONFIG_PATH</td></tr>
        <tr><td>Respaldo creado</td><td>$BACKUP_PATH</td></tr>
        <tr><td>Reinicio requerido</td><td>Sí</td></tr>
      </tbody>
    </table>
  </section>
</body>
</html>
EOF
    echo "✅ index.html creado con tabla de documentación."
  else
    echo "📝 Verificando si existe una tabla con <tbody>..."
    if grep -q "</tbody>" "$INDEX_PATH"; then
      echo "➕ Agregando filas a la tabla existente..."
      sed -i '/<\/tbody>/i \
<tr><td colspan="2">──────────────</td></tr>\
<tr><td>Navegador</td><td>'"$browser_cmd"' ('"$fecha_actual"')</td></tr>\
<tr><td>Editor</td><td>'"$EDITOR"'</td></tr>\
<tr><td>Archivo modificado</td><td>'"$CONFIG_PATH"'</td></tr>\
<tr><td>Respaldo</td><td>'"$BACKUP_PATH"'</td></tr>\
<tr><td>Reinicio requerido</td><td>Sí</td></tr>' "$INDEX_PATH"
      echo "✅ Filas agregadas a la tabla existente."
    else
      echo "⚠️ No se encontró <tbody>. Insertando tabla completa antes de </body>..."
      sed -i '/<\/body>/i \
<!-- Live Server configurado por setup-liveserver.sh -->\
<section>\
  <table border="1" cellpadding="6" cellspacing="0">\
    <thead><tr><th colspan="2">Actualización de configuración</th></tr></thead>\
    <tbody>\
      <tr><td colspan="2">──────────────</td></tr>\
      <tr><td>Navegador</td><td>'"$browser_cmd"' ('"$fecha_actual"')</td></tr>\
      <tr><td>Editor</td><td>'"$EDITOR"'</td></tr>\
      <tr><td>Archivo modificado</td><td>'"$CONFIG_PATH"'</td></tr>\
      <tr><td>Respaldo</td><td>'"$BACKUP_PATH"'</td></tr>\
      <tr><td>Reinicio requerido</td><td>Sí</td></tr>\
    </tbody>\
  </table>\
</section>' "$INDEX_PATH"
      echo "✅ Tabla completa insertada en index.html existente."
    fi
  fi
}

# Llamado a la función
generar_index_html
