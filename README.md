# 🧰 Shelltools

**Shelltools** es una colección modular de herramientas de consola creadas por Datenmaniak para potenciar entornos Zsh/Bash con automatización, validación, estética personalizada y seguridad avanzada. Cada script está diseñado para integrarse de forma elegante en flujos técnicos, respetando el contexto del usuario, el entorno gráfico y el branding personal Violet Pulse.

Este ecosistema surge de la necesidad de tener herramientas reutilizables, documentadas y robustas que acompañen la configuración de dotfiles sin mezclarse con ella. Shelltools no configura el entorno: lo extiende, lo diagnostica y lo embellece.

---

## 🧠 Filosofía

- 🔒 **Seguridad primero**: validación de entorno, permisos, ACLs y contexto `sudo`.
- 🧩 **Modularidad**: cada herramienta vive en su propio subdirectorio, con documentación y wrappers opcionales.
- 🎨 **Branding**: integración visual con la estética Violet Pulse.
- ⚙️ **Automatización**: comandos rápidos, scripts interactivos y funciones reutilizables.

---

## 📁 Estructura

- `acl-checker/` → Scripts para verificar y aplicar ACLs.
- `branding/` → Prompts, banners y elementos visuales personalizados.
- `environment/` → Detección de entorno gráfico, usuario real, `$HOME`, etc.
- `nginx-projects/` → Gestión de proyectos web con Nginx.
  - `easy-commands/` → Comandos rápidos para Nginx + PHP-FPM.
  - `nginx-project-manager.sh` → Script interactivo para crear/eliminar proyectos.
- `search/` → Herramientas de búsqueSa como.files with codeword>py`.
- `web-development/` → Utilidades específicas para desarrollo web.

---

## 🚀 Integración con Zsh/Bash

Puedes invocar cualquier herramienta desde tu shell con alias o funciones. Ejemplo:


```zsh
alias buscar_palabra='python3 ~/shelltools/search/search_files_with.py'
```
```
alias nginxpm='bash ~/shelltools/nginx-projects/nginx-project-manager.sh'
```


## 🔍 Módulo: search

Este módulo contiene herramientas para búsqueda de contenido dentro de archivos, útil para diagnosticar configuraciones, encontrar patrones, validar entornos o auditar proyectos.

```
    search_files_with.py <keyword> <directory>
```

Script en Python que busca una palabra clave en todos los archivos de un directorio, de forma recursiva.

### 🚀 Uso desde consola

```
bash python3 search_files_with.py <palabra_clave> <directorio>
```

### 🧩 Integración con Zsh

Puedes invocar el script como alias desde tu .zshrc:

```
alias buscar_palabra='python3 ~/shelltools/search/search_files_with.py'

```
O como función con validación:

```
buscar_palabra() {
  if [[ $# -ne 2 ]]; then
    echo "Uso: buscar_palabra <palabra_clave> <directorio>"
    return 1
  fi
  python3 ~/shelltools/search/search_files_with.py "$1" "$2"
}
```
## 🧩 Módulo: nginx-projects

Herramientas para gestionar proyectos web con Nginx de forma automatizada, segura y modular. Este módulo permite crear, eliminar y administrar configuraciones Nginx, integrando validaciones de entorno, ACLs, enlaces simbólicos y una página anfitriona centralizada.

---

### 📄 nginx-project-manager.sh

Script interactivo que permite:

- Crear proyectos con configuración Nginx y puerto personalizado
- Eliminar proyectos y limpiar configuración
- Agregar/quitar entradas en una página anfitriona (`hostpage`)
- Validar permisos, entorno gráfico y contexto `sudo`
- Integración con branding Violet Pulse

### 🚀 Uso desde consola

``` bash
bash ~/shelltools/nginx-projects/nginx-project-manager.sh
```
## ⚡ easy-commands

Comandos rápidos para gestionar servicios Nginx y PHP-FPM desde la consola, sin necesidad de menú interactivo. Pensados para integrarse como alias o funciones en tu shell, permitiendo activación, desactivación y reinicio inmediato de tu stack web local.

---

### 📄 Scripts incluidos

- `enable-nginx-php.zsh` → Activa los servicios `nginx` y `php-fpm`
- `disable-nginx-php.zsh` → Detiene ambos servicios
- `restart-nginx-php.zsh` → Reinicia ambos servicios

---

### 🚀 Uso desde consola

```bash
zsh enable-nginx-php.zsh
zsh disable-nginx-php.zsh
zsh restart-nginx-php.zsh
```
## 🧠 Alias sugeridos para Shelltools/nginx

Lista de alias recomendados para integrar los scripts de `shelltools` en tu entorno Zsh/Bash. Estos alias permiten invocar herramientas rápidamente desde la consola, sin necesidad de navegar por directorios.

---

#### ⚡ nginx-projects / easy-commands

```
alias nginx-on='zsh ~/shelltools/nginx-projects/easy-commands/enable-nginx-php.zsh'
```
```
alias nginx-off='zsh ~/shelltools/nginx-projects/easy-commands/disable-nginx-php.zsh'
```
```
alias nginx-restart='zsh ~/shelltools/nginx-projects/easy-commands/restart-nginx-php.zsh'
```
```
alias nginx-stop='zsh ~/shelltools/nginx-projects/easy-commands/stop-nginx-php.zsh'
```

🧩 nginx-project-manager
```
alias nginxpm='bash ~/shelltools/nginx-projects/nginx-project-manager.sh'
```


## Próximo a agregar
🧪 environment (ejemplo)

```
alias detecta_sudo='zsh ~/shelltools/environment/detecta_sudo_context.zsh'
alias verifica_home='zsh ~/shelltools/environment/verifica_home_real.zsh'
```

🎨 branding (ejemplo)
```
alias banner-violet='python3 ~/shelltools/branding/genera_banner.py'
alias prompt-violet='zsh ~/shelltools/branding/prompt_personalizado.zsh'
```

---

## 🛠️ En caso de errores

### ✗ `sudo: nginxpm: command not found`

Este error ocurre porque los alias definidos en tu shell (`.zshrc`, `.bashrc`) **no se heredan automáticamente** cuando usas `sudo`. El sistema busca un comando real llamado `nginxpm`, y al no encontrarlo en `$PATH`, lanza el error.

---

### ✅ Soluciones recomendadas

#### 🔹 Opción 1: Ejecutar directamente con `sudo`

```bash
sudo bash ~/shelltools/nginx-projects/nginx-project-manager.sh
```

#### 🔹 Opción 2: Crear un comando ejecutable en tu $PATH

1. Crea el archivo nginxpm en ~/bin/:

```
mkdir -p ~/bin
echo 'bash ~/shelltools/nginx-projects/nginx-project-manager.sh "$@"' > ~/bin/nginxpm
chmod +x ~/bin/nginxpm
```
2. Asegúrate de que ~/bin esté en tu $PATH:

```
export PATH="$HOME/bin:$PATH"
```
3. Ahora puedes ejecutar:

 ```
 sudo nginxpm
```
🔹 Opción 3: Usar función en shell (sin sudo)


```
nginxpm() {
  bash ~/shelltools/nginx-projects/nginx-project-manager.sh "$@"
}
```
⚠️ Las funciones tampoco se heredan por sudo.

