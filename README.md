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
- `search/` → Herramientas de búsqueda como `buscar_palabra.py`.
- `web-development/` → Utilidades específicas para desarrollo web.

---

## 🚀 Integración con Zsh/Bash

Puedes invocar cualquier herramienta desde tu shell con alias o funciones. Ejemplo:

zsh
```
alias buscar_palabra='python3 ~/shelltools/search/buscar_palabra.py'
```
```
alias nginxpm='bash ~/shelltools/nginx-projects/nginx-project-manager.sh'

```