SET SCHEMA 'sgpcdatabase';

/*CREATE OR REPLACE VIEW bolsistas AS
SELECT u.id AS id, b.matricula as matricula, u.login AS login, u.nome AS nome, u.email AS email, u.telefone AS telefone, u.ativo AS status,
       na.descricao AS acesso, tb.descricao AS tipo_bolsista, u.data_chegada AS data_chegada, u.data_saida AS data_saida
FROM bolsista AS b
INNER JOIN  usuario AS u
    ON b.id = u.id
INNER JOIN tipo_bolsista AS tb
    ON b.tipo_bolsista = tb.id
INNER JOIN nivel_acesso AS na
    ON u.nivel_acesso = na.id;*/

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

