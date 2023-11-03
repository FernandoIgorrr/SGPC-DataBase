SET SCHEMA 'sgpcdatabase';

CREATE OR REPLACE VIEW bolsistas AS
SELECT u.id AS id, b.matricula as matricula, u.login AS login, u.nome AS nome, u.email AS email, u.telefone AS telefone, u.ativo AS status,
       na.descricao AS acesso, tb.descricao AS tipo_bolsista, u.data_chegada AS data_chegada, u.data_saida AS data_saida
FROM bolsista AS b
INNER JOIN  usuario AS u
    ON b.id = u.id
INNER JOIN tipo_bolsista AS tb
    ON b.tipo_bolsista = tb.id
INNER JOIN nivel_acesso AS na
    ON u.nivel_acesso = na.id;
