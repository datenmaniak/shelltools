#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
search_files_with.py — Búsqueda de palabra clave o patrón en archivos, con salida tabular y resumen.
Autor: Datenmaniak
"""

import os
import re
import argparse
import time

EXCLUIR_DIRS = {'node_modules', '.git', '__pycache__', '.venv', 
'dist', 'build', '.idea', '.vscode'}

EXTENSIONES_VALIDAS = {'.txt', '.md', '.html', '.css', '.js', 
'.py', '.php', '.json', '.xml', '.conf', '.ini', '.sh'}


# 🎨 Colores ANSI
class Color:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKCYAN = '\033[96m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    BOLD = '\033[1m'
    RESET = '\033[0m'

def violet_banner(palabra_clave, directorio, usar_regex, usar_color):
    def c(text): return Color.HEADER + text + Color.RESET if usar_color else text
    print("\n" + "="*70)
    print(c("🟣 VIOLET PULSE — BÚSQUEDA DE PALABRA CLAVE").center(70))
    print("="*70)
    print(f"🔍 Modo: {'Expresión regular' if usar_regex else 'Texto simple'}")
    print(f"🔍 Patrón: {palabra_clave}")
    print(f"📁 Directorio: {directorio}")
    print("-"*70)
    print(f"{'Archivo':40} | {'Línea':>5} | Fragmento")
    print("-"*70)

def resumen(tiempo, total_dirs, total_coincidencias, usar_color):
    def c(text): return Color.OKCYAN + text + Color.RESET if usar_color else text
    print("-"*70)
    print(c(f"⏱️ Tiempo de búsqueda: {tiempo:.2f} segundos"))
    print(c(f"📂 Directorios explorados: {total_dirs}"))
    print(c(f"🔎 Coincidencias encontradas: {total_coincidencias}"))
    print(c(f"🚫 Directorios excluidos: {', '.join(sorted(EXCLUIR_DIRS))}"))
    print("="*70 + "\n")

def buscar(patron, directorio, usar_regex=False, usar_color=True):
    inicio = time.time()
    total_dirs = 0
    total_coincidencias = 0

    violet_banner(patron, directorio, usar_regex, usar_color)

    # for root, _, files in os.walk(directorio):
    for root, dirs, files in os.walk(directorio):
        # Excluir directorios no deseados
        dirs[:] = [d for d in dirs if d not in EXCLUIR_DIRS]
        total_dirs += 1
        for nombre_archivo in files:
            _, ext = os.path.splitext(nombre_archivo)
            if ext.lower() not in EXTENSIONES_VALIDAS:
                continue  # Ignorar archivos no textuales

            ruta_archivo = os.path.join(root, nombre_archivo)
            try:
                with open(ruta_archivo, 'r', encoding='utf-8', errors='ignore') as archivo:
                    for num_linea, linea in enumerate(archivo, start=1):
                        coincide = False
                        if usar_regex:
                            coincide = re.search(patron, linea, re.IGNORECASE)
                        else:
                            coincide = patron.lower() in linea.lower()

                        if coincide:
                            fragmento = linea.strip()
                            if len(fragmento) > 80:
                                fragmento = fragmento[:77] + "..."
                                fragmento = ''.join(c if c.isprintable() else '�' for c in fragmento)

                            print(f"{ruta_archivo[:40]:40} | {num_linea:5} | {fragmento}")
                            total_coincidencias += 1
            except Exception as e:
                print(f"⚠️ No se pudo leer {ruta_archivo}: {e}")

    fin = time.time()
    resumen(fin - inicio, total_dirs, total_coincidencias, usar_color)

def main():
    parser = argparse.ArgumentParser(
        description="🟣 Violet Pulse — Búsqueda de palabra clave o patrón en archivos.",
        usage="search_files_with [opciones] <patrón> <directorio>",
        epilog="Ejemplo: search_files_with --regex '(nginx|php)' ~/proyectos"
    )
    parser.add_argument("patron", nargs="?", help="Palabra clave o expresión regular a buscar")
    parser.add_argument("directorio", nargs="?", help="Ruta del directorio a escanear")
    parser.add_argument("--regex", action="store_true", help="Usar expresión regular en lugar de texto simple")
    parser.add_argument("--no-color", action="store_true", help="Desactivar colores ANSI en la salida")

    args = parser.parse_args()

    # 🆘 Mostrar ayuda si faltan argumentos
    if not args.patron or not args.directorio:
        parser.print_help()
        print("\n⚠️ Debes ingresar una palabra clave y un directorio.")
        print("ℹ️ Usa -h o --help para ver opciones disponibles.\n")
        return

    buscar(args.patron, args.directorio, usar_regex=args.regex, usar_color=not args.no_color)

    # parser = argparse.ArgumentParser(description="Buscar palabra clave o patrón en archivos de un directorio.")
    # parser.add_argument("patron", help="Palabra clave o expresión regular a buscar")
    # parser.add_argument("directorio", help="Ruta del directorio a escanear")
    # parser.add_argument("--regex", action="store_true", help="Usar expresión regular en lugar de texto simple")
    # parser.add_argument("--no-color", action="store_true", help="Desactivar colores ANSI en la salida")
    # args = parser.parse_args()

    # buscar(args.patron, args.directorio, usar_regex=args.regex, usar_color=not args.no_color)

if __name__ == "__main__":
    main()
