SET SCHEMA 'sgpcdatabase';

CREATE OR REPLACE VIEW bolsistas AS
SELECT u.id AS id, b.matricula as matricula, u.login AS login, u.nome AS nome, u.email AS email, u.telefone AS telefone, u.ativo AS status,
       tb.descricao AS tipo_bolsista, u.data_chegada AS data_chegada, u.data_saida AS data_saida
FROM bolsista AS b
INNER JOIN  usuario AS u
    ON b.id = u.id
INNER JOIN tipo_bolsista AS tb
    ON b.tipo_bolsista = tb.id;

CREATE OR REPLACE VIEW bolsistas_completo AS
SELECT bo.id as id, bo.matricula AS matricula, u.login AS login,u.nome AS nome, u.email as email, u.telefone as telefone, tb.descricao AS tipo,
CAST(CASE
    WHEN u.ativo ='true' THEN 'Ativo'
    ELSE 'Inativo' END
    AS VARCHAR(7)),
u.data_chegada as data_chegada, u.data_saida as data_saida
FROM bolsista AS bo
INNER JOIN usuario AS u ON bo.id = u.id
INNER JOIN tipo_bolsista AS tb
    ON bo.tipo_bolsista = tb.id;
ALTER VIEW bolsistas_completo RENAME COLUMN varchar to status;

            /*  VIEW PARA TODOS OS PATRIMÔNIOS NO GERAL */

CREATE OR REPLACE VIEW patrimonios_completo AS
SELECT pa.id AS id, pa.tombamento AS tombamento, pa.descricao AS descricao, ep.descricao AS estado,
       tp.descricao AS tipo, pa.alienado AS alienado ,co.nome AS comodo, an.nome AS andar, pr.nome AS predio,
com.nome AS complexo
FROM patrimonio AS pa

INNER JOIN estado_patrimonio AS ep ON pa.estado = ep.id
INNER JOIN tipo_patrimonio AS tp ON pa.tipo = tp.id
INNER JOIN comodo AS co ON pa.localidade = co.id
INNER JOIN andar AS an ON co.andar = an.id
INNER JOIN predio AS pr ON an.predio = pr.id
INNER JOIN complexo AS com ON pr.complexo = com.id;

CREATE OR REPLACE VIEW computadores_completo AS
SELECT ppc.id AS id, psc.tombamento AS tombamento, ppc.serialpc AS serial, mo.descricao AS modelo, os.descricao AS os,
       ram.descricao AS ram, ram_ddr.descricao AS ddr, hd.descricao AS hd, psc.descricao AS descricao, psc.estado AS estado,
       psc.alienado AS alienado, psc.comodo AS comodo, psc.andar AS andar, psc.predio AS predio, psc.complexo AS complexo
FROM patrimonio_pc AS ppc

INNER JOIN patrimonios_completo AS psc ON ppc.id = psc.id
INNER JOIN modelo_pc AS mo ON ppc.modelo = mo.id
INNER JOIN os_pc AS os ON ppc.os = os.id
INNER JOIN ram_pc AS ram ON ppc.ram = ram.id
INNER JOIN ram_ddr_pc ram_ddr ON ppc.ram_ddr = ram_ddr.id
INNER JOIN hd_pc AS hd ON ppc.hd = hd.id;

            /*  VIEW PARA TODOS OS PATRIMÔNIOS NO GERAL */
CREATE OR REPLACE VIEW manejos_completo AS
SELECT ma.id AS id, p.tombamento AS tombamento, tp.descricao AS tipo, ma.data_manejo AS data, u.nome AS nome,
com.nome AS complexo_anterior, pr.nome AS predio_anterior, an.nome AS andar_anterior, co.nome AS comodo_anterior,
com2.nome AS complexo_posterior, pr2.nome AS predio_posterior, an2.nome AS andar_posterior, co2.nome AS comodo_posterior

FROM manejo AS ma
INNER JOIN patrimonio AS p on ma.patrimonio = p.id
    INNER JOIN tipo_patrimonio AS tp ON p.tipo = tp.id
INNER JOIN usuario AS U ON ma.usuario = u.id
INNER JOIN comodo AS co ON ma.comodo_anterior = co.id
INNER JOIN andar AS an ON co.andar = an.id
INNER JOIN predio AS pr ON an.predio = pr.id
INNER JOIN complexo AS com ON pr.complexo = com.id

INNER JOIN comodo AS co2 ON ma.comodo_posterior = co2.id
INNER JOIN andar AS an2 ON co2.andar = an2.id
INNER JOIN predio AS pr2 ON an2.predio = pr2.id
INNER JOIN complexo AS com2 ON pr2.complexo = com2.id;

CREATE OR REPLACE VIEW alienamentos_completo AS
SELECT al.id AS id, p.tombamento AS tombamento, tp.descricao AS tipo, u.nome AS nome,al.data_alienamento AS data

FROM alienamento AS al
INNER JOIN patrimonio AS p on al.patrimonio = p.id
    INNER JOIN tipo_patrimonio AS tp ON p.tipo = tp.id
INNER JOIN usuario AS u ON al.usuario = u.id;

CREATE OR REPLACE VIEW chamados_completo AS
SELECT ch.id AS id, ch.titulo AS titulo, ch.descricao AS descricao, ec.descricao AS estado, tp.descricao AS tipo,
       u1.nome AS criador, u2.nome AS fechador,
       ch.data_abertura AS data_abertura, ch.data_fechamento AS data_fechamento,
       com.nome AS complexo, pr.nome AS predio, an.nome AS andar, co.nome AS comodo

FROM chamado AS ch
INNER JOIN estado_chamado AS ec ON ch.estado = ec.id
INNER JOIN tipo_chamado AS tp ON ch.tipo = tp.id
INNER JOIN usuario AS u1 ON ch.criador = u1.id
LEFT JOIN usuario AS u2 ON ch.fechador = u2.id
INNER JOIN comodo AS co ON ch.localidade = co.id
INNER JOIN andar AS an ON co.andar = an.id
INNER JOIN predio AS pr ON an.predio = pr.id
INNER JOIN complexo AS com ON pr.complexo = com.id;

