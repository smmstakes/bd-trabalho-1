-- Tabela de Endereco
CREATE TABLE Endereco (
    id SERIAL PRIMARY KEY,
    estado VARCHAR(25),
    cidade VARCHAR(25),
    CEP VARCHAR(8),
    bairro VARCHAR(25),
    complemento VARCHAR(30),
    numero VARCHAR(10)
);

-- Tabela de  Pessoa
CREATE TABLE Pessoa (
    CPF VARCHAR(11) PRIMARY KEY,
    nome VARCHAR(45),
    email VARCHAR(45),
    id_endereco INTEGER,
    FOREIGN KEY (id_endereco) REFERENCES Endereco(id)
);

-- Tabela de Departamento (Professor)
CREATE TABLE Departamento (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(45)
);

-- Tabela de Aluno (Especialização)
CREATE TABLE Aluno (
    CPF VARCHAR(11) PRIMARY KEY,
    matricula VARCHAR(10) UNIQUE,
    url_lattes VARCHAR(50),
    semestre INTEGER,
    FOREIGN KEY (CPF) REFERENCES Pessoa(CPF)
);

-- Tabela de  Professor (Especialização)
CREATE TABLE Professor (
    CPF VARCHAR(11) PRIMARY KEY,
    matricula VARCHAR(15) UNIQUE,
    area_pesquisa VARCHAR(50),
    id_departamento INTEGER,
    FOREIGN KEY (CPF) REFERENCES Pessoa(CPF),
    FOREIGN KEY (id_departamento) REFERENCES Departamento(id)
);

-- Tabela de Relacionamento: Telefone-Pessoa
CREATE TABLE Telefone_Pessoal (
    CPF VARCHAR(11),
    numero VARCHAR(15),
    PRIMARY KEY (CPF, numero),
    FOREIGN KEY (CPF) REFERENCES Pessoa(CPF)
);

-- Tabela de Empresa
CREATE TABLE Empresa (
    CNPJ VARCHAR(14) PRIMARY KEY,
    site VARCHAR(50),
    razao_social VARCHAR(50),
    ramo_atividade VARCHAR(50),
    nome_fantasia VARCHAR(50),
    email VARCHAR(45) UNIQUE,
    id_endereco INTEGER,
    FOREIGN KEY (id_endereco) REFERENCES Endereco(id)
);

-- Tabela de Relacionamento: Telefone-Empresa
CREATE TABLE Telefone_Empresarial (
    CNPJ VARCHAR(14),
    numero VARCHAR(15),
    PRIMARY KEY (CNPJ, numero),
    FOREIGN KEY (CNPJ) REFERENCES Empresa(CNPJ)
);

-- Tabela de Tipo (Vaga)
CREATE TABLE Tipo (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(45)
);

-- Tabela de Vaga
CREATE TABLE Vaga (
    id SERIAL PRIMARY KEY,
    descricao VARCHAR(255),
    data_publicacao DATE,
    data_fim DATE,
    titulo VARCHAR(255),
    carga_horaria INTEGER,
    CNPJ VARCHAR(14),
    CPF VARCHAR(11),
    id_tipo INTEGER,
	FOREIGN KEY (CNPJ) REFERENCES Empresa(CNPJ),
	FOREIGN KEY (CPF) REFERENCES Professor(CPF),
	FOREIGN KEY (id_tipo) REFERENCES Tipo(id)
);

-- Tabela de Area de Interesse (Vaga)
CREATE TABLE Area_Interesse (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(45)
);

-- Tabela de Relacionamento: Vaga-Interesse
CREATE TABLE Vaga_Area_Interesse (
    id_vaga INTEGER,
    id_interesse INTEGER,
    PRIMARY KEY (id_vaga, id_interesse),
    FOREIGN KEY (id_vaga) REFERENCES Vaga(id),
    FOREIGN KEY (id_interesse) REFERENCES Area_Interesse(id)
);

-- Tabela de Relacionamento: Aluno-Interesse
CREATE TABLE Aluno_Area_Interesse (
    CPF VARCHAR(11),
    id_interesse INTEGER,
    PRIMARY KEY (CPF, id_interesse),
    FOREIGN KEY (CPF) REFERENCES Aluno(CPF),
    FOREIGN KEY (id_interesse) REFERENCES Area_Interesse(id)
);

-- Tabela de Candidatura (Aluno - Entidade Fraca)
CREATE TABLE Candidatura (
    CPF VARCHAR(11),
    id_vaga INTEGER,
    status VARCHAR(15),
    dt_candidatura DATE,
    arquivo_curriculo BYTEA,
    PRIMARY KEY (CPF, id_vaga),
    FOREIGN KEY (CPF) REFERENCES Aluno(CPF),
    FOREIGN KEY (id_vaga) REFERENCES Vaga(id)
);
