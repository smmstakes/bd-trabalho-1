from rich.panel import Panel
from rich.prompt import Prompt

from .menu_aluno import MenuAluno
from .menu_vagas import MenuVagas
from.menu_candidatura import MenuCandidatura

from .utils import console, limpar_tela

class MenuPrincipal:
    def __init__(self):
        self.menu_aluno = MenuAluno()
        self.menu_vagas = MenuVagas()
        self.menu_candidatura = MenuCandidatura()

    def run(self):
        while True:
            limpar_tela()
            
            self._exibir_cabecalho()
            self._exibir_opcoes_menu()

            opcao = Prompt.ask("\nEscolha uma opção", choices=["1", "2", "3", "4"], default="4")

            if opcao == "1":
                self.menu_aluno.run()
            elif opcao == "2":
                self.menu_vagas.run()
            elif opcao == "3":
                self.menu_candidatura.run()
            elif opcao == "4":
                console.print("[bold red]Saindo do sistema... Até mais!![/bold red]")
                break
    
    def _exibir_cabecalho(self):
        console.print(Panel.fit(
                "[bold yellow]Bem-vindo ao Catálogo de Vagas da UnB[/bold yellow]\n:books: O seu portal para o futuro!",
                border_style="green"
            ))

    def _exibir_opcoes_menu(self):
        console.print("\n[bold]Menu Principal:[/bold]")
        console.print("[magenta]1.[/magenta] Gerenciar Alunos")
        console.print("[magenta]2.[/magenta] Gerenciar Vagas")
        console.print("[magenta]3.[/magenta] Gerenciar Candidaturas")
        console.print("[red]4.[/red] Sair")
        