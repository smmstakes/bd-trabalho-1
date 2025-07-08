CREATE VIEW MapeamentoRelacaoVagas AS
SELECT 
    ai.id, ai.nome,
    COUNT(DISTINCT v.id) AS vagas,
    COUNT(DISTINCT al_i.cpf) AS alunos,
    CASE 
        WHEN COUNT(DISTINCT v.id) = 0 THEN NULL 
        ELSE ROUND(COUNT(DISTINCT al_i.cpf)::numeric / COUNT(DISTINCT v.ID), 2) 
    END AS relacao,
    ROUND(AVG(v.carga_horaria), 1) AS horas_medias,
    COUNT(DISTINCT v.cnpj) AS empresas,
    COUNT(DISTINCT v.cpf) AS professores
FROM area_de_interesse ai
LEFT JOIN area_vaga av ON ai.id = av.id_interesse
LEFT JOIN vaga v ON av.id_vaga = v.id
LEFT JOIN aluno_interesse al_i ON ai.id = al_i.id_interesse
GROUP BY ai.id, ai.nome
ORDER BY ai.id;
