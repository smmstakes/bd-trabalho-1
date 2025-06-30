from rich.table import Table

from .utils import *
from models.aluno_model import Aluno
from models.curso_model import Curso

class MenuAluno:
    def __init__(self):
        pass

    def run(self):
        while True:
            limpar_tela()

            console.print("[bold cyan]Gerenciamento de Alunos[/bold cyan]", justify="center")
            self._exibir_opcoes_menu()

            opcao = Prompt.ask("Escolha uma opção", choices=["1", "2", "3", "4", "5"], default="5")

            if opcao == "1":
                self._listar_todos_os_alunos()
            elif opcao == "2":
                self._cadastrar_novo_aluno()
            elif opcao == "3":
                self._atualizar_dados_aluno()
            elif opcao == "4":
                self._remover_aluno_menu()
            elif opcao == "5":
                break

    def _listar_todos_os_alunos(self):
        limpar_tela()
        
        console.print("[bold green]Lista de Alunos Cadastrados[/bold green]", justify="center")
        
        alunos = self._busca_todos_alunos()
        if not alunos:
            return
        
        self._mostra_tabela_alunos(alunos)
        
        input("\nPressione Enter para continuar...")

    def _cadastrar_novo_aluno(self):
        """Coleta os dados do usuário e cria um novo aluno."""

        limpar_tela()

        console.print("[bold green]Cadastro de Novo Aluno[/bold green]", justify="center")
        
        
        cpf = self._solicitar_cpf_valido()
        matricula = self._solicitar_matricula_valida()

        nome = solicitar_entrada_obrigatoria("Nome completo")
        email = solicitar_entrada_obrigatoria("Email")
        cep = solicitar_entrada_obrigatoria("CEP (8 dígitos)")
        complemento = solicitar_entrada_obrigatoria("Complemento do Endereço")
        numero = solicitar_entrada_obrigatoria("Número do Endereço")
        url_lattes = Prompt.ask("URL do Lattes (opcional)")

        try:
            semestre = int(solicitar_entrada_obrigatoria("Semestre"))

            cursos = self._busca_todos_cursos()
            self._mostra_tabela_cursos(cursos)

            id_curso = int(Prompt.ask("Escolha o ID do curso"))

        except ValueError:
            console.print("[bold red]\nErro: O semestre deve ser um número inteiro.[/bold red]")

            input("\nPressione Enter para continuar...")
            return
        
        novo_aluno = Aluno(
            cpf=cpf, matricula=matricula, nome=nome, email=email, cep=cep,
            complemento_end=complemento, numero_end=numero, url_lattes=url_lattes,
            semestre=semestre, id_curso=id_curso
        )

        novo_aluno.create()

        input("\nPressione Enter para continuar...")

    def _atualizar_dados_aluno(self):
        limpar_tela()

        console.print("[bold green]Atualização de Dados do Aluno[/bold green]", justify="center")
        cpf = solicitar_entrada_obrigatoria("Digite o CPF do aluno que deseja atualizar")
        
        aluno = Aluno.get_by_cpf(cpf)
        if not aluno:
            console.print(f"[bold red]Aluno com CPF {cpf} não encontrado.[/bold red]")

            input("\nPressione Enter para continuar...")
            return
        
        console.print(f"\nEditando dados de: [bold]{aluno.nome}[/bold]. \
                      \nPressione Enter para manter o valor atual.")
        
        try:
            novo_nome = Prompt.ask("Nome", default=aluno.nome)
            novo_email = Prompt.ask("Email", default=aluno.email)
            nova_matricula = Prompt.ask("Matrícula", default=aluno.matricula)
            novo_semestre_str = Prompt.ask("Semestre", default=str(aluno.semestre))
            
            if novo_nome.strip(): aluno.nome = novo_nome
            if novo_email.strip(): aluno.email = novo_email
            if nova_matricula.strip(): aluno.matricula = nova_matricula
            if novo_semestre_str.strip(): aluno.semestre = int(novo_semestre_str)
            
            aluno.update()

        except ValueError:
            console.print("[bold red]\nErro: O semestre deve ser um número inteiro.[/bold red]")

        except Exception as e:
            console.print(f"[bold red]\nOcorreu um erro inesperado: {e}[/bold red]")

        input("\nPressione Enter para continuar...")

    def _remover_aluno_menu(self):
        limpar_tela()

        console.print("[bold red]Remover Aluno[/bold red]", justify="center")

        cpf = solicitar_entrada_obrigatoria("Digite o CPF do aluno que deseja remover")

        aluno = Aluno.get_by_cpf(cpf)
        if not aluno:
            console.print(f"[bold red]Aluno com CPF {cpf} não encontrado.[/bold red]")

            input("\nPressione Enter para continuar...")
            return

        console.print(f"\nAluno a ser removido: [bold]{aluno.nome}[/bold] (CPF: {aluno.cpf})")
        confirmacao = Prompt.ask(
            "Tem certeza que deseja remover este aluno?", choices=["s", "n"], default="n"
        )

        if confirmacao.lower() == 's':
            aluno.delete()
        else:
            console.print("[yellow]Operação cancelada.[/yellow]")
        
        input("\nPressione Enter para continuar...")

# ---------- MÉTODOS AUXILIARES ---------- #

    def _exibir_opcoes_menu(self):
        tabela_menu = Table(show_header=False, border_style="dim")

        tabela_menu.add_column("Opção", style="magenta", width=2)
        tabela_menu.add_column("Descrição")

        tabela_menu.add_row("1", "Listar Todos os Alunos")
        tabela_menu.add_row("2", "Cadastrar Novo Aluno")
        tabela_menu.add_row("3", "Atualizar Aluno")
        tabela_menu.add_row("4", "Remover Aluno")
        tabela_menu.add_row("5", "Voltar ao Menu Principal")

        console.print(tabela_menu)

    def _busca_todos_alunos(self):
        alunos = Aluno.get_all()
        if not alunos:
            console.print("\n[yellow]Nenhum aluno cadastrado.[/yellow]")

            input("\nPressione Enter para continuar...")
            return
        
        return alunos
        
    def _mostra_tabela_alunos(self, alunos):
        tabela_alunos = Table(title="Alunos", border_style="blue")

        tabela_alunos.add_column("CPF", style="dim", width=12)
        tabela_alunos.add_column("Nome", style="bold")
        tabela_alunos.add_column("Matrícula")
        tabela_alunos.add_column("Email")
        tabela_alunos.add_column("Curso")
        tabela_alunos.add_column("Semestre")

        for aluno in alunos:
            tabela_alunos.add_row(
                aluno.cpf, aluno.nome, aluno.matricula, aluno.email, 
                aluno.nome_curso, str(aluno.semestre)
            )

        console.print(tabela_alunos)        

    def _busca_todos_cursos(self):
        cursos = Curso.get_all()
        if not cursos:
            console.print("[bold red]Erro: Nenhum curso cadastrado no sistema.",
                          "\Impossível cadastrar aluno.[/bold red]")

            input("\nPressione Enter para continuar...")
            return
        
        return cursos

    def _mostra_tabela_cursos(self, cursos):
        tabela_cursos = Table(title="Cursos Disponíveis")
        tabela_cursos.add_column("ID")
        tabela_cursos.add_column("Nome")

        for curso in cursos:
            tabela_cursos.add_row(str(curso.id), curso.nome)

        console.print(tabela_cursos)

    def _solicitar_cpf_valido(self):
        """Solicita e valida o CPF, verificando formato e existência no banco."""

        while True:
            cpf = solicitar_entrada_obrigatoria("CPF (11 dígitos, sem pontos)")
            if len(cpf) != 11 or not cpf.isdigit():
                console.print("[bold red]Formato de CPF inválido.",
                "Deve conter exatamente 11 dígitos numéricos.[/bold red]")
                continue
            
            if Aluno.get_by_cpf(cpf):
                console.print("[bold red]Erro: Já existe um aluno cadastrado com este CPF.[/bold red]")
                continue
            
            return cpf 

    def _solicitar_matricula_valida(self):
        """Solicita e valida a Matrícula, verificando formato e existência no banco."""

        while True:
            matricula = solicitar_entrada_obrigatoria("Matrícula (8 dígitos)")
            if len(matricula) != 8:
                console.print("[bold red]Formato de Matrícula inválida.",
                "Deve ter 8 caracteres.[/bold red]")
                continue

            if Aluno.get_by_matricula(matricula):
                console.print("[bold red]Erro: Já existe um aluno cadastrado com esta matrícula.[/bold red]")
                continue

            return matricula
