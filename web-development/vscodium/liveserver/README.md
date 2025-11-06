# 🚀 Setup del browser para Live server

Este script automatiza la configuración del navegador para Live Server en VSCodium o VSCode, y documenta los cambios realizados en un archivo `index.html` con estilo visual. Ideal para entornos Linux con enfoque modular y técnico.

---

## 🧩 ¿Qué hace?

- Detecta si usas **VSCodium** o **VSCode**
- Te permite elegir el navegador para Live Server
- Valida si el navegador está instalado
- Crea un **respaldo seguro** de `settings.json`
- Modifica el archivo con el navegador elegido
- Genera o actualiza `index.html` con una **tabla de configuración**
- Inserta la **fecha del ajuste** y una **línea separadora** entre configuraciones
- Notifica que debes **reiniciar el editor** para aplicar los cambios
- Integra con una hoja de estilo externa (`style.css`) para visualización clara

---

## 🖥️ Navegadores disponibles

- Google Chrome
- Firefox
- Firefox Developer
- Brave
- Microsoft Edge
- Chromium
- Ninguno (`none`)
- Predeterminado del sistema (`default`)

---

## 📄 Archivos generados

| Archivo        | Propósito                                                                 |
|----------------|---------------------------------------------------------------------------|
| `settings.json`| Se modifica para establecer el navegador de Live Server                   |
| `settings.json.bak.*` | Respaldo automático antes de modificar                             |
| `index.html`   | Documenta los cambios realizados en una tabla dentro del `<body>`         |
| `style.css`    | Estiliza la tabla y el contenido del HTML con diseño limpio y técnico     |

---

## 🎨 Estilo visual

La tabla en `index.html` incluye:

- Navegador elegido + fecha del ajuste
- Editor detectado
- Ruta del archivo modificado
- Ruta del respaldo
- Indicador de reinicio requerido
- Separadores visuales entre configuraciones

Puedes personalizar el estilo editando `style.css`.

---

## 🛠️ Requisitos

- Linux con terminal Bash
- jq instalado (`sudo dnf install jq` en Fedora)
- xdg-utils para detectar navegador predeterminado
- Live Server instalado en tu editor

---

## 📦 Instalación

1. Copia `setup.sh` en tu proyecto
2. Dale permisos de ejecución:
```
   chmod +x setup.sh
```

## 📦 Instalación

```
   ./setup.sh
```

## Screenshot
```
🧭 Editor detectado: VSCodium
Selecciona el navegador para Live Server:
1) chrome
2) firefox
3) firefox-developer
4) brave
5) edge
6) chromium
7) none
8) default
9) salir
Opción:
```

-
### 📝 Generación automática de index.html

> El archivo `index.html` se genera automáticamente por el script para comprobar visualmente el navegador elegido y documentar esta tarea.  
> Cada ejecución agrega una nueva entrada en forma de tabla, incluyendo la fecha del ajuste, el editor detectado, el archivo modificado y el respaldo creado.  
> Esto permite llevar un registro técnico claro y accesible desde el navegador.



## 🧠 Autor
Script desarrollado por Datenmaniak como parte de su ecosistema técnico modular y documentado. Inspirado en la filosofía Violet Pulse: claridad, seguridad, y estilo.