-- Descrição: Script para popular o banco de dados com dados de exemplo.

INSERT INTO DEPARTAMENTO (NOME) VALUES
('Depto Ciência da Computação'),
('Depto Engenharia Elétrica'),
('Faculdade de Tecnologia'),
('Depto Matemática'),
('Depto Física');

INSERT INTO CURSO (NOME) VALUES
('Ciência da Computação'),
('Engenharia Elétrica'),
('Engenharia Mecatrônica'),
('Matemática'),
('Física');

INSERT INTO TIPO (NOME) VALUES
('Estágio'),
('Iniciação Científica'),
('Bolsa de Extensão'),
('Monitoria'),
('Freelance');

INSERT INTO AREA_DE_INTERESSE (NOME) VALUES
('Desenvolvimento Web'),
('Inteligência Artificial'),
('Segurança da Informação'),
('Banco de Dados'),
('Sistemas Embarcados'),
('Robótica'),
('Redes de Computadores');

INSERT INTO EMPRESA (CNPJ, NOME_FANTASIA, RAZAO_SOCIAL, RAMO_ATIVIDADE, EMAIL, CEP_END, COMPLEMENTO_END, NUMERO_END) VALUES
('11111111000100', 'Tech Solutions', 'Tech Solutions LTDA', 'Tecnologia', 'contato@techsolutions.com', '70910900', 'Asa Norte', '101'),
('22222222000100', 'Inova Web', 'Inova Web e Marketing', 'Marketing Digital', 'rh@inovaweb.com', '71900100', 'Taguatinga', '202'),
('33333333000100', 'CyberSec', 'Cyber Security Partners', 'Segurança da Informação', 'vagas@cybersec.com', '70340904', 'Asa Sul', '303'),
('44444444000100', 'Data Minds', 'Data Minds Analytics', 'Análise de Dados', 'talentos@dataminds.ai', '70910900', 'Asa Norte', '404'),
('55555555000100', 'Automa Ind.', 'Automação Industrial SA', 'Indústria', 'engenharia@automaind.com', '72005100', 'Ceilândia', '505');

-- Populando PESSOA (5 alunos e 5 professores)
-- Alunos
INSERT INTO PESSOA (CPF, MATRICULA, NOME, EMAIL, CEP_END, COMPLEMENTO_END, NUMERO_END) VALUES
('11122233301', '210010001', 'Ana Clara Souza', 'ana.souza@aluno.unb.br', '70000001', 'Bl A Apto 101', '1'),
('11122233302', '210010002', 'Bruno Carvalho', 'bruno.carvalho@aluno.unb.br', '70000002', 'Bl B Apto 102', '2'),
('11122233303', '200020003', 'Carla Dias', 'carla.dias@aluno.unb.br', '70000003', 'Bl C Apto 103', '3'),
('11122233304', '220030004', 'Daniel Martins', 'daniel.martins@aluno.unb.br', '70000004', 'Bl D Apto 104', '4'),
('11122233305', '190040005', 'Elisa Ferreira', 'elisa.ferreira@aluno.unb.br', '70000005', 'Bl E Apto 105', '5');

-- Professores
INSERT INTO PESSOA (CPF, MATRICULA, NOME, EMAIL, CEP_END, COMPLEMENTO_END, NUMERO_END) VALUES
('99988877701', '991001', 'Prof. Ricardo Borges', 'ricardo.borges@unb.br', '71000001', 'QI 1 Bl A', '10'),
('99988877702', '991002', 'Profa. Laura Mendes', 'laura.mendes@unb.br', '71000002', 'QI 2 Bl B', '20'),
('99988877703', '991003', 'Prof. Fernando Costa', 'fernando.costa@unb.br', '71000003', 'QI 3 Bl C', '30'),
('99988877704', '991004', 'Profa. Sofia Pereira', 'sofia.pereira@unb.br', '71000004', 'QI 4 Bl D', '40'),
('99988877705', '991005', 'Prof. Marcos Andrade', 'marcos.andrade@unb.br', '71000005', 'QI 5 Bl E', '50');

-- Populando as especializações ALUNO e PROFESSOR
INSERT INTO ALUNO (CPF, URL_LATTES, SEMESTRE, ID_CURSO) VALUES
('11122233301', 'http://lattes.cnpq.br/1', 6, 1),
('11122233302', 'http://lattes.cnpq.br/2', 5, 2),
('11122233303', 'http://lattes.cnpq.br/3', 7, 3),
('11122233304', 'http://lattes.cnpq.br/4', 3, 4),
('11122233305', 'http://lattes.cnpq.br/5', 8, 5);

INSERT INTO PROFESSOR (CPF, AREA_PESQUISA, ID_DEPARTAMENTO) VALUES
('99988877701', 'Inteligência Artificial', 1),
('99988877702', 'Engenharia de Software', 1),
('99988877703', 'Sistemas Embarcados', 3),
('99988877704', 'Processamento de Sinais', 2),
('99988877705', 'Cálculo Numérico', 4);

INSERT INTO VAGA (DESCRICAO, DATA_PUBLICACAO, TITULO, CARGA_HORARIA, CNPJ, CPF, ID_TIPO) VALUES
('Desenvolvimento de API REST para sistema de e-commerce.', '2025-06-01', 'Estágio em Backend', 20, '11111111000100', NULL, 1),
('Pesquisa em modelos de aprendizado de máquina para processamento de linguagem natural.', '2025-06-05', 'Iniciação Científica em IA', 15, NULL, '99988877701', 2),
('Manutenção e desenvolvimento de site institucional em WordPress.', '2025-06-10', 'Bolsa de Extensão Web', 12, NULL, '99988877702', 3),
('Análise de vulnerabilidades em sistemas web.', '2025-06-12', 'Estágio em Segurança da Informação', 30, '33333333000100', NULL, 1),
('Criação de dashboards em PowerBI para análise de dados de vendas.', '2025-06-15', 'Estágio em Business Intelligence', 25, '44444444000100', NULL, 1),
('Desenvolvimento de firmware para microcontroladores ARM.', '2025-06-20', 'Iniciação Científica em Sistemas Embarcados', 20, NULL, '99988877703', 2);

-- Inserir um currículo como um dado binário (exemplo com texto convertido para bytes)
-- Texto "Teste de curriculo." em bytes
INSERT INTO CANDIDATURA (CPF, ID_VAGA, STATUS_CANDIDATURA, DT_CANDIDATURA, ARQUIVO_CURRICULO) VALUES
('11122233301', 1, 'Enviada', '2025-06-02', E'\\x546573746520646520637572726963756c6f2e'), 
('11122233301', 2, 'Em análise', '2025-06-06', E'\\x546573746520646520637572726963756c6f2e'),
('11122233302', 1, 'Enviada', '2025-06-03', E'\\x546573746520646520637572726963756c6f2e'),
('11122233303', 4, 'Aprovada', '2025-06-13', E'\\x546573746520646520637572726963756c6f2e'),
('11122233304', 5, 'Rejeitada', '2025-06-16', E'\\x546573746520646520637572726963756c6f2e');

INSERT INTO TELEFONE_PESSOAL (CPF, NUMERO) VALUES
('11122233301', '61991234501'),
('11122233302', '61991234502'),
('11122233303', '61991234503'),
('11122233304', '61991234504'),
('11122233305', '61991234505'),
('99988877701', '61988776601'),
('99988877702', '61988776602');

INSERT INTO TELEFONE_EMPRESARIAL (CNPJ, NUMERO) VALUES
('11111111000100', '6132011000'),
('22222222000100', '6132022000'),
('33333333000100', '6132033000'),
('44444444000100', '6132044000'),
('55555555000100', '6132055000');

INSERT INTO ALUNO_INTERESSE (CPF, ID_INTERESSE) VALUES
('11122233301', 1)
('11122233301', 4),
('11122233302', 1),
('11122233302', 5),
('11122233303', 6),
('11122233304', 7),
('11122233305', 2);

INSERT INTO AREA_VAGA (ID_VAGA, ID_INTERESSE) VALUES
(1, 1),
(1, 4),
(2, 2),
(3, 1),
(4, 3),
(5, 4),
(6, 5),
(6, 6);
