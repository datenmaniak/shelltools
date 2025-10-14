#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Script para buscar una palabra clave en todos los archivos de un directorio.
Uso: ./buscar_palabra.py
"""

import os
import argparse

def buscar_palabra_en_archivos(palabra_clave, directorio):
    print(f"🔍 Buscando '{palabra_clave}' en archivos dentro de: {directorio}\n")
    for root, _, files in os.walk(directorio):
        for nombre_archivo in files:
            ruta_archivo = os.path.join(root, nombre_archivo)
            try:
                with open(ruta_archivo, 'r', encoding='utf-8', errors='ignore') as archivo:
                    for num_linea, linea in enumerate(archivo, start=1):
                        if palabra_clave.lower() in linea.lower():
                            print(f"📄 {ruta_archivo} (línea {num_linea}): {linea.strip()}")
            except Exception as e:
                print(f"⚠️ No se pudo leer {ruta_archivo}: {e}")

def main():
    parser = argparse.ArgumentParser(description="Buscar palabra clave en archivos de un directorio.")
    parser.add_argument("palabra_clave", help="Palabra clave a buscar")
    parser.add_argument("directorio", help="Ruta del directorio a escanear")
    args = parser.parse_args()

    buscar_palabra_en_archivos(args.palabra_clave, args.directorio)

if __name__ == "__main__":
    main()
