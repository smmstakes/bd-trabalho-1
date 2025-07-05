CREATE PROCEDURE atualizar_interesses_aluno (cpf_aluno CHAR(11), aluno_novos_interesses INTEGER[])
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
