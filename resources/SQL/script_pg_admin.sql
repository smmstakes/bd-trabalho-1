--
-- PostgreSQL database dump
--

-- Dumped from database version 17.5 (Ubuntu 17.5-1.pgdg25.04+1)
-- Dumped by pg_dump version 17.5 (Ubuntu 17.5-1.pgdg25.04+1)

-- Started on 2025-05-30 13:27:02 -03

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 222 (class 1259 OID 16835)
-- Name: aluno; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.aluno (
    cpf character(11) NOT NULL,
    url_lattes character varying(50),
    semestre integer NOT NULL
);


ALTER TABLE public.aluno OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 16945)
-- Name: aluno_interesse; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.aluno_interesse (
    cpf character(11) NOT NULL,
    id_interesse integer NOT NULL
);


ALTER TABLE public.aluno_interesse OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 16924)
-- Name: area_de_interesse; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.area_de_interesse (
    id integer NOT NULL,
    nome character varying(45) NOT NULL
);


ALTER TABLE public.area_de_interesse OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 16923)
-- Name: area_de_interesse_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.area_de_interesse_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.area_de_interesse_id_seq OWNER TO postgres;

--
-- TOC entry 3586 (class 0 OID 0)
-- Dependencies: 231
-- Name: area_de_interesse_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.area_de_interesse_id_seq OWNED BY public.area_de_interesse.id;


--
-- TOC entry 233 (class 1259 OID 16930)
-- Name: area_vaga; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.area_vaga (
    id_vaga integer NOT NULL,
    id_interesse integer NOT NULL
);


ALTER TABLE public.area_vaga OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 16960)
-- Name: candidatura; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.candidatura (
    cpf character(11) NOT NULL,
    id_vaga integer NOT NULL,
    status character varying(15) NOT NULL,
    dt_candidatura date NOT NULL,
    arquivo_curriculo bytea
);


ALTER TABLE public.candidatura OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16829)
-- Name: departamento; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.departamento (
    id integer NOT NULL,
    nome character varying(45) NOT NULL
);


ALTER TABLE public.departamento OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 16828)
-- Name: departamento_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.departamento_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.departamento_id_seq OWNER TO postgres;

--
-- TOC entry 3587 (class 0 OID 0)
-- Dependencies: 220
-- Name: departamento_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.departamento_id_seq OWNED BY public.departamento.id;


--
-- TOC entry 225 (class 1259 OID 16870)
-- Name: empresa; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.empresa (
    cnpj character(14) NOT NULL,
    site character varying(50),
    razao_social character varying(50) NOT NULL,
    ramo_atividade character varying(50) NOT NULL,
    nome_fantasia character varying(50),
    email character varying(45) NOT NULL,
    id_endereco integer NOT NULL
);


ALTER TABLE public.empresa OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 16812)
-- Name: endereco; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.endereco (
    id integer NOT NULL,
    estado character varying(25) NOT NULL,
    cidade character varying(25) NOT NULL,
    cep character(8) NOT NULL,
    bairro character varying(25) NOT NULL,
    complemento character varying(30),
    numero character varying(10) NOT NULL
);


ALTER TABLE public.endereco OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 16811)
-- Name: endereco_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.endereco_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.endereco_id_seq OWNER TO postgres;

--
-- TOC entry 3588 (class 0 OID 0)
-- Dependencies: 217
-- Name: endereco_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.endereco_id_seq OWNED BY public.endereco.id;


--
-- TOC entry 219 (class 1259 OID 16818)
-- Name: pessoa; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pessoa (
    cpf character(11) NOT NULL,
    matricula character varying(15) NOT NULL,
    nome character varying(45) NOT NULL,
    email character varying(45),
    id_endereco integer NOT NULL
);


ALTER TABLE public.pessoa OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16845)
-- Name: professor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.professor (
    cpf character(11) NOT NULL,
    area_pesquisa character varying(50),
    id_departamento integer NOT NULL
);


ALTER TABLE public.professor OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 16882)
-- Name: telefone_empresarial; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.telefone_empresarial (
    cnpj character(14) NOT NULL,
    numero character(11) NOT NULL
);


ALTER TABLE public.telefone_empresarial OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 16860)
-- Name: telefone_pessoal; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.telefone_pessoal (
    cpf character(11) NOT NULL,
    numero character(11) NOT NULL
);


ALTER TABLE public.telefone_pessoal OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 16893)
-- Name: tipo; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tipo (
    id integer NOT NULL,
    nome character varying(45) NOT NULL
);


ALTER TABLE public.tipo OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 16892)
-- Name: tipo_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tipo_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tipo_id_seq OWNER TO postgres;

--
-- TOC entry 3589 (class 0 OID 0)
-- Dependencies: 227
-- Name: tipo_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tipo_id_seq OWNED BY public.tipo.id;


--
-- TOC entry 230 (class 1259 OID 16900)
-- Name: vaga; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.vaga (
    id integer NOT NULL,
    descricao character varying(255) NOT NULL,
    data_publicacao date NOT NULL,
    data_fim date NOT NULL,
    titulo character varying(255) NOT NULL,
    carga_horaria integer NOT NULL,
    cnpj character(14) NOT NULL,
    cpf character(11) NOT NULL,
    id_tipo integer NOT NULL
);


ALTER TABLE public.vaga OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 16899)
-- Name: vaga_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.vaga_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.vaga_id_seq OWNER TO postgres;

--
-- TOC entry 3590 (class 0 OID 0)
-- Dependencies: 229
-- Name: vaga_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.vaga_id_seq OWNED BY public.vaga.id;


--
-- TOC entry 3370 (class 2604 OID 16927)
-- Name: area_de_interesse id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.area_de_interesse ALTER COLUMN id SET DEFAULT nextval('public.area_de_interesse_id_seq'::regclass);


--
-- TOC entry 3367 (class 2604 OID 16832)
-- Name: departamento id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departamento ALTER COLUMN id SET DEFAULT nextval('public.departamento_id_seq'::regclass);


--
-- TOC entry 3366 (class 2604 OID 16815)
-- Name: endereco id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.endereco ALTER COLUMN id SET DEFAULT nextval('public.endereco_id_seq'::regclass);


--
-- TOC entry 3368 (class 2604 OID 16896)
-- Name: tipo id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tipo ALTER COLUMN id SET DEFAULT nextval('public.tipo_id_seq'::regclass);


--
-- TOC entry 3369 (class 2604 OID 16903)
-- Name: vaga id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vaga ALTER COLUMN id SET DEFAULT nextval('public.vaga_id_seq'::regclass);


--
-- TOC entry 3567 (class 0 OID 16835)
-- Dependencies: 222
-- Data for Name: aluno; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.aluno (cpf, url_lattes, semestre) FROM stdin;
\.


--
-- TOC entry 3579 (class 0 OID 16945)
-- Dependencies: 234
-- Data for Name: aluno_interesse; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.aluno_interesse (cpf, id_interesse) FROM stdin;
\.


--
-- TOC entry 3577 (class 0 OID 16924)
-- Dependencies: 232
-- Data for Name: area_de_interesse; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.area_de_interesse (id, nome) FROM stdin;
\.


--
-- TOC entry 3578 (class 0 OID 16930)
-- Dependencies: 233
-- Data for Name: area_vaga; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.area_vaga (id_vaga, id_interesse) FROM stdin;
\.


--
-- TOC entry 3580 (class 0 OID 16960)
-- Dependencies: 235
-- Data for Name: candidatura; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.candidatura (cpf, id_vaga, status, dt_candidatura, arquivo_curriculo) FROM stdin;
\.


--
-- TOC entry 3566 (class 0 OID 16829)
-- Dependencies: 221
-- Data for Name: departamento; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.departamento (id, nome) FROM stdin;
\.


--
-- TOC entry 3570 (class 0 OID 16870)
-- Dependencies: 225
-- Data for Name: empresa; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.empresa (cnpj, site, razao_social, ramo_atividade, nome_fantasia, email, id_endereco) FROM stdin;
\.


--
-- TOC entry 3563 (class 0 OID 16812)
-- Dependencies: 218
-- Data for Name: endereco; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.endereco (id, estado, cidade, cep, bairro, complemento, numero) FROM stdin;
\.


--
-- TOC entry 3564 (class 0 OID 16818)
-- Dependencies: 219
-- Data for Name: pessoa; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pessoa (cpf, matricula, nome, email, id_endereco) FROM stdin;
\.


--
-- TOC entry 3568 (class 0 OID 16845)
-- Dependencies: 223
-- Data for Name: professor; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.professor (cpf, area_pesquisa, id_departamento) FROM stdin;
\.


--
-- TOC entry 3571 (class 0 OID 16882)
-- Dependencies: 226
-- Data for Name: telefone_empresarial; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.telefone_empresarial (cnpj, numero) FROM stdin;
\.


--
-- TOC entry 3569 (class 0 OID 16860)
-- Dependencies: 224
-- Data for Name: telefone_pessoal; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.telefone_pessoal (cpf, numero) FROM stdin;
\.


--
-- TOC entry 3573 (class 0 OID 16893)
-- Dependencies: 228
-- Data for Name: tipo; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tipo (id, nome) FROM stdin;
\.


--
-- TOC entry 3575 (class 0 OID 16900)
-- Dependencies: 230
-- Data for Name: vaga; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.vaga (id, descricao, data_publicacao, data_fim, titulo, carga_horaria, cnpj, cpf, id_tipo) FROM stdin;
\.


--
-- TOC entry 3591 (class 0 OID 0)
-- Dependencies: 231
-- Name: area_de_interesse_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.area_de_interesse_id_seq', 1, false);


--
-- TOC entry 3592 (class 0 OID 0)
-- Dependencies: 220
-- Name: departamento_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.departamento_id_seq', 1, false);


--
-- TOC entry 3593 (class 0 OID 0)
-- Dependencies: 217
-- Name: endereco_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.endereco_id_seq', 1, false);


--
-- TOC entry 3594 (class 0 OID 0)
-- Dependencies: 227
-- Name: tipo_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tipo_id_seq', 1, false);


--
-- TOC entry 3595 (class 0 OID 0)
-- Dependencies: 229
-- Name: vaga_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.vaga_id_seq', 1, false);


--
-- TOC entry 3398 (class 2606 OID 16949)
-- Name: aluno_interesse aluno_interesse_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.aluno_interesse
    ADD CONSTRAINT aluno_interesse_pkey PRIMARY KEY (cpf, id_interesse);


--
-- TOC entry 3378 (class 2606 OID 16839)
-- Name: aluno aluno_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.aluno
    ADD CONSTRAINT aluno_pkey PRIMARY KEY (cpf);


--
-- TOC entry 3394 (class 2606 OID 16929)
-- Name: area_de_interesse area_de_interesse_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.area_de_interesse
    ADD CONSTRAINT area_de_interesse_pkey PRIMARY KEY (id);


--
-- TOC entry 3396 (class 2606 OID 16934)
-- Name: area_vaga area_vaga_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.area_vaga
    ADD CONSTRAINT area_vaga_pkey PRIMARY KEY (id_vaga, id_interesse);


--
-- TOC entry 3400 (class 2606 OID 16966)
-- Name: candidatura candidatura_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.candidatura
    ADD CONSTRAINT candidatura_pkey PRIMARY KEY (cpf, id_vaga);


--
-- TOC entry 3376 (class 2606 OID 16834)
-- Name: departamento departamento_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departamento
    ADD CONSTRAINT departamento_pkey PRIMARY KEY (id);


--
-- TOC entry 3384 (class 2606 OID 16876)
-- Name: empresa empresa_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.empresa
    ADD CONSTRAINT empresa_email_key UNIQUE (email);


--
-- TOC entry 3386 (class 2606 OID 16874)
-- Name: empresa empresa_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.empresa
    ADD CONSTRAINT empresa_pkey PRIMARY KEY (cnpj);


--
-- TOC entry 3372 (class 2606 OID 16817)
-- Name: endereco endereco_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.endereco
    ADD CONSTRAINT endereco_pkey PRIMARY KEY (id);


--
-- TOC entry 3374 (class 2606 OID 16822)
-- Name: pessoa pessoa_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pessoa
    ADD CONSTRAINT pessoa_pkey PRIMARY KEY (cpf);


--
-- TOC entry 3380 (class 2606 OID 16849)
-- Name: professor professor_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.professor
    ADD CONSTRAINT professor_pkey PRIMARY KEY (cpf);


--
-- TOC entry 3388 (class 2606 OID 16886)
-- Name: telefone_empresarial telefone_empresarial_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.telefone_empresarial
    ADD CONSTRAINT telefone_empresarial_pkey PRIMARY KEY (cnpj, numero);


--
-- TOC entry 3382 (class 2606 OID 16864)
-- Name: telefone_pessoal telefone_pessoal_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.telefone_pessoal
    ADD CONSTRAINT telefone_pessoal_pkey PRIMARY KEY (cpf, numero);


--
-- TOC entry 3390 (class 2606 OID 16898)
-- Name: tipo tipo_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tipo
    ADD CONSTRAINT tipo_pkey PRIMARY KEY (id);


--
-- TOC entry 3392 (class 2606 OID 16907)
-- Name: vaga vaga_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vaga
    ADD CONSTRAINT vaga_pkey PRIMARY KEY (id);


--
-- TOC entry 3402 (class 2606 OID 16840)
-- Name: aluno aluno_cpf_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.aluno
    ADD CONSTRAINT aluno_cpf_fkey FOREIGN KEY (cpf) REFERENCES public.pessoa(cpf);


--
-- TOC entry 3413 (class 2606 OID 16950)
-- Name: aluno_interesse aluno_interesse_cpf_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.aluno_interesse
    ADD CONSTRAINT aluno_interesse_cpf_fkey FOREIGN KEY (cpf) REFERENCES public.aluno(cpf);


--
-- TOC entry 3414 (class 2606 OID 16955)
-- Name: aluno_interesse aluno_interesse_id_interesse_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.aluno_interesse
    ADD CONSTRAINT aluno_interesse_id_interesse_fkey FOREIGN KEY (id_interesse) REFERENCES public.area_de_interesse(id);


--
-- TOC entry 3411 (class 2606 OID 16940)
-- Name: area_vaga area_vaga_id_interesse_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.area_vaga
    ADD CONSTRAINT area_vaga_id_interesse_fkey FOREIGN KEY (id_interesse) REFERENCES public.area_de_interesse(id);


--
-- TOC entry 3412 (class 2606 OID 16935)
-- Name: area_vaga area_vaga_id_vaga_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.area_vaga
    ADD CONSTRAINT area_vaga_id_vaga_fkey FOREIGN KEY (id_vaga) REFERENCES public.vaga(id);


--
-- TOC entry 3415 (class 2606 OID 16967)
-- Name: candidatura candidatura_cpf_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.candidatura
    ADD CONSTRAINT candidatura_cpf_fkey FOREIGN KEY (cpf) REFERENCES public.aluno(cpf);


--
-- TOC entry 3416 (class 2606 OID 16972)
-- Name: candidatura candidatura_id_vaga_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.candidatura
    ADD CONSTRAINT candidatura_id_vaga_fkey FOREIGN KEY (id_vaga) REFERENCES public.vaga(id);


--
-- TOC entry 3406 (class 2606 OID 16877)
-- Name: empresa empresa_id_endereco_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.empresa
    ADD CONSTRAINT empresa_id_endereco_fkey FOREIGN KEY (id_endereco) REFERENCES public.endereco(id);


--
-- TOC entry 3401 (class 2606 OID 16823)
-- Name: pessoa pessoa_id_endereco_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pessoa
    ADD CONSTRAINT pessoa_id_endereco_fkey FOREIGN KEY (id_endereco) REFERENCES public.endereco(id);


--
-- TOC entry 3403 (class 2606 OID 16850)
-- Name: professor professor_cpf_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.professor
    ADD CONSTRAINT professor_cpf_fkey FOREIGN KEY (cpf) REFERENCES public.pessoa(cpf);


--
-- TOC entry 3404 (class 2606 OID 16855)
-- Name: professor professor_id_departamento_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.professor
    ADD CONSTRAINT professor_id_departamento_fkey FOREIGN KEY (id_departamento) REFERENCES public.departamento(id);


--
-- TOC entry 3407 (class 2606 OID 16887)
-- Name: telefone_empresarial telefone_empresarial_cnpj_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.telefone_empresarial
    ADD CONSTRAINT telefone_empresarial_cnpj_fkey FOREIGN KEY (cnpj) REFERENCES public.empresa(cnpj);


--
-- TOC entry 3405 (class 2606 OID 16865)
-- Name: telefone_pessoal telefone_pessoal_cpf_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.telefone_pessoal
    ADD CONSTRAINT telefone_pessoal_cpf_fkey FOREIGN KEY (cpf) REFERENCES public.pessoa(cpf);


--
-- TOC entry 3408 (class 2606 OID 16908)
-- Name: vaga vaga_cnpj_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vaga
    ADD CONSTRAINT vaga_cnpj_fkey FOREIGN KEY (cnpj) REFERENCES public.empresa(cnpj);


--
-- TOC entry 3409 (class 2606 OID 16913)
-- Name: vaga vaga_cpf_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vaga
    ADD CONSTRAINT vaga_cpf_fkey FOREIGN KEY (cpf) REFERENCES public.professor(cpf);


--
-- TOC entry 3410 (class 2606 OID 16918)
-- Name: vaga vaga_id_tipo_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vaga
    ADD CONSTRAINT vaga_id_tipo_fkey FOREIGN KEY (id_tipo) REFERENCES public.tipo(id);


-- Completed on 2025-05-30 13:27:02 -03

--
-- PostgreSQL database dump complete
--

