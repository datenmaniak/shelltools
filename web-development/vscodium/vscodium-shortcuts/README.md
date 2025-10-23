# 🎯 VSCodium Shortcuts – Violet Pulse

Este módulo automatiza la instalación de extensiones clave y la configuración de shortcuts personalizados en VSCodium, optimizando tu entorno de desarrollo para velocidad, navegación y limpieza de código.

---

## 📦 Extensiones agregadas

| 🧩 Extensión | 🛠️ ID | 🎯 Función |
|-------------|--------|------------|
| Prettier | `esbenp.prettier-vscode` | Formateo automático de código |



> ⚠️ La extensión `tombonnike.vscode-remove-empty-lines` fue retirada del Marketplace. Se reemplazó por una solución basada en expresiones regulares.

---

## ⌨️ Shortcuts configurados

| 🔠 Shortcut | 🧭 Acción | 🧩 Extensión requerida | 🎯 Propósito |
|------------|----------|------------------------|--------------|
| `Ctrl+Alt+J` | ✨ Formatear documento | Prettier (`esbenp.prettier-vscode`) | Alinear y limpiar código automáticamente |
| `Ctrl+Alt+M` | 🔍 Seleccionar ocurrencias | No | Marcar todas las instancias del texto seleccionado |
| `Ctrl+Shift+T` | 🖥️ Abrir terminal integrada | No | Ejecutar scripts, Gulp, shelltools desde el editor |
| `Ctrl+Alt+E` | 🧹 Eliminar líneas vacías (regex) | No | Limpieza rápida sin extensiones |
| `Ctrl+Shift+O` | 🧠 Ir a símbolo en archivo | No | Navegación rápida entre funciones y clases |
| `Ctrl+Alt+P` | 📁 Abrir carpeta de proyecto | No | Cambiar entre entornos modularizados |

---

## ✅ Beneficios

- 🔧 **Automatización modular**: shortcuts aplicados por script, listos para versionar.
- 🚀 **Productividad**: navegación rápida, limpieza de código, terminal integrada.
- 🧠 **Compatibilidad**: funciona en entornos Fedora KDE, sin afectar configuraciones previas.
- 🛡️ **Seguro**: crea backup de tu configuración antes de aplicar cambios.

---



## 🛠️ Cómo aplicar desde consola

 1. Cierra VSCodium para evitar conflictos.

2. Abre terminal y navega al módulo:

```
~/shelltools/web-development/vscodium/vscodium-shortcuts
```
3. Ejecuta el script:
```
zsh apply.zsh
```
4. Reabre VSCodium para ver los nuevos shortcuts en acción.



---
# 🎨 Hoja Visual de Shortcuts – VSCodium 

Esta hoja visual resume los shortcuts personalizados aplicados por el módulo `vscodium-shortcuts/`, con íconos y descripciones para facilitar el onboarding y la referencia rápida.



## 🧼 Alternativa para eliminar líneas vacías

Si no deseas usar extensiones, puedes ejecutar:

```bash
zsh remove_blank_lines.zsh
