                    /*       ÍNDICES         */
SET SCHEMA 'sgpcdatabase';

CREATE INDEX id_patrimonio_idx ON patrimonio USING
btree (id);           
               
CREATE INDEX tombamento_patrimonio_idx ON patrimonio USING
HASH (tombamento);

CREATE INDEX id_historico_patrimonio_idx ON historico_patrimonio USING
btree (id);

CREATE INDEX patrimonio_historico_patrimonio ON historico_patrimonio USING
btree (patrimonio);

CREATE INDEX data_chegada_historico_patrimonio ON historico_patrimonio USING
btree (data_chegada);

CREATE INDEX nome_usuario ON usuario USING
HASH (nome);

CREATE INDEX id_manejo ON manejo USING
btree (id);

CREATE INDEX id_chamado_idx ON chamado USING 
btree (id);

CREATE INDEX id_chamado_comentario_idx ON chamado_comentario USING
btree (id);

CREATE INDEX id_chamado_historico_idx ON chamado_historico USING
btree (id);

/*
 * 
 *	CREATE INDEX bolsista_manejo ON manejo USING
 *	HASH (bolsista);
 *
 */

CREATE INDEX patrimonio_manejo ON manejo USING
HASH (patrimonio);

CREATE INDEX data_manejo ON manejo USING
btree (data_manejo);

CREATE INDEX bolsista_responsabilidade ON responsabilidade USING
HASH (bolsista);


CREATE INDEX predio_responsabilidade ON responsabilidade USING
HASH (predio);

           /*  FUNÇÕES E TRIGGGERS */

        /* FUNÇÃO PARA INSERIR O USUÁRIO DO TIPO BOLSISTA */
CREATE OR REPLACE FUNCTION inserir_bolsista(
                                            v_matricula         VARCHAR(12),
                                            v_login             VARCHAR(25),
                                            v_senha             VARCHAR(80),
                                            v_nome  	        VARCHAR(100),
                                            v_email       	    VARCHAR(50),
                                            v_telefone    	    VARCHAR(12),
	                                        v_ativo			    BOOLEAN,
	                                        v_nivel_acesso	    SMALLINT,
                                            v_tipo_bolsista     SMALLINT,
	                                        v_data_chegada	    DATE)

RETURNS VOID AS $$
DECLARE
    v_id	INTEGER;
    v_tipo_usuario INTEGER := 1;
BEGIN
    INSERT INTO usuario (login, senha, nome, email, telefone, ativo, tipo_usuario, nivel_acesso, data_chegada)
   	VALUES (v_login, v_senha, v_nome, v_email, v_telefone, v_ativo,v_tipo_usuario, v_nivel_acesso, v_data_chegada) RETURNING id INTO v_id;

    INSERT INTO bolsista (matricula, id, tipo_bolsista)
    VALUES (v_matricula, v_id, v_tipo_bolsista);

END;
$$ LANGUAGE plpgsql;

        /* FUNÇÃO PARA INSERIR O USUÁRIO DO TIPO SUPERVISOR */
CREATE OR REPLACE FUNCTION inserir_supervisor(  v_login             VARCHAR(25),
                                                v_senha             VARCHAR(80),
                                                v_nome  	        VARCHAR(100),
                                                v_email       	    VARCHAR(50),
                                                v_telefone    	    VARCHAR(12),
	                                            v_ativo			    BOOLEAN,
	                                            v_nivel_acesso	    SMALLINT,
                                                v_tipo_supervisor   SMALLINT,
	                                            v_data_chegada	    DATE)

RETURNS VOID AS $$
DECLARE
    v_id	INTEGER;
    v_tipo_usuario INTEGER := 2;
BEGIN
    INSERT INTO usuario (login, senha, nome, email, telefone, ativo, tipo_usuario, nivel_acesso, data_chegada)
   	VALUES (v_login, v_senha, v_nome, v_email, v_telefone,v_ativo, v_tipo_usuario,v_nivel_acesso, v_data_chegada) RETURNING id INTO v_id;

    INSERT INTO supervisor (id, tipo_supervisor)
    VALUES (v_id, v_tipo_supervisor);

END;
$$ LANGUAGE plpgsql;



			/* FUNÇÃO PARA INSERÇÃO DE PC*/
CREATE OR REPLACE FUNCTION inserir_pc(v_tombamento 	VARCHAR(12),
                                      v_descricao 	VARCHAR(50),
                                      v_estado 		VARCHAR(30),
                                      v_localidade 	SMALLINT,
                                      v_alienado	BOOLEAN,
                                      v_serialpc 	VARCHAR,
                                      v_modelo 		SMALLINT,
                                      v_os 			SMALLINT,
                                      v_ram 		SMALLINT,
                                      v_ram_ddr 	SMALLINT,
                                      v_hd 			SMALLINT)
RETURNS VOID AS $$
DECLARE
    v_tipo	SMALLINT  := 2205;
	v_id	INTEGER;
BEGIN 
	INSERT INTO patrimonio (tombamento,descricao,estado,tipo,localidade,alienado)
   	VALUES (v_tombamento,v_descricao,v_estado,v_tipo,v_localidade,v_alienado) RETURNING id INTO v_id;
 	
	INSERT INTO patrimonio_pc (id,serialpc,modelo,os,ram,ram_ddr,hd)
	VALUES (v_id,v_serialpc,v_modelo,v_os,v_ram,v_ram_ddr,v_hd);
END;
$$ LANGUAGE plpgsql;

			/*				FUNÇÃO PARA FAZER O MANEJO AUTOMÁTICO (TODAS AS OUTRAS TABELAS 
			 * 				SERÃO ATUALIZADAS AUTOMATICAMENTE DE ACORDO COM AS TRIGGERS ANTERIORES)*/

CREATE OR REPLACE FUNCTION manejo (v_patrimonio INT, v_comodo SMALLINT, v_bolsista VARCHAR(12))
RETURNS VOID AS $$
DECLARE
	v_comodo_anterior SMALLINT;
BEGIN
	
	SELECT localidade FROM patrimonio WHERE id = v_patrimonio INTO v_comodo_anterior;
	
	INSERT INTO manejo (patrimonio,bolsista,comodo_anterior,comodo_posterior) 
	VALUES (v_patrimonio,v_bolsista,v_comodo_anterior,v_comodo); 
END;
$$ LANGUAGE plpgsql;


            /*      FUNÇÃO PARA TRIGGER DO MANJEMENTO DE PATRIMÔNIO     */

CREATE OR REPLACE FUNCTION manejo_patrimonio()
RETURNS TRIGGER AS $$
DECLARE
BEGIN	
    INSERT INTO historico_patrimonio (patrimonio,comodo,bolsista,data_chegada)
    VALUES (NEW.patrimonio,NEW.comodo_posterior,NEW.bolsista,NEW.data_manejo);
    
   	UPDATE patrimonio SET localidade = NEW.comodo_posterior WHERE id = NEW.patrimonio;
   
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

            /*      FUNÇÃO PARA TRIGGER PARA DATA DE SAÍDA DO MANJEMENTO DE PATRIMÔNIO     */

CREATE OR REPLACE FUNCTION update_data_saida_manejo()
RETURNS TRIGGER AS $$
DECLARE
	v_id INT;
BEGIN 
	SELECT id FROM historico_patrimonio WHERE patrimonio = NEW.patrimonio AND data_saida IS NULL INTO v_id;
	IF v_id > 0 THEN
		UPDATE historico_patrimonio SET data_saida = NEW.data_chegada WHERE id = v_id;
	ELSE
		
	END IF;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER t_update_data_saida_manejo
BEFORE INSERT ON historico_patrimonio
FOR EACH ROW 
EXECUTE PROCEDURE update_data_saida_manejo();


						/* FUNÇÃO PARA INSERÇÃO DE PATRIMONIOS NO HISTÓRICO PELA PRIMEIRA VEZ*/
CREATE OR REPLACE FUNCTION inserir_no_historico()
RETURNS TRIGGER AS $$
DECLARE 
BEGIN
	INSERT INTO historico_patrimonio (patrimonio,comodo)
	VALUES (NEW.id,NEW.localidade);
END;
$$ LANGUAGE plpgsql;	

bol
CREATE OR REPLACE TRIGGER t_inserir_no_historico
AFTER INSERT ON patrimonio
FOR EACH ROW 
EXECUTE PROCEDURE inserir_no_historico();



            /*      VALIDAÇÃO PARA INSERIR BOLSISTA     */

-- CREATE OR REPLACE FUNCTION inserir_bolsista()
-- RETURNS TRIGGER AS $$
-- BEGIN
--     IF NEW.matricula IS NULL THEN
--         RAISE EXCEPTION 'Matrícula Inválida';
--     END IF;
--     IF NEW.nome IS NULL THEN
--         RAISE EXCEPTION 'Por favor informe um nome';
--     END IF;
--
--     INSERT INTO bolsista (nome,usuario,tipo,ativo) VALUES (NEW.nome,NEW.usuario,NEW.tipo,true);
--
--     RETURN NEW;
-- END;
-- $$ LANGUAGE plpgsql;
--
-- CREATE OR REPLACE TRIGGER t_inserir_bolsista
-- AFTER INSERT ON bolsista
-- FOR EACH ROW
-- EXECUTE PROCEDURE inserir_bolsista();

CREATE OR REPLACE FUNCTION inserir_patrimonio()
RETURNS TRIGGER AS $$
DECLARE
 v_tipo_MIN SMALLINT;
 v_tipo_MAX SMALLINT;
BEGIN
    SELECT MIN(id) FROM tipo_patrimonio INTO v_tipo_MIN;
    SELECT MAX(id) FROM tipo_patrimonio INTO v_tipo_MAX;
    IF NEW.descricao IS NULL THEN
        RAISE EXCEPTION 'Digite uma descricao para o bem';
    END IF;
    IF NEW.estado IS NULL THEN
        RAISE EXCEPTION 'Por favor informe o estado do bem';
    END IF;
    IF (NEW.tipo < v_tipo_MIN OR NEW.tipo > v_tipo_MAX) OR NEW.tipo is NULL THEN
        RAISE EXCEPTION 'Por favor informe um tipo que exista';
    END IF;

   	NEW.alienado = false;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER t_inserir_patrimonio
BEFORE INSERT ON patrimonio
FOR EACH ROW
EXECUTE PROCEDURE inserir_patrimonio();

            /* VIEWS E MATERIALIZED VIEWS */
            /*  VIEW PARA TODOS OS PATRIMÔNIOS NO GERAL */


CREATE OR REPLACE VIEW patrimonios_completo AS
SELECT pa.id AS id, pa.tombamento AS tombamento, pa.descricao AS descricao, ep.descricao AS estado,
tp.descricao AS tipo, co.nome AS comodo, an.nome AS andar, pr.nome AS predio, 
com.nome AS complexo

FROM patrimonio AS pa
INNER JOIN estado_patrimonio AS ep ON pa.estado = ep.id
INNER JOIN tipo_patrimonio AS tp ON pa.tipo = tp.id
INNER JOIN comodo AS co ON pa.localidade = co.id
INNER JOIN andar AS an ON co.andar = an.id
INNER JOIN predio AS pr ON an.predio = pr.id
INNER JOIN complexo AS com ON pr.complexo = com.id;

/*      VIEW PARA OS PATRIMÔNIOS QUE ESTÃO NO CAMPUS I    */

CREATE OR REPLACE VIEW patrimonios_campus_1 AS
SELECT pa.tombamento AS tombamento, pa.descricao AS descricao, pa.estado AS estado,  
tp.descricao AS tipo, co.nome AS comodo, an.nome AS andar, pr.nome AS predio, 
com.nome AS complexo
FROM patrimonio AS pa 
INNER JOIN tipo_patrimonio AS tp ON pa.tipo = tp.id
INNER JOIN comodo AS co ON pa.localidade = co.id
INNER JOIN andar AS an ON co.andar = an.id
INNER JOIN predio AS pr ON an.predio = pr.id
INNER JOIN complexo AS com ON pr.complexo = com.id 
WHERE pr.id = 1;

    /*      VIEW PARA OS PATRIMÔNIOS QUE ESTÃO NO CAMPUS II    */

CREATE OR REPLACE VIEW patrimonios_campus_2 AS
SELECT pa.tombamento AS tombamento, pa.descricao AS descricao, pa.estado AS estado,  
tp.descricao AS tipo, co.nome AS comodo, an.nome AS andar, pr.nome AS predio, 
com.nome AS complexo
FROM patrimonio AS pa 
INNER JOIN tipo_patrimonio AS tp ON pa.tipo = tp.id
INNER JOIN comodo AS co ON pa.localidade = co.id
INNER JOIN andar AS an ON co.andar = an.id
INNER JOIN predio AS pr ON an.predio = pr.id
INNER JOIN complexo AS com ON pr.complexo = com.id 
WHERE pr.id = 2;

    /*      VIEW PARA OS PATRIMÔNIOS QUE ESTÃO NO CAMPUS III    */

CREATE OR REPLACE VIEW patrimonios_campus_3 AS
SELECT pa.tombamento AS tombamento, pa.descricao AS descricao, pa.estado AS estado,  
tp.descricao AS tipo, co.nome AS comodo, an.nome AS andar, pr.nome AS predio, 
com.nome AS complexo
FROM patrimonio AS pa 
INNER JOIN tipo_patrimonio AS tp ON pa.tipo = tp.id
INNER JOIN comodo AS co ON pa.localidade = co.id
INNER JOIN andar AS an ON co.andar = an.id
INNER JOIN predio AS pr ON an.predio = pr.id
INNER JOIN complexo AS com ON pr.complexo = com.id 
WHERE pr.id = 3;

    /*      VIEW PARA OS PATRIMÔNIOS QUE ESTÃO NO CAMPUS IV    */

CREATE OR REPLACE VIEW patrimonios_campus_4 AS
SELECT pa.tombamento AS tombamento, pa.descricao AS descricao, pa.estado AS estado,  
tp.descricao AS tipo, co.nome AS comodo, an.nome AS andar, pr.nome AS predio, 
com.nome AS complexo
FROM patrimonio AS pa 
INNER JOIN tipo_patrimonio AS tp ON pa.tipo = tp.id
INNER JOIN comodo AS co ON pa.localidade = co.id
INNER JOIN andar AS an ON co.andar = an.id
INNER JOIN predio AS pr ON an.predio = pr.id
INNER JOIN complexo AS com ON pr.complexo = com.id 
WHERE pr.id = 4;

    /*      VIEW PARA OS PATRIMÔNIOS QUE ESTÃO NA BIOMÉDICA    */

CREATE OR REPLACE VIEW patrimonios_biomedica AS
SELECT pa.tombamento AS tombamento, pa.descricao AS descricao, pa.estado AS estado,  
tp.descricao AS tipo, co.nome AS comodo, an.nome AS andar, pr.nome AS predio, 
com.nome AS complexo
FROM patrimonio AS pa 
INNER JOIN tipo_patrimonio AS tp ON pa.tipo = tp.id
INNER JOIN comodo AS co ON pa.localidade = co.id
INNER JOIN andar AS an ON co.andar = an.id
INNER JOIN predio AS pr ON an.predio = pr.id
INNER JOIN complexo AS com ON pr.complexo = com.id 
WHERE pr.id = 5;

    /*      VIEW PARA OS PATRIMÔNIOS QUE ESTÃO NA PÓS-GRADUAÇÃO/POUSO    */

CREATE OR REPLACE VIEW patrimonios_pouso AS
SELECT pa.tombamento AS tombamento, pa.descricao AS descricao, pa.estado AS estado,  
tp.descricao AS tipo, co.nome AS comodo, an.nome AS andar, pr.nome AS predio, 
com.nome AS complexo
FROM patrimonio AS pa 
INNER JOIN tipo_patrimonio AS tp ON pa.tipo = tp.id
INNER JOIN comodo AS co ON pa.localidade = co.id
INNER JOIN andar AS an ON co.andar = an.id
INNER JOIN predio AS pr ON an.predio = pr.id
INNER JOIN complexo AS com ON pr.complexo = com.id 
WHERE pr.id = 6;

    /*      VIEW PARA OS PATRIMÔNIOS QUE ESTÃO NA PRAÇA CÍVICA    */

CREATE OR REPLACE VIEW patrimonios_praca_civica AS
SELECT pa.tombamento AS tombamento, pa.descricao AS descricao, pa.estado AS estado,  
tp.descricao AS tipo, co.nome AS comodo, an.nome AS andar, pr.nome AS predio, 
com.nome AS complexo
FROM patrimonio AS pa 
INNER JOIN tipo_patrimonio AS tp ON pa.tipo = tp.id
INNER JOIN comodo AS co ON pa.localidade = co.id
INNER JOIN andar AS an ON co.andar = an.id
INNER JOIN predio AS pr ON an.predio = pr.id
INNER JOIN complexo AS com ON pr.complexo = com.id 
WHERE pr.id = 7;

    /*      VIEW PARA OS PATRIMÔNIOS QUE ESTÃO NA MIPIBU    */

CREATE OR REPLACE VIEW patrimonios_mipibu AS
SELECT pa.tombamento AS tombamento, pa.descricao AS descricao, pa.estado AS estado,  
tp.descricao AS tipo, co.nome AS comodo, an.nome AS andar, pr.nome AS predio, 
com.nome AS complexo
FROM patrimonio AS pa 
INNER JOIN tipo_patrimonio AS tp ON pa.tipo = tp.id
INNER JOIN comodo AS co ON pa.localidade = co.id
INNER JOIN andar AS an ON co.andar = an.id
INNER JOIN predio AS pr ON an.predio = pr.id
INNER JOIN complexo AS com ON pr.complexo = com.id 
WHERE pr.id = 8;

    /*      VIEW PARA OS PATRIMÔNIOS QUE ESTÃO NA PROAE    */

CREATE OR REPLACE VIEW patrimonios_proae AS
SELECT pa.tombamento AS tombamento, pa.descricao AS descricao, pa.estado AS estado,  
tp.descricao AS tipo, co.nome AS comodo, an.nome AS andar, pr.nome AS predio, 
com.nome AS complexo
FROM patrimonio AS pa 
INNER JOIN tipo_patrimonio AS tp ON pa.tipo = tp.id
INNER JOIN comodo AS co ON pa.localidade = co.id
INNER JOIN andar AS an ON co.andar = an.id
INNER JOIN predio AS pr ON an.predio = pr.id
INNER JOIN complexo AS com ON pr.complexo = com.id 
WHERE pr.id = 9;

    /*      VIEW PARA OS PATRIMÔNIOS QUE ESTÃO EM SANTA CRUZ    */

CREATE OR REPLACE VIEW patrimonios_santa_cruz AS
SELECT pa.tombamento AS tombamento, pa.descricao AS descricao, pa.estado AS estado,  
tp.descricao AS tipo, co.nome AS comodo, an.nome AS andar, pr.nome AS predio, 
com.nome AS complexo
FROM patrimonio AS pa 
INNER JOIN tipo_patrimonio AS tp ON pa.tipo = tp.id
INNER JOIN comodo AS co ON pa.localidade = co.id
INNER JOIN andar AS an ON co.andar = an.id
INNER JOIN predio AS pr ON an.predio = pr.id
INNER JOIN complexo AS com ON pr.complexo = com.id 
WHERE pr.id = 10;

    /*      VIEW PARA OS PATRIMÔNIOS QUE ESTÃO EM MOSSORÓ    */

CREATE OR REPLACE VIEW patrimonios_mossoro AS
SELECT pa.tombamento AS tombamento, pa.descricao AS descricao, pa.estado AS estado,  
tp.descricao AS tipo, co.nome AS comodo, an.nome AS andar, pr.nome AS predio, 
com.nome AS complexo
FROM patrimonio AS pa 
INNER JOIN tipo_patrimonio AS tp ON pa.tipo = tp.id
INNER JOIN comodo AS co ON pa.localidade = co.id
INNER JOIN andar AS an ON co.andar = an.id
INNER JOIN predio AS pr ON an.predio = pr.id
INNER JOIN complexo AS com ON pr.complexo = com.id 
WHERE pr.id = 11;

    /*      VIEW PARA OS PATRIMÔNIOS QUE ESTÃO EM CAICÓ    */

CREATE OR REPLACE VIEW patrimonios_caico AS
SELECT pa.tombamento AS tombamento, pa.descricao AS descricao, pa.estado AS estado,  
tp.descricao AS tipo, co.nome AS comodo, an.nome AS andar, pr.nome AS predio, 
com.nome AS complexo
FROM patrimonio AS pa 
INNER JOIN tipo_patrimonio AS tp ON pa.tipo = tp.id
INNER JOIN comodo AS co ON pa.localidade = co.id
INNER JOIN andar AS an ON co.andar = an.id
INNER JOIN predio AS pr ON an.predio = pr.id
INNER JOIN complexo AS com ON pr.complexo = com.id 
WHERE pr.id = 12;

            /*      VIEWS PARA MOSTRAR APENAS COMPUTADORES COMPUTADORES  E SUAS INFORMAÇẼOS  */
CREATE OR REPLACE VIEW patrimonios_computadores AS
SELECT pa.tombamento AS tombamento, pa.descricao AS descricao, pa.estado AS estado, 
pap.serialpc AS serialpc, mop.modelo AS modelo, osp.nome AS os, rap.ram AS ram, 
rad.ddr AS ram_ddr, hdp.hd AS hd, co.nome AS comodo, 
an.nome AS andar, pr.nome AS predio, com.nome AS complexo
FROM patrimonio AS pa 
INNER JOIN comodo           AS co  ON pa.localidade = co.id
INNER JOIN andar            AS an  ON co.andar      = an.id
INNER JOIN predio           AS pr  ON an.predio     = pr.id
INNER JOIN complexo         AS com ON pr.complexo   = com.id
INNER JOIN patrimonio_pc    AS pap ON pa.id         = pap.id
INNER JOIN modelo_pc        AS mop ON pap.modelo    = mop.id
INNER JOIN os_pc            AS osp ON pap.os        = osp.id
INNER JOIN ram_pc           AS rap ON pap.ram       = rap.id
INNER JOIN ram_ddr_pc       AS rad ON pap.ram_ddr   = rad.id
INNER JOIN hd_pc            AS hdp ON pap.hd        = hdp.id
WHERE pa.tipo = 2205;



SELECT pa.tombamento AS tombamento, pa.descricao AS descricao, 
pa.estado AS estado,pap.serialpc AS serialpc
FROM patrimonio AS pa
INNER JOIN patrimonio_pc    AS pop ON pa
INNER JOIN comodo           AS co  ON pa.localidade = co.id
INNER JOIN andar            AS an  ON co.andar      = an.id

WHERE pa.tipo = 2205;

            /*      VIEWS PARA MOSTRAR A QUANTIDADE DE COMPUTADORES POR PREDIO */
CREATE OR REPLACE VIEW computadores_por_piso AS
SELECT pr.nome AS predio, COUNT(pa.id) AS quantidade FROM patrimonio AS pa
INNER JOIN comodo AS co ON pa.localidade = co.id
INNER JOIN andar AS an ON co.andar = an.id
INNER JOIN predio AS pr ON an.predio = pr.id
WHERE pa.tipo = 2205
GROUP BY pr.id
ORDER BY COUNT(pa.id) DESC;

            /*      VIEWS PARA MOSTRAR TODOS OS BOLSISTAS   (QUE ESTÃO ATIVOS E INATIVOS)*/
 
CREATE OR REPLACE VIEW bolsistas_completo AS
SELECT bo.matricula AS matricula, bo.nome AS nome, bo.usuario AS usuario, tb.descricao AS tipo,
CAST(CASE
    WHEN bo.ativo ='true' THEN 'Ativo' 
    ELSE 'Inativo' END 
    AS VARCHAR(7))
FROM bolsista AS bo
INNER JOIN tipo_bolsista AS tb 
    ON bo.tipo = tb.id;
ALTER VIEW bolsistas_completo RENAME COLUMN varchar to status;

        /*      AGRUPANDO QUANTIDADES DE BOLSISTA POR AREA  */
        
CREATE OR REPLACE VIEW bolsista_area AS
SELECT bf.tipo, COUNT(bf.tipo) AS quantidade FROM bolsistas_completo AS bf
GROUP BY bf.tipo
ORDER BY COUNT(bf.tipo) DESC;

            /*      BOLSISTAS ATIVOS    */

CREATE OR REPLACE VIEW bolsistas_ativos AS
SELECT bo.matricula AS matricula, bo.nome AS nome, bo.usuario AS usuario,
us.telEfone AS telefone, us.email AS email, tb.descricao AS tipo
FROM bolsista AS bo
INNER JOIN tipo_bolsista    AS tb ON bo.tipo = tb.id AND bo.ativo = 'true'
INNER JOIN usuario          AS us ON bo.matricula = us.matricula;

/*   VIEW PARA MOSTRAR OS BOLSISTAS QUE SÃO RESPONSÁVEIS POR SUAS ESPECÍFICAS RESIDÊNCIAS    */

CREATE MATERIALIZED VIEW bolsistas_gerencia AS
SELECT bo.matricula AS matricula, bo.nome AS nome, pr.nome AS predio
FROM bolsista AS bo
INNER JOIN responsabilidade AS re ON bo.matricula = re.bolsista
INNER JOIN predio AS pr ON re.predio = pr.id;

    /*  VIEW PARA MOSTRAR O HISTÓRICO DOS PATRIMÔNIOS (POR ONDE PASSARAM, QUEM MANEJOU, QUANDO MANEJOU)*/

CREATE OR REPLACE VIEW hpc_ AS
SELECT pa.tombamento AS tombamento, co.nome AS localidade, an.nome AS andar, pr.nome AS predio,
bo.nome AS bolsista, hp.data_chegada AS data_chegada,
CAST(hp.data_saida 
    AS VARCHAR(15))
FROM historico_patrimonio   AS hp
INNER JOIN bolsista         AS bo ON hp.bolsista    = bo.matricula
INNER JOIN patrimonio       AS pa ON hp.patrimonio  = pa.id
INNER JOIN comodo           AS co ON hp.comodo      = co.id
INNER JOIN andar            AS an ON co.andar       = an.id
INNER JOIN predio           AS pr ON an.predio      = pr.id;

CREATE OR REPLACE VIEW historico_patrimonios_completo AS
SELECT tombamento, localidade, andar, predio, bolsista, data_chegada,
CAST(CASE
    WHEN data_saida = '0001-01-01' THEN 'Na localidade'
    ELSE data_saida END
    AS VARCHAR(15))
FROM hpc_ ORDER BY data_chegada DESC;

            /*      VIEW PARA MOSTRAR O MANEJO EM SI    */
            
CREATE OR REPLACE VIEW manejo_patrimonio AS            
SELECT pa.tombamento AS tombamento, pa.descricao AS descricao, bo.nome AS bolsista, 
co.nome AS comodo_anterior, co.nome AS comodo_posterior, an.nome AS andar, pr.nome AS predio,
ma.data_manejo AS data_manejo
FROM manejo   AS ma
INNER JOIN bolsista         AS bo ON ma.bolsista        = bo.matricula
INNER JOIN patrimonio       AS pa ON ma.patrimonio      = pa.id
INNER JOIN comodo           AS co ON ma.comodo_anterior = co.id
INNER JOIN andar            AS an ON co.andar           = an.id
INNER JOIN predio           AS pr ON an.predio          = pr.id;  

/*SELECT bf.tipo, COUNT(bf.tipo) AS quantidade FROM bolsistas_completo AS bf
GROUP BY bf.tipo
ORDER BY COUNT(bf.tipo) DESC;
*/
