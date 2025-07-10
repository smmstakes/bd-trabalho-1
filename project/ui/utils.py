import os
import sys

from PyQt5.QtWidgets import QApplication, QFileDialog

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

    app = QApplication.instance()
    if not app:
        app = QApplication(sys.argv)

    caminho_arquivo, _ = QFileDialog.getOpenFileName(
        None,
        "Selecione um arquivo",
        os.path.expanduser("~"),
        "Documentos (*.pdf *.docx);;Todos os Arquivos (*)"
    )

    if caminho_arquivo:
        return caminho_arquivo
    else:
        console.print("[bold yellow]Arquivo não selecionado.[/bold yellow]")
        return None
