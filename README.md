# Catálogo de Vagas - Projeto de Banco de Dados

Este projeto foi desenvolvido para a disciplina de Banco de Dados do curso de Ciências da Computação da Universidade de Brasília (UnB).

> **OBS:** O projeto apresentado é uma versão simplificada e não contém todas as funcionalidades de um sistema completo. É uma demonstração de conceitos básicos de banco de dados e programação em Python, em outras palavras, é uma espécie de MVP (Minimum Viable Product).

## Equipe

* **Suyanne Sara Miranda Silva** - 222006445
* **Matheus Duarte da Silva** - 211062277
* **Gabriela Fernanda Rodrigues Costa** - 180120859

## Descrição do Projeto

O "Catálogo de Estágios e Vagas de Iniciação Científica" é um sistema para centralizar e organizar a divulgação de oportunidades acadêmicas e profissionais para os estudantes da UnB. O objetivo é resolver o problema da comunicação descentralizada, que atualmente limita o acesso dos alunos a vagas relevantes para suas áreas de estudo.

## Tecnologias Utilizadas

* **Linguagem:** Python 3.13.2
* **Banco de Dados:** PostgreSQL
* **Interface:** Biblioteca `rich` para interface de linha de comando (CLI).
* **Conector Python-PostgreSQL:** `psycopg2`

## Como Executar o Projeto

Siga os passos abaixo para configurar e executar a aplicação em seu ambiente local.

### 1. Pré-requisitos

* **Python 3.13.2 ou superior:** [Link para download](https://www.python.org/downloads/)
* **PostgreSQL:** [Link para download](https://www.postgresql.org/download/)
* **Git:** [Link para download](https://git-scm.com/downloads)

### 2. Clone o Repositório

Abra um terminal e clone o repositório do projeto:
```bash
git clone https://github.com/smmstakes/bd-trabalho-1
cd bd-trabalho-1/project
```

### 3. Configuração do Banco de Dados

É necessário criar o banco de dados e as tabelas manualmente antes de executar a aplicação.

1.  **Acesse o PostgreSQL:** Abra o terminal de comando `psql` ou utilize uma ferramenta gráfica como DBeaver ou pgAdmin.

2.  **Crie o Banco de Dados:** Execute o seguinte comando SQL para criar o banco que a aplicação espera.
    ```sql
    CREATE DATABASE "bd_catalogo_vagas";
    ```

3.  **Conecte-se ao Novo Banco:** Feche a conexão atual e conecte-se ao banco `bd_catalogo_vagas` que você acabou de criar.

4.  **Execute os Scripts SQL:** Execute os scripts na **ordem correta** para criar a estrutura e popular os dados.
    * Primeiro, execute o conteúdo do arquivo `resources/SQL/script_cria_banco.sql` para criar todas as tabelas.
    * Depois, execute o conteúdo do arquivo `resources/SQL/script_insere_dados.sql` para inserir os dados de exemplo.

### 4. Configuração do Ambiente Python

É recomendado o uso de um ambiente virtual (`venv`) para isolar as dependências do projeto.

1.  **Crie o Ambiente Virtual:**
    ```bash
    python -m venv venv-catalogo-vagas
    ```

2.  **Ative o Ambiente Virtual:**
    * **Windows (PowerShell/CMD):**
        ```powershell
        .\venv\Scripts\Activate.ps1
        ```
    * **Linux/macOS:**
        ```bash
        source venv/bin/activate
        ```

3.  **Instale as Dependências:**
    Instale as dependências com o comando:
    ```bash
    pip install -r requirements.txt
    ```

#### 4.1 Utilizando o Conda

Se você preferir usar o Conda, siga os passos abaixo:

1.  **Crie o Ambiente Conda:**
    ```bash
    conda env create --name bd-trabalho-1-env --file environment.yml
    ```

2.  **Ative o Ambiente Conda:**
    ```bash
    conda activate bd-trabalho-1-env
    ```

### 5. Configuração da Conexão

**Este é um passo crucial.** Abra o arquivo `database/connection.py` e altere as credenciais de conexão para as que você configurou no seu PostgreSQL local.

```python
# Em database/connection.py
conn = psycopg2.connect(
    dbname="bd_catalogo_vagas",
    user="[seu_usuario_postgres]",      # <-- SUBSTITUA AQUI
    password="[sua_senha_postgres]",    # <-- SUBSTITUA AQUI
    host="localhost",
    port="5432"
)
```

### 6. Execute a Aplicação

Com tudo configurado, execute o arquivo principal:

```bash
python main.py
```

A interface do sistema deverá aparecer no seu terminal.
