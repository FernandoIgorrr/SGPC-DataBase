select inserir_pc('201501422','asdasd','asdasdads','1',false,'f3122','206','100','16','4','1');

insert into patrimonio_pc (tombamento,
    descricao,
    estado,
    tipo,
    localidade,
    alienado,
    serialpc,
    modelo,
    os,
    ram,
    ram_ddr,
    hd) values ('2012014000','asdasd','asdasdads',2205,1,false,'123123',206,100,16,4,1);
   
   insert into patrimonio_pc (
    descricao,
    estado,
    tipo,
    localidade,
    alienado,
    serialpc,
    modelo,
    os,
    ram,
    ram_ddr,
    hd) values ('asdasd','asdasdads',2205,1,true,'f33',206,100,16,4,1);
   
INSERT INTO bolsista (usuario,senha,nome,email,telefone,ativo,tipo_usuario,data_chegada,matricula,tipo)
VALUES ('figordantas','12345','Fernando Igor Dantas','FernandoIgor.Dantas@gmail.com','66666666',TRUE,1101,'2023-08-08','20170146005',3303);

select * from tipo_usuario
select * from tipo_bolsista
select * from modelo_pc
select * from tipo_patrimonio tp 

SELECT * FROM comodo;

SELECT * FROM bolsista b   

select * from patrimonio p; 

select * from patrimonio_pc pp 

SELECT * FROM historico_patrimonio 


SELECT manejo('1','1','20170146005');

INSERT INTO manejo (patrimonio,bolsista,comodo_anterior,comodo_posterior) 
	VALUES (1,'20170146005',1,2); 

SET SCHEMA 'sgpcdatabase';
