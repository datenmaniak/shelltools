#!/usr/bin/env python3
import argparse
import os
import time
import difflib
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler


def extract_block(file_path, selector, num_lines):
    """Extrae el bloque que contiene el selector y las siguientes num_lines líneas."""
    try:
        with open(file_path, encoding="utf-8") as f:
            lines = f.readlines()
        for i, line in enumerate(lines):
            if selector in line:
                return "".join(lines[i : i + num_lines])
    except Exception as e:
        print(f"❌ Error leyendo archivo: {e}")
    return ""


class CSSHandler(FileSystemEventHandler):
    def __init__(self, file_path, selector, num_lines):
        self.file_path = file_path
        self.selector = selector
        self.num_lines = num_lines
        self.old_block = extract_block(file_path, selector, num_lines)

    def on_modified(self, event):
        if event.src_path.endswith(self.file_path):
            self.show_diff()

    def on_created(self, event):
        if event.src_path.endswith(self.file_path):
            self.show_diff()

    def show_diff(self):
        new_block = extract_block(self.file_path, self.selector, self.num_lines)
        print("\n📄 Bloque actual:\n")
        print(new_block)
        print("──────────────────────────────")
        print("📌 Cambios en el bloque:")
        diff = difflib.unified_diff(
            self.old_block.splitlines(), new_block.splitlines(), lineterm=""
        )
        diff_output = "\n".join(diff)
        if diff_output.strip():
            print(diff_output)
        else:
            print("Sin cambios en el bloque")
        self.old_block = new_block


def main():
    parser = argparse.ArgumentParser(
        description="Monitorea un archivo CSS recompilado por gulp+sass, mostrando un bloque específico y sus cambios en tiempo real."
    )
    parser.add_argument("archivo", help="Ruta al archivo CSS a monitorear")
    parser.add_argument(
        "selector", help="Selector CSS a buscar (ej: .products__container .card)"
    )
    parser.add_argument(
        "num_lineas",
        type=int,
        help="Número de líneas a mostrar a partir de la coincidencia",
    )

    args = parser.parse_args()

    if not os.path.isfile(args.archivo):
        print(f"❌ No se encontró el archivo: {args.archivo}")
        return
