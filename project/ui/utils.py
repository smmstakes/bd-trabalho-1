import os
from rich.prompt import Prompt
from rich.console import Console

console = Console()

def limpar_tela():
    os.system('cls' if os.name == 'nt' else 'clear')

def solicitar_entrada_obrigatoria(prompt_text):
    while True:
        valor = Prompt.ask(prompt_text)
        if valor.strip():
            return valor
        else:
            console.print("[bold red]Este campo é obrigatório. Por favor, forneça um valor.[/bold red]")
  