SET SCHEMA 'sgpcdatabase';

DELETE FROM supervisor where 1=1;
DELETE FROM usuario where 1=1;

select u1_0.id,u1_0.tipo_usuario,u1_0.ativo,u1_0.data_chegada,u1_0.data_saida,u1_0.email,u1_0.login,u1_0.nome,u1_0.senha,u1_0.telefone,u1_1.matricula,u1_1.tipo_bolsista,u1_2.tipo_supervisor from sgpcdatabase.usuario u1_0 left join sgpcdatabase.bolsista u1_1 on u1_0.id=u1_1.id left join sgpcdatabase.supervisor u1_2 on u1_0.id=u1_2.id where u1_0.login='Verinha';


DELETE FROM patrimonio_pc WHERE 1=1;
DELETE FROM patrimonio WHERE 1=1;

select c1_0.id,c1_1.alienado,c1_1.descricao,c1_1.estado,c1_1.localidade,c1_1.tipo,c1_1.tombamento,c1_0.hd,c1_0.modelo,c1_0.ram,c1_0.ram_ddr,c1_0.serialpc,c1_0.os from sgpcdatabase.patrimonio_pc c1_0 join sgpcdatabase.patrimonio c1_1 on c1_0.id=c1_1.id;

select e1_0.id,e1_0.descricao from sgpcdatabase.estado_patrimonio e1_0 where e1_0.id=1

select * from bolsistas;

select inserir_bolsista('20170146005',
                        'F.IgorDantas',
                        '@12345',
                        'Fernando Igor Dantas',
                        'Fernandoigor.dantas@outlook.com',
                        '84997039665',
                        true,
                        '2',
                        '3303',
                        '2017-07-01');

select inserir_bolsista('20200146005',
                        'F.IagoDantas',
                        '@12345',
                        'Felipe Iago Dantas',
                        'felipeiago.dantas@outlook.com',
                        '84997039005',
                        true,
                        '1',
                        '6606',
                        '2020-03-01');

select inserir_supervisor('verinha',
                        '@12345',
                        'Vera Cavalcanti',
                        'Vera.Cavalcanti@gmail.com',
                        '84998769643',
                        true,
                        '1',
                        '2',
                        '2005-03-20');


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

INSERT INTO funcionario (usuario,senha,nome,email,telefone,ativo,tipo_usuario,data_chegada,tipo)
VALUES ('daenerys','12345',' Daenerys da silva sauro','Daeneryys.Dantas@gmail.com','66666666',TRUE,1101,'2023-08-08',1);

INSERT INTO funcionario (usuario,senha,nome,email,telefone,ativo,tipo_usuario,data_chegada,tipo)
VALUES ('daenerys','12345',' Daenerys da silva sauro','Daeneryys.Dantas@gmail.com','66666666',TRUE,1101,'2023-08-08',1);

INSERT INTO usuario (usuario,senha,nome,email,telefone,ativo,tipo_usuario,data_chegada)
VALUES ('daenerys','12345',' Daenerys da silva sauro','Daeneryys.Dantas@gmail.com','66666666',TRUE,1101,'2023-08-08');



select *  from ONLY usuario
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
