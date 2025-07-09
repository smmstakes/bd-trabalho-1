import os
import subprocess

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

def selecionar_arquivo():
    console.print("\n[bold yellow]Aguardando seleção de arquivo...[/bold yellow]")

    try: 
        # Comando para abrir o diálogo de seleção de arquivo com kdialog
        comando = ["kdialog", "--getopenfilename", os.path.expanduser("~"), 
                   "*.pdf | *.docx | *.*"]
        
        # Executa o comando e captura a saída
        resultado = subprocess.run(comando, capture_output=True, text=True, check=True)
 
        caminho_arquivo = resultado.stdout.strip()
        if caminho_arquivo:
            return caminho_arquivo
        
    except (FileNotFoundError, subprocess.CalledProcessError):
        console.print("[bold yellow]Arquivo não selecionado.[/bold yellow]")
