from rich.table import Table

from .utils import *
from models.vaga_model import Vaga
from models.tipo_model import Tipo
from models.empresa_model import Empresa
from models.professor_model import Professor

class MenuVagas:
    def __init__(self):
        pass

    def run(self):
        while True:
            limpar_tela()

            console.print("[bold cyan]Gerenciamento de Vagas[/bold cyan]", justify="center")
            self._exibir_opcoes_menu()

            opcao = Prompt.ask("Escolha uma opção", choices=["1", "2", "3", "4", "5"], default="5")

            if opcao == "1": 
                self._exibir_lista_de_vagas()
            elif opcao == "2": 
                self._cadastrar_vaga()
            elif opcao == "3": 
                self._atualizar_vaga()
            elif opcao == "4": 
                self._remover_vaga()
            elif opcao == "5": 
                break

    def _exibir_lista_de_vagas(self):
        limpar_tela()

        console.print("[bold green]Lista de Vagas Abertas[/bold green]", justify="center")

        vagas = self._busca_todas_vagas()
        if not vagas:
            return
        
        self._mostra_tabela_vagas(vagas)

        input("\nPressione Enter para continuar...")

    def _cadastrar_vaga(self):
        limpar_tela()

        console.print("[bold green]Cadastro de Nova Vaga[/bold green]", justify="center")

        titulo = solicitar_entrada_obrigatoria("Título da Vaga")
        descricao = solicitar_entrada_obrigatoria("Descrição")

        data_fim_str = Prompt.ask("Data de Fim (AAAA-MM-DD, opcional)")
        data_fim = data_fim_str if data_fim_str else None

        try:
            carga_horaria = int(solicitar_entrada_obrigatoria("Carga Horária Semanal"))
            id_tipo = self._selecionar_tipo()
            if id_tipo is None: 
                return

            tipo_publicador = Prompt.ask("A vaga é de [E]mpresa ou [P]rofessor?", 
                                         choices=["e", "p"], default="e")

            cnpj, cpf_prof = None, None
            if tipo_publicador == 'e': 
                cnpj = self._selecionar_empresa()
            else: 
                cpf_prof = self._selecionar_professor()
            
            if (cnpj is None and cpf_prof is None): 
                console.print("[bold red]\nErro: A vaga deve ter um CNPJ ou CPF responsável pela vaga.[/bold red]")

                input("\nPressione Enter para continuar...")
                return
            
        except ValueError:
            console.print("[bold red]\nErro: A carga horária deve ser um número inteiro.[/bold red]")

            input("\nPressione Enter para continuar...")
            return
        
        nova_vaga = Vaga(titulo=titulo, descricao=descricao, carga_horaria=carga_horaria, id_tipo=id_tipo, data_fim=data_fim, cnpj=cnpj, cpf=cpf_prof)

        nova_vaga.create()

        input("\nPressione Enter para continuar...")

    def _atualizar_vaga(self):
        limpar_tela()

        console.print("[bold green]Atualização de Vaga[/bold green]", justify="center")

        try:
            id_vaga = int(solicitar_entrada_obrigatoria("Digite o ID da vaga que deseja atualizar"))
            vaga = Vaga.get_by_id(id_vaga)

            if not vaga:
                console.print(f"[bold red]Vaga com ID {id_vaga} não encontrada.[/bold red]")

                input("\nPressione Enter para continuar...")
                return
            
            console.print(f"\nEditando dados da vaga: [bold]{vaga.titulo}[/bold].",
                          "Pressione Enter para manter.")
            
            vaga.titulo = Prompt.ask("Título da Vaga", default=vaga.titulo)
            vaga.descricao = Prompt.ask("Descrição", default=vaga.descricao)
            vaga.carga_horaria = int(Prompt.ask("Carga Horária", default=str(vaga.carga_horaria)))

            vaga.update()
            
        except ValueError: 
            console.print("[bold red]\nErro: O ID e a carga horária devem ser números.[/bold red]")

        input("\nPressione Enter para continuar...")

    def _remover_vaga(self):
        limpar_tela()

        console.print("[bold red]Remover Vaga[/bold red]", justify="center")

        try:
            id_vaga = int(solicitar_entrada_obrigatoria("Digite o ID da vaga que deseja remover"))

            vaga = Vaga.get_by_id(id_vaga)
            if not vaga:
                console.print(f"[bold red]Vaga com ID {id_vaga} não encontrada.[/bold red]")

                input("\nPressione Enter para continuar...")
                return
            
            console.print(f"\nVaga a ser removida: [bold]{vaga.titulo}[/bold] (ID: {vaga.id})")
            console.print("Essa operação irá deletar todas as dependências da vaga (Candidaturas).")
            confirmacao = Prompt.ask("Tem certeza?", choices=["s", "n"], default="n")

            if confirmacao.lower() == 's':
                vaga.delete()
            else:
                console.print("[yellow]Operação cancelada.[/yellow]")

        except ValueError: 
            console.print("[bold red]\nErro: O ID da vaga deve ser um número.[/bold red]")

        input("\nPressione Enter para continuar...")

# ---------- MÉTODOS AUXILIARES ---------- #

    def _exibir_opcoes_menu(self):
        tabela_menu = Table(show_header=False, border_style="dim")

        tabela_menu.add_column("Opção", style="magenta", width=2); 
        tabela_menu.add_column("Descrição")
        
        tabela_menu.add_row("1", "Listar Todas as Vagas"); 
        tabela_menu.add_row("2", "Cadastrar Nova Vaga")
        tabela_menu.add_row("3", "Atualizar Vaga"); 
        tabela_menu.add_row("4", "Remover Vaga")
        tabela_menu.add_row("5", "Voltar ao Menu Principal")

        console.print(tabela_menu)

    def _busca_todas_vagas(self):
        vagas = Vaga.get_all()
        if not vagas:
            console.print("\n[yellow]Nenhuma vaga cadastrada.[/yellow]")

            input("\nPressione Enter para continuar...")
            return
        
        return vagas
    
    def _mostra_tabela_vagas(self, vagas):
        tabela_vagas = Table(title="Vagas", border_style="blue")

        tabela_vagas.add_column("ID", width=4); 
        tabela_vagas.add_column("Título", style="bold")
        tabela_vagas.add_column("Publicador"); 
        tabela_vagas.add_column("Tipo"); 
        tabela_vagas.add_column("C.H.", width=5)

        for vaga in vagas:
            publicador = vaga.nome_empresa or vaga.nome_professor
            tabela_vagas.add_row(str(vaga.id), vaga.titulo, publicador, 
                                 vaga.nome_tipo, str(vaga.carga_horaria))

        console.print(tabela_vagas)

    def _selecionar_tipo(self):
        tipos = Tipo.get_all()
        if not tipos: 
            console.print("[bold red]Nenhum tipo de vaga cadastrado.[/bold red]")
            return None
        
        tabela = Table(title="Tipos de Vaga"); 
        tabela.add_column("ID"); 
        tabela.add_column("Nome")

        choices = [str(t.id) for t in tipos]
        for t in tipos: 
            tabela.add_row(str(t.id), t.nome)

        console.print(tabela)

        while True:
            id_str = solicitar_entrada_obrigatoria("Escolha o ID do Tipo de Vaga")
            if id_str in choices: 
                return int(id_str)
            
            console.print(f"[bold red]ID '{id_str}' inválido.[/bold red]")

    def _selecionar_empresa(self):
        empresas = Empresa.get_all()
        if not empresas: 
            console.print("[bold red]Nenhuma empresa cadastrada.[/bold red]"); 
            return None
        
        tabela = Table(title="Empresas") 
        tabela.add_column("CNPJ") 
        tabela.add_column("Nome Fantasia")

        choices = [e.cnpj for e in empresas]
        for e in empresas: 
            tabela.add_row(e.cnpj, e.nome_fantasia)

        console.print(tabela)

        while True:
            cnpj = solicitar_entrada_obrigatoria("Escolha o CNPJ da Empresa")
            if cnpj in choices: 
                return cnpj
            
            console.print(f"[bold red]CNPJ '{cnpj}' inválido.[/bold red]")

    def _selecionar_professor(self):
        professores = Professor.get_all()
        if not professores: 
            console.print("[bold red]Nenhum professor cadastrado.[/bold red]"); 
            return None
        
        tabela = Table(title="Professores")
        tabela.add_column("CPF") 
        tabela.add_column("Nome")

        choices = [p.cpf for p in professores]
        for p in professores: 
            tabela.add_row(p.cpf, p.nome)

        console.print(tabela)

        while True:
            cpf = solicitar_entrada_obrigatoria("Escolha o CPF do Professor")
            if cpf in choices: 
                return cpf
            
            console.print(f"[bold red]CPF '{cpf}' inválido.[/bold red]")
