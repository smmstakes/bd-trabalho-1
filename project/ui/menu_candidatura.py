from rich.table import Table

from .utils import *
from models.vaga_model import Vaga
from models.aluno_model import Aluno
from models.candidatura_model import Candidatura

class MenuCandidatura:
    def __init__(self):
        pass

    def run(self):
        while True:
            limpar_tela()

            console.print("[bold cyan]Gerenciamento de Candidaturas[/bold cyan]", justify="center")

            self._exibir_opcoes_menu()

            opcao = Prompt.ask("Escolha uma opção", choices=["1", "2", "3", "4", "5", "6", "7"], default="7")

            if opcao == "1": 
                self._realizar_candidatura()
            elif opcao == "2": 
                self._ver_candidatos_por_vaga()
            elif opcao == "3": 
                self._ver_minhas_candidaturas()
            elif opcao == "4": 
                self._atualizar_status()
            elif opcao == "5":
                self._baixar_curriculo()
            elif opcao == "6":
                self._retirar_candidatura()
            elif opcao == "7": 
                break

    def _realizar_candidatura(self):
        limpar_tela()

        console.print("[bold green]Nova Candidatura[/bold green]", justify="center")
        
        cpf_aluno = self._selecionar_aluno("Digite o CPF do Aluno que está se candidatando")
        if not cpf_aluno: 
            return
        
        id_vaga = self._selecionar_vaga("Digite o ID da Vaga desejada")
        if not id_vaga: 
            return

        caminho_arquivo = selecionar_arquivo()
        curriculo_bytes = None

        if caminho_arquivo:
            try:
                with open(caminho_arquivo, 'rb') as file: 
                    curriculo_bytes = file.read()

                console.print("[green]Arquivo do currículo lido com sucesso![/green]")

            except FileNotFoundError:
                console.print(f"[bold red]Erro: Arquivo não encontrado em '{caminho_arquivo}'.[/bold red]")

                input("\nPressione Enter para continuar...")
                return
        
        nova_candidatura = Candidatura(cpf_aluno=cpf_aluno, id_vaga=id_vaga, status="Enviada",
                                       arquivo_curriculo=curriculo_bytes)

        nova_candidatura.create()

        input("\nPressione Enter para continuar...")

    def _ver_candidatos_por_vaga(self):
        limpar_tela()

        console.print("[bold green]Ver Candidatos por Vaga[/bold green]", justify="center")

        id_vaga = self._selecionar_vaga("Digite o ID da Vaga para ver os candidatos")
        if not id_vaga: 
            return

        candidatos = self._busca_todos_candidatos_vaga(id_vaga)
        if not candidatos:
            return
        self._mostra_tabela_candidatos_vaga(candidatos, id_vaga)
        
        input("\nPressione Enter para continuar...")
    
    def _ver_minhas_candidaturas(self):
        limpar_tela()

        console.print("[bold green]Minhas Candidaturas[/bold green]", justify="center")

        cpf_aluno = self._selecionar_aluno("Digite o seu CPF para ver suas candidaturas")
        if not cpf_aluno: 
            return

        candidaturas = self._busca_candidatura_aluno(cpf_aluno)
        if not candidaturas:
            return
        self._mostra_tabela_candidatura_aluno(candidaturas, cpf_aluno)

        input("\nPressione Enter para continuar...")

    def _atualizar_status(self):
        limpar_tela()

        console.print("[bold green]Atualizar Status de Candidatura[/bold green]", justify="center")

        id_vaga = self._selecionar_vaga("Primeiro, escolha a vaga")
        if not id_vaga: 
            return
        
        candidatos = Candidatura.get_by_vaga(id_vaga)
        if not candidatos: 
            console.print(f"\n[yellow]Nenhum candidato para a vaga {id_vaga}.[/yellow]")

            input("\nPressione Enter para continuar...")
            return
        
        cpf_aluno = self._selecionar_aluno("Agora, escolha o aluno para atualizar o status")
        if not cpf_aluno: 
            return
        novo_status = solicitar_entrada_obrigatoria("Digite o novo status. (Ex: Enviada, Em análise, Aprovada, Rejeitada)")

        candidatura = Candidatura(cpf_aluno=cpf_aluno, id_vaga=id_vaga, status='', arquivo_curriculo=b'')

        candidatura.update_status(novo_status)

        input("\nPressione Enter para continuar...")
    
    def _baixar_curriculo(self):
        limpar_tela()

        console.print("[bold green]Baixar Currículo de Candidatura[/bold green]", justify="center")

        cpf_aluno = self._selecionar_aluno("Digite o CPF do aluno")
        if not cpf_aluno: 
            return

        id_vaga = self._selecionar_vaga("Digite o ID da vaga da candidatura")
        if not id_vaga: 
            return

        # Busca os bytes do currículo no banco
        curriculo_bytes = Candidatura.get_curriculo_bytes(cpf_aluno, id_vaga)

        if not curriculo_bytes:
            console.print("[bold red]Currículo não encontrado para esta candidatura.[/bold red]")
            input("\nPressione Enter para continuar...")
            return

        console.print("[bold yellow]Selecione o caminho para salvar o curriculo.[/bold yellow]")

        caminho_salvar = self._selecionar_caminho_salvar()
        
        try:
            with open(caminho_salvar, 'wb') as file:
                file.write(curriculo_bytes)
            console.print(f"[bold green]Currículo salvo com sucesso em: {caminho_salvar}[/bold green]")

        except Exception as e:
            if "expected str, bytes or os.PathLike object" in str(e):
                console.print("[bold red]Não foi possível salvar o arquivo, caminho não informado.[/bold red]")
            else:
                console.print(f"[bold red]Ocorreu um erro ao salvar o arquivo: {e}[/bold red]")

        input("\nPressione Enter para continuar...")

    def _retirar_candidatura(self):
        limpar_tela()

        console.print("[bold red]Retirar Candidatura[/bold red]", justify="center")

        cpf_aluno = self._selecionar_aluno("Digite o seu CPF")
        if not cpf_aluno: 
            return

        candidaturas = self._busca_candidatura_aluno(cpf_aluno)
        if not candidaturas:
            return
        self._mostra_tabela_candidatura_aluno(candidaturas, cpf_aluno)

        choices = []
        for vaga in candidaturas:
            choices.append(str(vaga[1]))

        while True:
            id_vaga_str = solicitar_entrada_obrigatoria("Digite o ID da vaga da qual deseja sair")
            if id_vaga_str in choices: 
                id_vaga = int(id_vaga_str)
                break

            console.print(f"[bold red]ID '{id_vaga_str}' inválido.[/bold red]")
        
        confirmacao = Prompt.ask(f"Tem certeza?", choices=["s", "n"], default="n")

        if confirmacao.lower() == 's':
            candidatura = Candidatura(cpf_aluno, id_vaga, '', b'')
            candidatura.delete()
        else: 
            console.print("[yellow]Operação cancelada.[/yellow]")

        input("\nPressione Enter para continuar...")
        
# ---------- MÉTODOS AUXILIARES ---------- #

    def _exibir_opcoes_menu(self):
        tabela_menu = Table(show_header=False, border_style="dim")

        tabela_menu.add_column("Opção", style="magenta", width=2)
        tabela_menu.add_column("Descrição")

        tabela_menu.add_row("1", "Realizar Nova Candidatura")
        tabela_menu.add_row("2", "Ver Candidatos de uma Vaga")
        tabela_menu.add_row("3", "Ver Minhas Candidaturas")
        tabela_menu.add_row("4", "Atualizar Status de Candidatura")
        tabela_menu.add_row("5", "Baixar currículo")
        tabela_menu.add_row("6", "Retirar Candidatura")
        tabela_menu.add_row("7", "Voltar ao Menu Principal")

        console.print(tabela_menu)

    def _busca_todos_candidatos_vaga(self, id_vaga):
        candidatos = Candidatura.get_by_vaga(id_vaga)
        if not candidatos:
            console.print(f"\n[yellow]Nenhum candidato encontrado para a vaga {id_vaga}.[/yellow]")

            input("\nPressione Enter para continuar...")
            return
        
        return candidatos
    
    def _mostra_tabela_candidatos_vaga(self, candidatos, id_vaga):
        tabela_candidatos = Table(title=f"Candidatos para a Vaga {id_vaga}")

        tabela_candidatos.add_column("Nome")
        tabela_candidatos.add_column("Email")
        tabela_candidatos.add_column("Status")
        tabela_candidatos.add_column("Data")

        for cdnt in candidatos: 
            tabela_candidatos.add_row(cdnt[0], cdnt[1], cdnt[2], str(cdnt[3]))

        console.print(tabela_candidatos)

    def _busca_candidatura_aluno(self, cpf_aluno):
        candidaturas = Candidatura.get_by_aluno(cpf_aluno)
        if not candidaturas:
            console.print(f"\n[yellow]Nenhuma candidatura encontrada para o aluno com CPF {cpf_aluno}.[/yellow]")
            
            input("\nPressione Enter para continuar...")
            return
        
        return candidaturas

    def _mostra_tabela_candidatura_aluno(self, candidaturas, cpf_aluno):
        tabela_candidaturas = Table(title=f"Candidaturas de {cpf_aluno}")

        tabela_candidaturas.add_column("Título da Vaga"); 
        tabela_candidaturas.add_column("ID da Vaga"); 
        tabela_candidaturas.add_column("Status"); 
        tabela_candidaturas.add_column("Data")

        for cndt in candidaturas: 
            tabela_candidaturas.add_row(cndt[0], str(cndt[1]), cndt[2], str(cndt[3]))

        console.print(tabela_candidaturas)

    def _selecionar_aluno(self, prompt_text):
        alunos = Aluno.get_all()
        if not alunos: 
            console.print("[bold red]Nenhum aluno cadastrado.[/bold red]"); 
            return None
        
        tabela = Table(title="Alunos"); 
        tabela.add_column("CPF"); 
        tabela.add_column("Nome")

        choices = [al.cpf for al in alunos]
        for al in alunos: 
            tabela.add_row(al.cpf, al.nome)

        console.print(tabela)

        while True:
            cpf = solicitar_entrada_obrigatoria(prompt_text)
            if cpf in choices: 
                return cpf
            
            console.print(f"[bold red]CPF '{cpf}' inválido.[/bold red]")

    def _selecionar_vaga(self, prompt_text):
        vagas = Vaga.get_all()
        if not vagas: 
            console.print("[bold red]Nenhuma vaga cadastrada.[/bold red]")
            return None
        
        tabela = Table(title="Vagas")

        tabela.add_column("ID")
        tabela.add_column("Título")

        choices = [str(vg.id) for vg in vagas]
        for vg in vagas: 
            tabela.add_row(str(vg.id), vg.titulo)

        console.print(tabela)

        while True:
            id_str = solicitar_entrada_obrigatoria(prompt_text)
            if id_str in choices: 
                return int(id_str)
            
            console.print(f"[bold red]ID '{id_str}' inválido.[/bold red]")
    
    def _selecionar_caminho_salvar(self):
        app = QApplication.instance()
        if not app:
            app = QApplication(sys.argv)

        caminho_salvar, _ = QFileDialog.getSaveFileName(
            None,
            "Salvar currículo como",
            os.path.expanduser("~"),
            "Documentos (*.pdf *.docx);;Todos os Arquivos (*)"
        )

        return caminho_salvar if caminho_salvar else None
