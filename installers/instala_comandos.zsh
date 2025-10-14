# #!/bin/zsh

# # 🧰 Script: instala_comandos.zsh
# # Instala comandos ejecutables en ~/bin/ para shelltools
# # Autor: Datenmaniak

# echo "🔧 Instalando comandos ejecutables para Shelltools..."

# # 📁 Asegurar que ~/bin existe
# mkdir -p ~/bin

# # 📦 Comandos a registrar
# typeset -A comandos
# comandos=(
#   nginxpm "bash ~/shelltools/nginx-projects/nginx-project-manager.sh"
#   nginx-on "zsh ~/shelltools/nginx-projects/easy-commands/enable-nginx-php.zsh"
#   nginx-off "zsh ~/shelltools/nginx-projects/easy-commands/disable-nginx-php.zsh"
#   nginx-restart "zsh ~/shelltools/nginx-projects/easy-commands/restart-nginx-php.zsh"
#   search_files_with "python3 ~/shelltools/search/search_files_with.py"
#   nginx-stop "zsh ~/shelltools/nginx-projects/easy-commands/stop-nginx-php.zsh"
# )

# # 🛠️ Crear ejecutables en ~/bin
# for cmd in "${(@k)comandos}"; do
#   ruta="$HOME/bin/$cmd"
#   echo "${comandos[$cmd]} \"\$@\"" > "$ruta"
#   chmod +x "$ruta"
#   echo "✅ Comando '$cmd' creado en ~/bin/"
# done

# # 🔍 Validar que ~/bin esté en $PATH
# if ! print -l $path | grep -qx "$HOME/bin"; then
#   echo "📎 Agregando ~/bin a tu \$PATH en ~/.zshrc..."
#   echo 'export PATH="$HOME/bin:$PATH"' >> ~/.zshrc
#   echo "✅ PATH actualizado. Recarga con: source ~/.zshrc"
# else
#   echo "✅ ~/bin ya está en tu \$PATH"
# fi

# # 🎨 Mensaje final
# echo "\n🎉 Instalación completada. Puedes usar los comandos directamente:"
# for cmd in "${(@k)comandos}"; do
#   echo "  ➤ $cmd"
# done

# echo "\n🧠 Tip: Usa 'sudo <comando>' si necesitas privilegios elevados."


# # 🔁 ¿Deseas recargar tu shell ahora?
# echo "\n🔄 ¿Deseas recargar tu shell para aplicar los cambios?"
# read "respuesta?Escribe [s] para sí o [n] para no: "

# if [[ "$respuesta" == "s" || "$respuesta" == "S" ]]; then
#   echo "🔃 Recargando shell..."
#   source ~/.zshrc
#   echo "✅ Shell recargado. Los comandos están listos para usarse."
# else
#   echo "ℹ️ Puedes recargar manualmente más tarde con: source ~/.zshrc"
# fi



# ---- nueva version ----

# 🧰 Script: instala_comandos.zsh
# Instala comandos ejecutables en ~/bin/ para shelltools
# Autor: Datenmaniak

# 🛡️ Validar que se está ejecutando en Zsh
if [[ -z "$ZSH_VERSION" ]]; then
  echo "❌ Este script requiere Zsh. Ejecuta con: zsh instala_comandos.zsh"
  exit 1
fi

echo "🔧 Instalando comandos ejecutables para Shelltools..."

# 📁 Validar existencia de ~/bin
if [[ ! -d "$HOME/bin" ]]; then
  echo "📁 El directorio ~/bin no existe. Creando..."
  mkdir -p "$HOME/bin"
else
  echo "✅ Directorio ~/bin encontrado."
fi

# 🔍 Validar que ~/bin esté en $PATH
if ! print -l $path | grep -qx "$HOME/bin"; then
  echo "⚠️ Advertencia: ~/bin no está en tu \$PATH."
  echo "📎 Agregando ~/bin a tu \$PATH en ~/.zshrc..."
  echo 'export PATH="$HOME/bin:$PATH"' >> ~/.zshrc
  echo "✅ PATH actualizado. Recarga con: source ~/.zshrc"
else
  echo "✅ ~/bin ya está en tu \$PATH"
fi

# 📦 Comandos a registrar
typeset -A comandos
comandos=(
  nginxpm "bash ~/shelltools/nginx-projects/nginx-project-manager.sh"
  nginx-on "zsh ~/shelltools/nginx-projects/easy-commands/enable-nginx-php.zsh"
  nginx-off "zsh ~/shelltools/nginx-projects/easy-commands/disable-nginx-php.zsh"
  nginx-restart "zsh ~/shelltools/nginx-projects/easy-commands/restart-nginx-php.zsh"
  nginx-stop "zsh ~/shelltools/nginx-projects/easy-commands/stop-nginx-php.zsh"
  search_files_with "python3 ~/shelltools/search/search_files_with.py"
)

# 🛠️ Crear ejecutables en ~/bin
for cmd in "${(@k)comandos}"; do
  ruta="$HOME/bin/$cmd"
  echo "${comandos[$cmd]} \"\$@\"" > "$ruta"
  chmod +x "$ruta"
  echo "✅ Comando '$cmd' creado en ~/bin/"
done

# 🎉 Instalación completada
echo "\n🎉 Instalación completada. Puedes usar los comandos directamente:"
for cmd in "${(@k)comandos}"; do
  echo "  ➤ $cmd"
done

echo "\n🧠 Tip: Usa 'sudo <comando>' si necesitas privilegios elevados."

# 🔁 ¿Deseas recargar tu shell ahora?
echo "\n🔄 ¿Deseas recargar tu shell para aplicar los cambios?"
read "respuesta?Escribe [s] para sí o [n] para no: "

if [[ "$respuesta" == "s" || "$respuesta" == "S" ]]; then
  echo "🔃 Recargando shell..."
  source ~/.zshrc
  echo "✅ Shell recargado. Los comandos están listos para usarse."
else
  echo "ℹ️ Puedes recargar manualmente más tarde con: source ~/.zshrc"
fi
