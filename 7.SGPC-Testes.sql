SET SCHEMA 'sgpcdatabase';

select inserir_pc('201501422','asdasd','asdasdads','1',false,'f3122','206','100','16','4','1');
select inserir_pc('201501423','asdasd','asdasdads','1',false,'f3123','206','100','16','4','1');
select inserir_pc('201501424','asdasd','asdasdads','1',false,'f3124','206','100','16','4','1');
select inserir_pc('201501425','asdasd','asdasdads','1',false,'f3125','206','100','16','4','1');

INSERT INTO patrimonio (tombamento,descricao,estado,tipo,localidade,alienado)
VALUES ('201111111','asdasdsa','sadsgfdgh',2202,50,false);

INSERT INTO patrimonio (tombamento,descricao,estado,tipo,localidade,alienado)
VALUES ('201111112','asdasdsa','sadsgfdgh',2202,50,false);

   
INSERT INTO bolsista (usuario,senha,nome,email,telefone,ativo,tipo_usuario,data_chegada,matricula,tipo)
VALUES ('figordantas','12345','Fernando Igor Dantas','FernandoIgor.Dantas@gmail.com','66666666',TRUE,1101,'2023-08-08','20170146005',3303);

select * from tipo_usuario
select * from tipo_bolsista
select * from modelo_pc
select * from tipo_patrimonio tp 

SELECT * FROM comodo;

SELECT * FROM bolsista b   

select * from patrimonio p; 
select * from ONLY patrimonio p; 

select * from patrimonio_pc pp 

SELECT * FROM historico_patrimonio 

SELECT * FROM historico_patrimonio;

SELECT * FROM manejo m;


ANALYZE;

SELECT manejo('1','10','20170146005');

INSERT INTO manejo (patrimonio,bolsista,comodo_anterior,comodo_posterior) 
	VALUES (7,'20170146005',1,2); 

SET SCHEMA 'sgpcdatabase';
