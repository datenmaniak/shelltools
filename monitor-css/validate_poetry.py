#!/usr/bin/env python3
import sys
import os

# Intentamos importar librerías que instalaste con Poetry
try:
    import rich
    from rich.console import Console
except ImportError:
    print("❌ No se encontró la librería 'rich'.")
    print("👉 Instálala con: poetry add rich")
    sys.exit(1)

console = Console()


def main():
    console.rule("[bold green]Validación del entorno Poetry[/bold green]")
    console.print(
        "[cyan]✅ El entorno Poetry está activo y la librería 'rich' funciona correctamente.[/cyan]"
    )

    # Mostrar información del entorno virtual
    venv = os.environ.get("VIRTUAL_ENV", None)
    if venv:
        console.print(f"[yellow]📂 Entorno virtual activo:[/yellow] {venv}")
    else:
        console.print("[red]⚠️ No se detecta un entorno virtual activo.[/red]")

    console.print(f"[magenta]🐍 Versión de Python:[/magenta] {sys.version.split()[0]}")


if __name__ == "__main__":
    main()
