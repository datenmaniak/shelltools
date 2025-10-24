# 🟣 Better Comments - Violet Pulse Integration

Este módulo forma parte del ecosistema `shelltools/web-development/vscodium` y automatiza la instalación, configuración y validación de la extensión **Better Comments** en VSCodium, con etiquetas personalizadas alineadas al branding Violet Pulse.

## 🎯 Propósito

Resaltar visualmente comentarios clave en tu código fuente para mejorar la legibilidad, el enfoque y la documentación técnica. Ideal para proyectos modulares, colaborativos y con enfoque en mantenimiento y onboarding.

## 🧩 Etiquetas configuradas

| Etiqueta   | Color de fondo | Color de texto | Uso sugerido                  |
|------------|----------------|----------------|-------------------------------|
| `TODO`     | `#7700F0`      | `#FFFFFF`      | Tareas pendientes             |
| `REMOVE`   | `#FF0033`      | `#FFFFFF`      | Código obsoleto o a eliminar |
| `LEARN`    | `#FF9900`      | `#000000`      | Investigación o aprendizaje  |

## 🚀 Instalación

Ejecuta el script desde el subdirectorio:

```bash
./setup.sh
```


---

## 📄 `preview-snippets.code` — Archivo de prueba visual

```
// TODO: Validar formulario antes de enviar
// REMOVE: Eliminar función obsoleta
// LEARN: Investigar debounce en JavaScript
```

## 🧪 Validación
Abre preview-snippets.code y verifica que los comentarios se resalten con los colores configurados. 

## Manera fácil
Abre algunos de los templates de ejemplos con VSCodium:

```
├── README.md
├── setup.sh
├── template-php.php
├── template-scss.scss
└── template-test.js
```


## 🧠 Requisitos
+ VSCodium instalado

+ jq instalado (sudo dnf install jq)

+ Reiniciar VSCodium tras la instalación
