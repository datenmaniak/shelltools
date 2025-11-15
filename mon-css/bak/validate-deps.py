#!/usr/bin/env python3
import sys

# --- Validación de dependencias ---
REQUIRED_MODULES = ["watchdog", "rich"]

missing = []
for module in REQUIRED_MODULES:
    try:
        __import__(module)
    except ImportError:
        missing.append(module)

if missing:
    print("❌ Faltan dependencias necesarias:")
    for m in missing:
        print(f"   - {m}")
    print("\n👉 Instálalas con Poetry:")
    print(f"   poetry add {' '.join(missing)}")
    sys.exit(1)

# --- Importar librerías ya validadas ---
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler
from rich.console import Console
from rich.diff import Diff
import argparse, os, time

console = Console()

def extract_block(file_path, selector, num_lines):
    """Extrae el bloque que contiene el selector y las siguientes num_lines líneas."""
    try:
        with open(file_path, encoding="utf-8") as f:
            lines = f.readlines()
        for i, line in enumerate(lines):
            if selector in line:
                return "".join(lines[i:i+num_lines])
    except Exception as e:
        console.print(f"[red]❌ Error leyendo archivo:[/red] {e}")
    return ""

class CSSHandler(FileSystemEventHandler):
    def __init__(self, file_path, selector, num_lines):
        self.file_path = file_path
        self.selector = selector
        self.num_lines = num_lines
        self.old_block = extract_block(file_path, selector, num_lines)

    def show_diff(self):
        new_block = extract_block(self.file_path, self.selector, self.num_lines)
        console.rule("[bold green]Bloque actual")
        console.print(new_block or "[yellow]No se encontró el selector[/yellow]")
        console.rule("[bold blue]Cambios en el bloque")
        diff = Diff.compare(self.old_block.splitlines(), new_block.splitlines())
        if diff:
            console.print(diff)
        else:
            console.print("[cyan]Sin cambios en el bloque[/cyan]")
        self.old_block = new_block

    def on_modified(self, event):
        if event.src_path.endswith(self.file_path):
            self.show_diff()

    def on_created(self, event):
        if event.src_path.endswith(self.file_path):
            self.show_diff()

def main():
    parser = argparse.ArgumentParser(
        description="Monitorea un archivo CSS recompilado por gulp+sass, mostrando un bloque específico y sus cambios en tiempo real."
    )
    parser.add_argument("archivo", help="Ruta al archivo CSS a monitorear")
    parser.add_argument("selector", help="Selector CSS a buscar (ej: .products__container .card)")
    parser.add_argument("num_lineas", type=int, help="Número de líneas a mostrar a partir de la coincidencia")

    args = parser.parse_args()

    if not os.path.isfile(args.archivo):
        console.print(f"[red]❌ No se encontró el archivo:[/red] {args.archivo}")
        return

    if args.num_lineas <= 0:
        console.print("[red]❌ El número de líneas debe ser un entero positivo.[/red]")
        return

    console.print(f"[bold green]📡 Monitoreando[/bold green] {args.archivo}")
    console.print(f"[bold yellow]🔎 Buscando la clave:[/bold yellow] {args.selector}")
    console.print(f"[bold cyan]📄 Mostrando {args.num_lineas} líneas a partir de la coincidencia[/bold cyan]")

    event_handler = CSSHandler(args.archivo, args.selector, args.num_lineas)
    observer = Observer()
    observer.schedule(event_handler, path=os.path.dirname(args.archivo) or ".", recursive=False)
    observer.start()

    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        observer.stop()
    observer.join()

if __name__ == "__main__":
    main()
