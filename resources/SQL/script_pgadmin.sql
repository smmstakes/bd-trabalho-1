--
-- PostgreSQL database dump
--

-- Dumped from database version 14.18 (Ubuntu 14.18-0ubuntu0.22.04.1)
-- Dumped by pg_dump version 14.18 (Ubuntu 14.18-0ubuntu0.22.04.1)

-- Started on 2025-07-08 09:10:00 -03

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 232 (class 1255 OID 17010)
-- Name: atualizar_interesses_aluno(character, integer[]); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.atualizar_interesses_aluno(IN cpf_aluno character, IN aluno_novos_interesses integer[])
    LANGUAGE plpgsql
    AS $$
DECLARE
    i_id INTEGER;
    interesses_adicionados INTEGER := 0;
    interesses_ignorados INTEGER := 0;
BEGIN
    IF NOT EXISTS (SELECT 1 FROM aluno WHERE cpf = cpf_aluno) THEN
        RAISE EXCEPTION 'Aluno não encontrado';
    END IF;

    FOREACH i_id IN ARRAY aluno_novos_interesses
    LOOP
        IF NOT EXISTS (SELECT 1 FROM area_de_interesse WHERE id = i_id) THEN
            RAISE NOTICE 'Área de interesse % não existe', i_id;
            interesses_ignorados := interesses_ignorados + 1;
            CONTINUE;
        END IF;

        IF NOT EXISTS (SELECT 1 FROM aluno_interesse WHERE cpf = cpf_aluno AND id_interesse = i_id) THEN
            INSERT INTO aluno_interesse (cpf, id_interesse)
            VALUES (cpf_aluno, i_id);
            
            interesses_adicionados := interesses_adicionados + 1;
        ELSE
            interesses_ignorados := interesses_ignorados + 1;
        END IF;
    END LOOP;

    RAISE NOTICE 'Interesses atualizados para aluno %: % adicionados, % já cadastrados/ignorados',
        cpf_aluno, interesses_adicionados, interesses_ignorados;
END;
$$;


ALTER PROCEDURE public.atualizar_interesses_aluno(IN cpf_aluno character, IN aluno_novos_interesses integer[]) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 214 (class 1259 OID 16865)
-- Name: aluno; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.aluno (
    cpf character(11) NOT NULL,
    url_lattes character varying(50),
    semestre integer NOT NULL,
    id_curso integer NOT NULL
);


ALTER TABLE public.aluno OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 16973)
-- Name: aluno_interesse; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.aluno_interesse (
    cpf character(11) NOT NULL,
    id_interesse integer NOT NULL
);


ALTER TABLE public.aluno_interesse OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 16952)
-- Name: area_de_interesse; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.area_de_interesse (
    id integer NOT NULL,
    nome character varying(45) NOT NULL
);


ALTER TABLE public.area_de_interesse OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16951)
-- Name: area_de_interesse_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.area_de_interesse_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.area_de_interesse_id_seq OWNER TO postgres;

--
-- TOC entry 3467 (class 0 OID 0)
-- Dependencies: 223
-- Name: area_de_interesse_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.area_de_interesse_id_seq OWNED BY public.area_de_interesse.id;


--
-- TOC entry 225 (class 1259 OID 16958)
-- Name: area_vaga; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.area_vaga (
    id_vaga integer NOT NULL,
    id_interesse integer NOT NULL
);


ALTER TABLE public.area_vaga OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 16988)
-- Name: candidatura; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.candidatura (
    cpf character(11) NOT NULL,
    id_vaga integer NOT NULL,
    status_candidatura character varying(15) NOT NULL,
    dt_candidatura date NOT NULL,
    arquivo_curriculo bytea
);


ALTER TABLE public.candidatura OWNER TO postgres;

--
-- TOC entry 213 (class 1259 OID 16859)
-- Name: curso; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.curso (
    id integer NOT NULL,
    nome character varying(45) NOT NULL
);


ALTER TABLE public.curso OWNER TO postgres;

--
-- TOC entry 212 (class 1259 OID 16858)
-- Name: curso_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.curso_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.curso_id_seq OWNER TO postgres;

--
-- TOC entry 3468 (class 0 OID 0)
-- Dependencies: 212
-- Name: curso_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.curso_id_seq OWNED BY public.curso.id;


--
-- TOC entry 211 (class 1259 OID 16852)
-- Name: departamento; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.departamento (
    id integer NOT NULL,
    nome character varying(45) NOT NULL
);


ALTER TABLE public.departamento OWNER TO postgres;

--
-- TOC entry 210 (class 1259 OID 16851)
-- Name: departamento_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.departamento_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.departamento_id_seq OWNER TO postgres;

--
-- TOC entry 3469 (class 0 OID 0)
-- Dependencies: 210
-- Name: departamento_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.departamento_id_seq OWNED BY public.departamento.id;


--
-- TOC entry 217 (class 1259 OID 16905)
-- Name: empresa; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.empresa (
    cnpj character(14) NOT NULL,
    site_emp character varying(50),
    razao_social character varying(50),
    ramo_atividade character varying(50),
    nome_fantasia character varying(50),
    email character varying(45) NOT NULL,
    cep_end character(8) NOT NULL,
    complemento_end character varying(30) NOT NULL,
    numero_end character varying(10) NOT NULL
);


ALTER TABLE public.empresa OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 16930)
-- Name: vaga; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.vaga (
    id integer NOT NULL,
    descricao character varying(255),
    data_publicacao date NOT NULL,
    data_fim date,
    titulo character varying(65) NOT NULL,
    carga_horaria integer NOT NULL,
    cnpj character(14),
    cpf character(11),
    id_tipo integer NOT NULL
);


ALTER TABLE public.vaga OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 17005)
-- Name: mapeamentorelacaovagas; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.mapeamentorelacaovagas AS
 SELECT ai.id,
    ai.nome,
    count(DISTINCT v.id) AS vagas,
    count(DISTINCT al_i.cpf) AS alunos,
        CASE
            WHEN (count(DISTINCT v.id) = 0) THEN NULL::numeric
            ELSE round(((count(DISTINCT al_i.cpf))::numeric / (count(DISTINCT v.id))::numeric), 2)
        END AS relacao,
    round(avg(v.carga_horaria), 1) AS horas_medias,
    count(DISTINCT v.cnpj) AS empresas,
    count(DISTINCT v.cpf) AS professores
   FROM (((public.area_de_interesse ai
     LEFT JOIN public.area_vaga av ON ((ai.id = av.id_interesse)))
     LEFT JOIN public.vaga v ON ((av.id_vaga = v.id)))
     LEFT JOIN public.aluno_interesse al_i ON ((ai.id = al_i.id_interesse)))
  GROUP BY ai.id, ai.nome
  ORDER BY ai.id;


ALTER TABLE public.mapeamentorelacaovagas OWNER TO postgres;

--
-- TOC entry 209 (class 1259 OID 16844)
-- Name: pessoa; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pessoa (
    cpf character(11) NOT NULL,
    matricula character varying(15) NOT NULL,
    nome character varying(45) NOT NULL,
    email character varying(45) NOT NULL,
    cep_end character(8) NOT NULL,
    complemento_end character varying(30) NOT NULL,
    numero_end character varying(10) NOT NULL
);


ALTER TABLE public.pessoa OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 16880)
-- Name: professor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.professor (
    cpf character(11) NOT NULL,
    area_pesquisa character varying(50),
    id_departamento integer NOT NULL
);


ALTER TABLE public.professor OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 16912)
-- Name: telefone_empresarial; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.telefone_empresarial (
    cnpj character(14) NOT NULL,
    numero character(11) NOT NULL
);


ALTER TABLE public.telefone_empresarial OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 16895)
-- Name: telefone_pessoal; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.telefone_pessoal (
    cpf character(11) NOT NULL,
    numero character(11) NOT NULL
);


ALTER TABLE public.telefone_pessoal OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 16923)
-- Name: tipo; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tipo (
    id integer NOT NULL,
    nome character varying(45) NOT NULL
);


ALTER TABLE public.tipo OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16922)
-- Name: tipo_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tipo_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tipo_id_seq OWNER TO postgres;

--
-- TOC entry 3470 (class 0 OID 0)
-- Dependencies: 219
-- Name: tipo_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tipo_id_seq OWNED BY public.tipo.id;


--
-- TOC entry 221 (class 1259 OID 16929)
-- Name: vaga_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.vaga_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.vaga_id_seq OWNER TO postgres;

--
-- TOC entry 3471 (class 0 OID 0)
-- Dependencies: 221
-- Name: vaga_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.vaga_id_seq OWNED BY public.vaga.id;


--
-- TOC entry 3274 (class 2604 OID 16955)
-- Name: area_de_interesse id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.area_de_interesse ALTER COLUMN id SET DEFAULT nextval('public.area_de_interesse_id_seq'::regclass);


--
-- TOC entry 3271 (class 2604 OID 16862)
-- Name: curso id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.curso ALTER COLUMN id SET DEFAULT nextval('public.curso_id_seq'::regclass);


--
-- TOC entry 3270 (class 2604 OID 16855)
-- Name: departamento id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departamento ALTER COLUMN id SET DEFAULT nextval('public.departamento_id_seq'::regclass);


--
-- TOC entry 3272 (class 2604 OID 16926)
-- Name: tipo id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tipo ALTER COLUMN id SET DEFAULT nextval('public.tipo_id_seq'::regclass);


--
-- TOC entry 3273 (class 2604 OID 16933)
-- Name: vaga id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vaga ALTER COLUMN id SET DEFAULT nextval('public.vaga_id_seq'::regclass);


--
-- TOC entry 3304 (class 2606 OID 16977)
-- Name: aluno_interesse aluno_interesse_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.aluno_interesse
    ADD CONSTRAINT aluno_interesse_pkey PRIMARY KEY (cpf, id_interesse);


--
-- TOC entry 3284 (class 2606 OID 16869)
-- Name: aluno aluno_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.aluno
    ADD CONSTRAINT aluno_pkey PRIMARY KEY (cpf);


--
-- TOC entry 3300 (class 2606 OID 16957)
-- Name: area_de_interesse area_de_interesse_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.area_de_interesse
    ADD CONSTRAINT area_de_interesse_pkey PRIMARY KEY (id);


--
-- TOC entry 3302 (class 2606 OID 16962)
-- Name: area_vaga area_vaga_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.area_vaga
    ADD CONSTRAINT area_vaga_pkey PRIMARY KEY (id_vaga, id_interesse);


--
-- TOC entry 3306 (class 2606 OID 16994)
-- Name: candidatura candidatura_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.candidatura
    ADD CONSTRAINT candidatura_pkey PRIMARY KEY (cpf, id_vaga);


--
-- TOC entry 3282 (class 2606 OID 16864)
-- Name: curso curso_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.curso
    ADD CONSTRAINT curso_pkey PRIMARY KEY (id);


--
-- TOC entry 3280 (class 2606 OID 16857)
-- Name: departamento departamento_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departamento
    ADD CONSTRAINT departamento_pkey PRIMARY KEY (id);


--
-- TOC entry 3290 (class 2606 OID 16911)
-- Name: empresa empresa_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.empresa
    ADD CONSTRAINT empresa_email_key UNIQUE (email);


--
-- TOC entry 3292 (class 2606 OID 16909)
-- Name: empresa empresa_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.empresa
    ADD CONSTRAINT empresa_pkey PRIMARY KEY (cnpj);


--
-- TOC entry 3276 (class 2606 OID 16850)
-- Name: pessoa pessoa_matricula_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pessoa
    ADD CONSTRAINT pessoa_matricula_key UNIQUE (matricula);


--
-- TOC entry 3278 (class 2606 OID 16848)
-- Name: pessoa pessoa_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pessoa
    ADD CONSTRAINT pessoa_pkey PRIMARY KEY (cpf);


--
-- TOC entry 3286 (class 2606 OID 16884)
-- Name: professor professor_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.professor
    ADD CONSTRAINT professor_pkey PRIMARY KEY (cpf);


--
-- TOC entry 3294 (class 2606 OID 16916)
-- Name: telefone_empresarial telefone_empresarial_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.telefone_empresarial
    ADD CONSTRAINT telefone_empresarial_pkey PRIMARY KEY (cnpj, numero);


--
-- TOC entry 3288 (class 2606 OID 16899)
-- Name: telefone_pessoal telefone_pessoal_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.telefone_pessoal
    ADD CONSTRAINT telefone_pessoal_pkey PRIMARY KEY (cpf, numero);


--
-- TOC entry 3296 (class 2606 OID 16928)
-- Name: tipo tipo_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tipo
    ADD CONSTRAINT tipo_pkey PRIMARY KEY (id);


--
-- TOC entry 3298 (class 2606 OID 16935)
-- Name: vaga vaga_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vaga
    ADD CONSTRAINT vaga_pkey PRIMARY KEY (id);


--
-- TOC entry 3308 (class 2606 OID 16875)
-- Name: aluno aluno_cpf_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.aluno
    ADD CONSTRAINT aluno_cpf_fkey FOREIGN KEY (cpf) REFERENCES public.pessoa(cpf) ON DELETE CASCADE;


--
-- TOC entry 3307 (class 2606 OID 16870)
-- Name: aluno aluno_id_curso_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.aluno
    ADD CONSTRAINT aluno_id_curso_fkey FOREIGN KEY (id_curso) REFERENCES public.curso(id) ON DELETE RESTRICT;


--
-- TOC entry 3318 (class 2606 OID 16978)
-- Name: aluno_interesse aluno_interesse_cpf_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.aluno_interesse
    ADD CONSTRAINT aluno_interesse_cpf_fkey FOREIGN KEY (cpf) REFERENCES public.aluno(cpf) ON DELETE CASCADE;


--
-- TOC entry 3319 (class 2606 OID 16983)
-- Name: aluno_interesse aluno_interesse_id_interesse_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.aluno_interesse
    ADD CONSTRAINT aluno_interesse_id_interesse_fkey FOREIGN KEY (id_interesse) REFERENCES public.area_de_interesse(id) ON DELETE CASCADE;


--
-- TOC entry 3317 (class 2606 OID 16968)
-- Name: area_vaga area_vaga_id_interesse_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.area_vaga
    ADD CONSTRAINT area_vaga_id_interesse_fkey FOREIGN KEY (id_interesse) REFERENCES public.area_de_interesse(id) ON DELETE CASCADE;


--
-- TOC entry 3316 (class 2606 OID 16963)
-- Name: area_vaga area_vaga_id_vaga_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.area_vaga
    ADD CONSTRAINT area_vaga_id_vaga_fkey FOREIGN KEY (id_vaga) REFERENCES public.vaga(id) ON DELETE CASCADE;


--
-- TOC entry 3320 (class 2606 OID 16995)
-- Name: candidatura candidatura_cpf_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.candidatura
    ADD CONSTRAINT candidatura_cpf_fkey FOREIGN KEY (cpf) REFERENCES public.aluno(cpf) ON DELETE CASCADE;


--
-- TOC entry 3321 (class 2606 OID 17000)
-- Name: candidatura candidatura_id_vaga_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.candidatura
    ADD CONSTRAINT candidatura_id_vaga_fkey FOREIGN KEY (id_vaga) REFERENCES public.vaga(id) ON DELETE CASCADE;


--
-- TOC entry 3309 (class 2606 OID 16885)
-- Name: professor professor_cpf_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.professor
    ADD CONSTRAINT professor_cpf_fkey FOREIGN KEY (cpf) REFERENCES public.pessoa(cpf) ON DELETE CASCADE;


--
-- TOC entry 3310 (class 2606 OID 16890)
-- Name: professor professor_id_departamento_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.professor
    ADD CONSTRAINT professor_id_departamento_fkey FOREIGN KEY (id_departamento) REFERENCES public.departamento(id) ON DELETE RESTRICT;


--
-- TOC entry 3312 (class 2606 OID 16917)
-- Name: telefone_empresarial telefone_empresarial_cnpj_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.telefone_empresarial
    ADD CONSTRAINT telefone_empresarial_cnpj_fkey FOREIGN KEY (cnpj) REFERENCES public.empresa(cnpj) ON DELETE CASCADE;


--
-- TOC entry 3311 (class 2606 OID 16900)
-- Name: telefone_pessoal telefone_pessoal_cpf_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.telefone_pessoal
    ADD CONSTRAINT telefone_pessoal_cpf_fkey FOREIGN KEY (cpf) REFERENCES public.pessoa(cpf) ON DELETE CASCADE;


--
-- TOC entry 3313 (class 2606 OID 16936)
-- Name: vaga vaga_cnpj_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vaga
    ADD CONSTRAINT vaga_cnpj_fkey FOREIGN KEY (cnpj) REFERENCES public.empresa(cnpj) ON DELETE CASCADE;


--
-- TOC entry 3314 (class 2606 OID 16941)
-- Name: vaga vaga_cpf_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vaga
    ADD CONSTRAINT vaga_cpf_fkey FOREIGN KEY (cpf) REFERENCES public.professor(cpf) ON DELETE CASCADE;


--
-- TOC entry 3315 (class 2606 OID 16946)
-- Name: vaga vaga_id_tipo_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vaga
    ADD CONSTRAINT vaga_id_tipo_fkey FOREIGN KEY (id_tipo) REFERENCES public.tipo(id) ON DELETE RESTRICT;


-- Completed on 2025-07-08 09:10:00 -03

--
-- PostgreSQL database dump complete
--

