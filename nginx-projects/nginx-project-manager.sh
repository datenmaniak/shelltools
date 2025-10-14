#!/bin/bash

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃ Script: nginx-project-manager.sh                        ┃
# ┃ Autor: Datenmaniak                                      ┃
# ┃ Descripción: Gestor modular de proyectos Nginx con      ┃
# ┃ creación, eliminación, revisión y página anfitriona     ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

# 🔐 Validar privilegios de root
if [ "$EUID" -ne 0 ]; then
  echo "⛔ Este script debe ejecutarse como root (usa sudo)"
  exit 1
fi

if ! command -v jq &> /dev/null; then
  echo "❌ El comando 'jq' no está instalado. Instálalo con: sudo apt install jq"
  exit 1
fi


# Detectar el directorio real del usuario que invocó sudo
USER_HOME=$(eval echo "~$SUDO_USER")

echo "📁 Directorio de trabajo: $USER_HOME"


# 📁 Función: Generar index.html básico
generar_index_html() {
  local destino="$1"
  cat > "$destino/index.html" <<HTML
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <title>Index generado</title>
  <style>
    body {
      display: flex;
      flex-direction: column;
      justify-content: center;
      align-items: center;
      height: 100vh;
      font-size: 2em;
      font-family: sans-serif;
      background-color: #f0f0f0;
    }
    a {
      margin-top: 20px;
      font-size: 0.6em;
      text-decoration: none;
      color: #3366cc;
    }
    a:hover {
      text-decoration: underline;
    }
  </style>
</head>
<body>
  Index generado por script...
  <a href="index.php">Mostrar PHP info</a>
</body>
</html>
HTML
}

# 📁 Función: Generar index.php básico
generar_index_php() {
  local destino="$1"
  echo "<?php phpinfo(); ?>" > "$destino/index.php"
}

# 🚀 Función: Crear nuevo proyecto Nginx
crear_proyecto() {
  read -p "Nombre del proyecto: " nombre
  read -p "Ruta absoluta del proyecto: " ruta
  read -p "Puerto a asignar: " puerto

  nombre_sanitizado=$(echo "$nombre" | iconv -f utf8 -t ascii//TRANSLIT | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g' | sed -E 's/^-+|-+$//g')

  if [ ! -d "$ruta" ]; then
    echo "❌ La ruta no existe: $ruta"
    return
  fi

  has_html=false
  has_php=false
  [ -f "$ruta/index.html" ] && has_html=true
  [ -f "$ruta/index.php" ] && has_php=true

  if [ "$has_html" = false ] && [ "$has_php" = false ]; then
    echo "⚠️ No se encontró index.html ni index.php. Generando ambos..."
    generar_index_html "$ruta"
    generar_index_php "$ruta"
    has_html=true
    has_php=true
  fi

  ln_path="/srv/nginx/$nombre_sanitizado"
  ln -s "$ruta" "$ln_path"
  echo "🔗 Enlace simbólico creado: $ln_path → $ruta"

  if ss -tuln | grep ":$puerto " > /dev/null; then
    echo "❌ El puerto $puerto ya está en uso"
    return
  fi

  verificar_php_fpm

  conf_path="/etc/nginx/conf.d/$nombre_sanitizado.conf"
  tee "$conf_path" > /dev/null <<EOF
# Proyecto: $nombre

server {
    listen $puerto;
    server_name localhost;

    root $ln_path;
    index index.html index.php;

    location / {
        try_files \$uri \$uri/ $( [ "$has_html" = true ] && echo "/index.html" || echo "/index.php" );
    }

    location ~ \.php\$ {
        include fastcgi_params;
        fastcgi_pass unix:/run/php-fpm/www.sock;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
    }
}
EOF

  echo "📝 Archivo de configuración creado: $conf_path"
  nginx -t && systemctl reload nginx && echo "🚀 Nginx recargado con éxito"


  # agrega_proyecto_a_hostpage "$nombre" "$puerto"
  agrega_proyecto_a_json "$nombre" "$puerto"


}

# 🗑️ Función: Eliminar proyecto
eliminar_proyecto() {
  read -p "Nombre del proyecto a eliminar: " nombre
  nombre_sanitizado=$(echo "$nombre" | iconv -f utf8 -t ascii//TRANSLIT | tr '[:lower:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g' | sed -E 's/^-+|-+$//g')

  rm -f "/etc/nginx/conf.d/$nombre_sanitizado.conf"
  rm -f "/srv/nginx/$nombre_sanitizado"
  echo "🗑️ Proyecto eliminado: $nombre_sanitizado"
  nginx -t && systemctl reload nginx && echo "🔄 Nginx recargado"


  # elimina_proyecto_de_hostpage "$nombre"

  elimina_proyecto_de_json "$nombre"


}

# 🔍 Función: Revisar si el proyecto existe
revisar_proyecto() {
  read -p "Nombre del proyecto a revisar: " nombre
  nombre_sanitizado=$(echo "$nombre" | iconv -f utf8 -t ascii//TRANSLIT | tr '[:lower:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g' | sed -E 's/^-+|-+$//g')

  conf="/etc/nginx/conf.d/$nombre_sanitizado.conf"
  enlace="/srv/nginx/$nombre_sanitizado"

  if [ -f "$conf" ] && [ -L "$enlace" ]; then
    echo "✅ El proyecto '$nombre_sanitizado' existe y está configurado"
  else
    echo "❌ El proyecto '$nombre_sanitizado' no está configurado correctamente"
  fi
}

# 🧠 Función: Verificar estado de PHP-FPM
verificar_php_fpm() {
  echo "🔍 Verificando estado de PHP-FPM..."
  if ! systemctl is-active --quiet php-fpm; then
    echo "⚠️ PHP-FPM está detenido. Intentando iniciar..."
    systemctl start php-fpm
    if systemctl is-active --quiet php-fpm; then
      echo "✅ PHP-FPM iniciado correctamente"
    else
      echo "❌ No se pudo iniciar PHP-FPM. Verifica el servicio manualmente."
      exit 1
    fi
  else
    echo "✅ PHP-FPM ya está activo"
  fi
}

# 🏠 Función: Crear página anfitriona HTML
crear_pagina_anfitriona() {
  local ruta_html="$USER_HOME/hostpage/index.html"
  local enlace="/srv/nginx/host"
  local DIRHOST="$USER_HOME/hostpage"

  if [[ -d $DIRHOST ]]; then
    echo "✔ El directorio de la página anfitriona ya existe en $DIRHOST"
  else
    sudo -u "$SUDO_USER" mkdir -p "$DIRHOST"
    sudo chown -R "$SUDO_USER":"$SUDO_USER" "$DIRHOST"


    echo "✔ Creado directorio anfitrión en $DIRHOST"
  fi

  if [[ -f "$ruta_html" ]]; then
    echo "✔ La página anfitriona ya existe en $ruta_html"
    return
  fi

  cat > "$ruta_html" <<EOF
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <title>Proyectos Web</title>
  <style>
    body { font-family: sans-serif; background: #1a1a1a; color: #eee; }
    table { width: 100%; border-collapse: collapse; margin-top: 20px; }
    th, td { padding: 10px; border-bottom: 1px solid #444; }
    a { color: #9f5fff; text-decoration: none; }
  </style>
</head>
<body>
  <h1>Proyectos activos</h1>
  <table id="tabla-proyectos">
    <thead><tr><th>Nombre</th><th>Acceso</th></tr></thead>
    <tbody>
      <!-- PROYECTOS -->
    </tbody>
  </table>
</body>
</html>
EOF

  ln -s "$USER_HOME/hostpage" "$enlace"
  echo "✔ Página anfitriona creada en $ruta_html y enlazada en $enlace"
}

# ➕ Función: Agregar proyecto a la tabla HTML
agrega_proyecto_a_hostpage() {
  local nombre="$1"
  local puerto="$2"
  local ruta_html="$HOME/hostpage/index.html"

  if [[ ! -f "$ruta_html" ]]; then
    echo "⚠ La página anfitriona no existe. Ejecuta primero la opción para crearla."
    return 1
  fi

  if grep -q "<td>${nombre}</td>" "$ruta_html"; then
    echo "ℹ El proyecto '${nombre}' ya está listado en la página anfitriona."
    return 0
  fi

    local fila="      <tr><td>${nombre}</td><td><a href='http://localhost:${puerto}/' target='_blank'>Abrir</a></td></tr>"
  sed -i "/<!-- PROYECTOS -->/a ${fila}" "$ruta_html"
  echo "✔ Proyecto '${nombre}' agregado a la página anfitriona."
}

elimina_proyecto_de_hostpage() {
  local nombre="$1"
  local ruta_html="$HOME/hostpage/index.html"

  if [[ ! -f "$ruta_html" ]]; then
    echo "⚠ La página anfitriona no existe."
    return 1
  fi

  sed -i "/<tr><td>${nombre}<\\/td>/d" "$ruta_html"
  echo "🗑 Proyecto '${nombre}' eliminado de la página anfitriona."
}

# 🌐 Función: Crear configuración Nginx para la página anfitriona
crear_configuracion_hostpage() {
  local conf="/etc/nginx/conf.d/hostpage.conf"
  local puerto=1000

  if [[ -f "$conf" ]]; then
    echo "✔ Configuración Nginx para la página anfitriona ya existe."
    return
  fi

  sudo tee "$conf" > /dev/null <<EOF
server {
    listen ${puerto};
    server_name localhost;

    root /srv/nginx/host;
    index index.html;

    location / {
        try_files \$uri \$uri/ =404;
    }
}
EOF

  sudo nginx -t && sudo systemctl reload nginx
  echo "✔ Página anfitriona servida en http://localhost:${puerto}/"
}

# 🎨 Función: Generar index.html para la página anfitriona con estilo Violet Pulse
generar_index_hostpage() {

  crear_json

  local destino="$1"

  cat > "$destino/index.html" <<'EOF'
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <title>Proyectos Web</title>
  <style>
    body {
      font-family: 'Segoe UI', sans-serif;
      margin: 0;
      padding: 0;
      background: linear-gradient(135deg, #f3e8ff, #e0ccff);
      color: #1a1a1a;
    }

    header {
      background-color: #7700F0;
      color: white;
      padding: 1.5rem;
      text-align: center;
      box-shadow: 0 4px 8px rgba(0,0,0,0.2);
    }

    h1 {
      margin: 0;
      font-size: 2rem;
    }

    table {
      width: 90%;
      margin: 2rem auto;
      border-collapse: collapse;
      background-color: white;
      border-radius: 8px;
      box-shadow: 0 4px 12px rgba(119, 0, 240, 0.1);
    }

    th, td {
      padding: 1rem;
      border-bottom: 1px solid #ddd;
      text-align: left;
    }

    th {
      background-color: #a066ff;
      color: white;
    }

    a {
      color: #7700F0;
      text-decoration: none;
      font-weight: bold;
    }

    a:hover {
      text-decoration: underline;
    }
  </style>
</head>
<body>
  <header>
    <h1>Proyectos activos</h1>
  </header>

  <table id="tabla-proyectos">
    <thead><tr><th>Nombre</th><th>Acceso</th></tr></thead>
    <tbody></tbody>
  </table>

  <script>
    fetch('proyectos.json')
      .then(response => response.json())
      .then(data => {
        const tbody = document.querySelector('#tabla-proyectos tbody');
        data.forEach(proyecto => {
          const fila = document.createElement('tr');
          fila.innerHTML = `
            <td>${proyecto.nombre}</td>
            <td><a href="http://localhost:${proyecto.puerto}/" target="_blank">Abrir</a></td>
          `;
          tbody.appendChild(fila);
        });
      });
  </script>
</body>
</html>
EOF
}

#  Crear registros de proyectos
crear_json() {
    DB="$USER_HOME/hostpage/proyectos.json"

    if [[ -f "$DB" ]]; then
    echo "✔ Base de datos de proyectos Web ya existe."
    return
  fi
  echo "[]" > "$DB"


}

# ➕ Función: Agregar proyecto a proyectos.json
agrega_proyecto_a_json() {
  local nombre="$1"
  local puerto="$2"
  local json="$USER_HOME/hostpage/proyectos.json"

  # Si no existe, lo inicializa como array vacío
  if [[ ! -f "$json" ]]; then
    echo "[]" > "$json"
  fi

  # Verifica si ya existe
  if jq -e --arg nombre "$nombre" '.[] | select(.nombre == $nombre)' "$json" > /dev/null; then
    echo "ℹ El proyecto '$nombre' ya está registrado en proyectos.json"
    return
  fi

  # Agrega el nuevo proyecto
  jq --arg nombre "$nombre" --arg puerto "$puerto" \
    '. += [{"nombre": $nombre, "puerto": ($puerto | tonumber)}]' \
    "$json" > "$json.tmp" && mv "$json.tmp" "$json"

  echo "✔ Proyecto '$nombre' agregado a proyectos.json"
}

# 🗑️ Función: Eliminar proyecto de proyectos.json
elimina_proyecto_de_json() {
  local nombre="$1"
  local json="$USER_HOME/hostpage/proyectos.json"

  if [[ ! -f "$json" ]]; then
    echo "⚠ proyectos.json no existe."
    return
  fi

  # Elimina el proyecto por nombre
  jq --arg nombre "$nombre" \
    'del(.[] | select(.nombre == $nombre))' \
    "$json" > "$json.tmp" && mv "$json.tmp" "$json"

  echo "🗑 Proyecto '$nombre' eliminado de proyectos.json"
}

# 📄 Función: Listar proyectos guardados en proyectos.json
# 📄 Función: Listar proyectos guardados en proyectos.json con validación
listar_proyectos_guardados() {
  local json="$USER_HOME/hostpage/proyectos.json"

  if [[ ! -f "$json" ]]; then
    echo "⚠ No se encontró el archivo proyectos.json en $USER_HOME/hostpage"
    return 1
  fi

  # Validar que el archivo sea un array JSON válido
  if ! jq empty "$json" 2>/dev/null; then
    echo "❌ El archivo proyectos.json está corrupto o mal formado."
    read -p "¿Deseas regenerarlo como lista vacía? [s/N]: " respuesta
    if [[ "$respuesta" =~ ^[sS]$ ]]; then
      echo "[]" > "$json"
      echo "✔ Archivo proyectos.json regenerado como lista vacía."
    else
      echo "🚫 Operación cancelada."
    fi
    return 1
  fi

  # Verificar si está vacío
  if [[ $(jq length "$json") -eq 0 ]]; then
    echo "📭 No hay proyectos registrados actualmente."
    return 0
  fi

  echo "📦 Proyectos registrados:"
  jq -r '.[] | "🔹 \(.nombre) → Puerto: \(.puerto)"' "$json"
}

elimina_dir_hostpage() {

  if [[ -d "$USER_HOME/hostpage" ]]; then
       [ "$(ls -A $USER_HOME/hostpage)" ] && echo "Not Empty" || echo "Empty"
       echo "🚫 Operación cancelada. Hay archivos, revise el contenido primero.!"
       return
  else
     echo "✔ Directorio vacio. Eliminado $USER_HOME/hostpage."
     rm -rf "$USER_HOME/hostpage"
  fi
}

while true; do
  echo ""
  echo "🧭 Menú de gestión de proyectos Nginx"
  echo "1) Crear proyecto"
  echo "2) Eliminar proyecto"
  echo "3) Revisar si existe"
  echo "4) Crear página anfitriona centralizada"
  echo "5) Listar proyectos guardados"
  echo "6) Eliminar directorio hostpage"
  echo "0) Salir"
  read -p "Selecciona una opción [0-4]: " opcion

  case $opcion in
    0) echo "👋 Saliendo..." ; exit 0 ;;
    1) crear_proyecto ;;
    2) eliminar_proyecto ;;
    3) revisar_proyecto;;
    4) crear_pagina_anfitriona
       generar_index_hostpage "$USER_HOME/hostpage"
       crear_configuracion_hostpage ;;
    5) listar_proyectos_guardados ;;
    6) elimina_dir_hostpage;;
    *) echo "❌ Opción inválida" ;;
  esac
done

