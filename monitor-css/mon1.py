#!/usr/bin/env python3
"""
monitor_css.py
---------------------------------
Monitorea un archivo CSS y muestra cambios en un bloque específico.

Uso:
    python monitor_css.py <archivo> <selector> <num_lineas>

Ejemplo:
    python monitor_css.py ~/proyectos/menu/build/css/main.css ".products__container .card" 20

Parámetros requeridos:
    - archivo   : Ruta al archivo CSS a monitorear
    - selector  : Selector CSS a buscar (ej: .products__container .card)
    - num_lineas: Número de líneas a mostrar a partir de la coincidencia

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


class CSSHandler(FileSystemEventHandler):
    def __init__(self, file_path: Path, selector: str, num_lines: int):
        self.file_path = file_path.resolve()
        self.selector = selector
        self.num_lines = num_lines
        self.old_block = extract_block(self.file_path, self.selector, self.num_lines)

    def show_update(self):
        new_block = extract_block(self.file_path, self.selector, self.num_lines)
        if USE_RICH:
            console.rule("[bold green]Bloque actual")
            console.print(new_block or "[yellow]Selector no encontrado[/yellow]")
            console.rule("[bold blue]Cambios detectados")
        else:
            print("\n----- Bloque actual -----")
            print(new_block or "Selector no encontrado")
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

    # Si no se pasan argumentos, mostrar ayuda y salir
    if len(sys.argv) == 1:
        parser.print_help()
        print("\n👉 Parámetros requeridos: archivo selector num_lineas")
        sys.exit(1)

    args = parser.parse_args()

    file_path = Path(args.archivo).expanduser()
    if not file_path.is_file():
        print(f"❌ No se encontró el archivo: {file_path}")
        sys.exit(1)

    if args.num_lineas is None or args.num_lineas <= 0:
        print("❌ El número de líneas debe ser un entero positivo.")
        sys.exit(1)

    handler = CSSHandler(file_path, args.selector, args.num_lineas)
    handler.show_update()  # Mostrar bloque inicial

    observer = Observer()
    # observer.schedule(handler, path=str(file_path.parent), recursive=False)
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
