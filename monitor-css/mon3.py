#!/usr/bin/env python3
"""
monitor_css.py
---------------------------------
Monitorea un archivo CSS y muestra cambios en un bloque específico.

Uso:
    python monitor_css.py <archivo> <selector> <num_lineas> [--diff]

Ejemplo:
    python monitor_css.py ~/proyectos/menu/build/css/main.css ".products__container .card" 50 --diff

Parámetros requeridos:
    - archivo   : Ruta al archivo CSS a monitorear
    - selector  : Selector CSS a buscar (ej: .products__container .card)
    - num_lineas: Número de líneas a mostrar a partir de la coincidencia

Opciones:
    --diff      : Mostrar diferencias entre el bloque anterior y el nuevo (por defecto no se muestran)

Salir del programa:
    Presiona Ctrl+C en cualquier momento para detener la ejecución.
"""

import sys, time, argparse, difflib
from pathlib import Path

# Dependencia obligatoria
try:
    from watchdog.observers import Observer
    from watchdog.events import FileSystemEventHandler
except ImportError:
    print("❌ Falta la librería 'watchdog'. Instálala con: poetry add watchdog")
    sys.exit(1)

# Color opcional con rich
try:
    from rich.console import Console

    console = Console()
    USE_RICH = True
except ImportError:
    USE_RICH = False


def extract_block(file_path: Path, selector: str, num_lines: int) -> str:
    """Devuelve el bloque desde la primera línea que contiene el selector."""
    try:
        lines = file_path.read_text(encoding="utf-8", errors="replace").splitlines(
            keepends=True
        )
    except Exception as e:
        return f"Error leyendo archivo: {e}"
    for i, line in enumerate(lines):
        if selector in line:
            return "".join(lines[i : i + num_lines])
    return ""


def format_two_columns(text: str, width: int = 60) -> str:
    """Divide el bloque en dos columnas: mitad izquierda y mitad derecha."""
    lines = text.splitlines()
    half = len(lines) // 2
    col1 = lines[:half]
    col2 = lines[half:]

    # Rellenar si las columnas no son iguales
    if len(col1) < len(col2):
        col1 += [""] * (len(col2) - len(col1))
    elif len(col2) < len(col1):
        col2 += [""] * (len(col1) - len(col2))

    output = []
    for left, right in zip(col1, col2):
        output.append(f"{left.ljust(width)} {right}")
    return "\n".join(output)


class CSSHandler(FileSystemEventHandler):
    def __init__(self, file_path: Path, selector: str, num_lines: int, show_diff: bool):
        self.file_path = file_path.resolve()
        self.selector = selector
        self.num_lines = num_lines
        self.show_diff = show_diff
        self.old_block = extract_block(self.file_path, self.selector, self.num_lines)

    def show_update(self):
        new_block = extract_block(self.file_path, self.selector, self.num_lines)
        if USE_RICH:
            console.rule("[bold green]Bloque actual (2 columnas)")
            console.print(format_two_columns(new_block))
        else:
            print("\n----- Bloque actual (2 columnas) -----")
            print(format_two_columns(new_block))

        if self.show_diff:
            if USE_RICH:
                console.rule("[bold blue]Cambios detectados")
            else:
                print("----- Cambios detectados -----")

            diff = difflib.unified_diff(
                self.old_block.splitlines(),
                new_block.splitlines(),
                fromfile="prev",
                tofile="curr",
                lineterm="",
            )
            diff_output = "\n".join(diff)
            if diff_output.strip():
                print(diff_output)
            else:
                print("Sin cambios en el bloque")

        self.old_block = new_block

    def on_modified(self, event):
        if Path(event.src_path).resolve() == self.file_path:
            self.show_update()


def main():
    parser = argparse.ArgumentParser(
        description="Monitorea un archivo CSS y muestra cambios en un bloque específico."
    )
    parser.add_argument("archivo", nargs="?", help="Ruta al archivo CSS")
    parser.add_argument(
        "selector",
        nargs="?",
        help="Selector CSS a buscar (ej: .products__container .card)",
    )
    parser.add_argument(
        "num_lineas", nargs="?", type=int, help="Número de líneas a mostrar"
    )
    parser.add_argument(
        "--diff",
        action="store_true",
        help="Mostrar diferencias entre bloque anterior y nuevo",
    )

    # Si no se pasan argumentos, mostrar ayuda y salir
    if len(sys.argv) == 1:
        parser.print_help()
        print("\n👉 Parámetros requeridos: archivo selector num_lineas [--diff]")
        sys.exit(1)

    args = parser.parse_args()

    file_path = Path(args.archivo).expanduser()
    if not file_path.is_file():
        print(f"❌ No se encontró el archivo: {file_path}")
        sys.exit(1)

    if args.num_lineas is None or args.num_lineas <= 0:
        print("❌ El número de líneas debe ser un entero positivo.")
        sys.exit(1)

    handler = CSSHandler(file_path, args.selector, args.num_lineas, args.diff)
    handler.show_update()  # Mostrar bloque inicial

    observer = Observer()
    observer.schedule(handler, path=str(file_path.parent.resolve()), recursive=False)
    observer.start()

    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        observer.stop()
    observer.join()


if __name__ == "__main__":
    main()
