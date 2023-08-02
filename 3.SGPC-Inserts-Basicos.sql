            /*      INSERTS PARA ALGUNS DADOS PRE-ESTABELECIDOS       */
SET SCHEMA 'sgpcdatabase';

INSERT INTO tipo_bolsista (descricao) VALUES
('Gerência'),
('Design'),
('Avaliação'),
('Informática');

INSERT INTO tipo_usuario (descricao) VALUES
('Zero'),
('Master'),
('Chefe'),
('Comum');

INSERT INTO os_pc (nome) VALUES
('Windows-10'),
('Windows-11'),
('Debain'),
('Ubuntu'),
('Mint'),
('Arch-Linux'),
('Open-BSD'),
('Net-BSD'),
('DragonFly-BSD'),
('Free-BSD');

INSERT INTO modelo_pc (modelo) VALUES
('HP Compaq 6005 Pro SFF'),
('HP Compaq 6305 Pro SFF'),
('HP EliteDesk 705 G1 SFF'),
('HP EliteDesk 705 G1 mini-desktop'),
('HP EliteDesk 800 G3 SFF'),
('DELL Opitplex 7050'),
('DELL Opitplex 3070 micro');

INSERT INTO ram_pc (ram) VALUES
(1,'1 GB'),
(2,'2 GB'),
(3,'3 GB'),
(4,'4 GB'),
(6,'6 GB'),
(8,'8 GB'),
(12,'12 GB');

INSERT INTO ram_ddr_pc (ddr) VALUES
(2,'ddr2'),
(3,'ddr3'),
(4,'ddr4');

INSERT INTO hd_pc (hd) VALUES
(250,'250 GB'),
(500,'500 GB'),
(1,'1 TB'),
(2,'2 TB');

INSERT INTO Tipo_Patrimonio (descricao) VALUES
('Cadeira'),
('Mesa'),
('Geladeira'),
('Microondas'),
('Monitor'),
('Computador'),
('Estabilizador'),
('Ar-condicionado'),
('Liquidificador'),
('Televisão'),
('Cama'),
('Birô'),
('Lousa'),
('Switch'),
('Acess point'),
('Extintor'),
('Bebedouro'),
('Freezer'),
('Armário'),
('Guarda-roupa'),
('Galão de água');
		/*		CHAMADOS		*/

INSERT INTO tipo_chamado (descricao) VALUES
(11,'Informátca'),
(22,'Geral');

INSERT INTO estado_chamado (descricao) VALUES
(0,'Aberto'),
(2,'Andamento'),
(3,'Aguardo'),
(4,'Espera'),
(7,'Resolvido'),
(1,'Fechado');

		/*		PREDIOS			*/

INSERT INTO complexo (nome) VALUES
('CAMPUS'),
('BIOMÉDICA'),
('PÓS-GRADUAÇÃO/POUSO'),
('PRAÇA CÍVICA'),
('MIPIBU'),
('REITORIA'),
('SANTA CRUZ'),
('MOSSORÓ'),
('CAICÓ');

    /*  COMPLEXO CAMPUS */
INSERT INTO predio (nome,complexo) VALUES
('CAMPUS I',1),
('CAMPUS II',1),
('CAMPUS III',1),
('CAMPUS IV',1);

    /* OUTROS COMPLEXOS QUE SÓ TEM UM PŔEDIO */
    
INSERT INTO predio (nome,complexo) VALUES
('CASAS DA BIOMÉDICA',2),
('PÓS-GRADUAÇÃO/POUSO',3),
('PRAÇA CÍVICA',4),
('MIPIBU',5),
('PROAE',6),
('SANTA CRUZ',7),
('MOSSORÓ',8),
('CAICÓ',9);
            /* CAMPUS I */
INSERT INTO andar (nome,predio) VALUES
('PISO I',1),
('PISO II',1);

            /* CAMPUS II */
INSERT INTO andar (nome,predio) VALUES
('PISO I',2),
('PISO II',2);

            /* CAMPUS III */
INSERT INTO andar (nome,predio) VALUES
('PISO I',3),
('PISO II',3),
('PISO III',3),
('PISO IV',3);

            /* CAMPUS IV */
INSERT INTO andar (nome,predio) VALUES
('PISO I',4),
('PISO II',4),
('PISO III',4),
('PISO IV',4);

            /* BIOMÉDICA */
INSERT INTO andar (nome,predio) VALUES
('TÉRREO',5);

            /* PÓS-GRADUAÇÃO */
INSERT INTO andar (nome,predio) VALUES
('TÉRREO',6);

            /* PRAÇA CÍVICA */
INSERT INTO andar (nome,predio) VALUES
('TÉRREO',7);

            /* MIPIBU */
INSERT INTO andar (nome,predio) VALUES
('TÉRREO',8);

            /* PROAE */
INSERT INTO andar (nome,predio) VALUES
('TÉRREO',9),
('PRIMEIRO ANDAR',9);

           /* PISO I - CAMPUS I */
INSERT INTO comodo (nome,andar) VALUES
('QUARTO 101',1),
('QUARTO 102',1),
('QUARTO 103',1),
('QUARTO 104',1),
('QUARTO 105',1),
('QUARTO 106',1),
('QUARTO 107',1),
('QUARTO 108',1),
('CORREDOR',1),
('COZINHA',1),
('BANHEIRO',1);

           /* PISO II - CAMPUS I */
INSERT INTO comodo (nome,andar) VALUES
('QUARTO 201',2),
('QUARTO 202',2),
('QUARTO 203',2),
('QUARTO 204',2),
('QUARTO 205',2),
('QUARTO 206',2),
('QUARTO 207',2),
('QUARTO 208',2),
('CORREDOR',2),
('COZINHA',2),
('BANHEIRO',2),
('SALA DE INFORMÁTICA',2);

           /* PISO I - CAMPUS II */
INSERT INTO comodo (nome,andar) VALUES
('QUARTO 101',3),
('QUARTO 102',3),
('QUARTO 103',3),
('QUARTO 104',3),
('QUARTO 105',3),
('QUARTO 106',3),
('QUARTO 107',3),
('QUARTO 108',3),
('CORREDOR',3),
('COZINHA',3),
('BANHEIRO',3);

           /* PISO II - CAMPUS II */
INSERT INTO comodo (nome,andar) VALUES
('QUARTO 201',4),
('QUARTO 202',4),
('QUARTO 203',4),
('QUARTO 204',4),
('QUARTO 205',4),
('QUARTO 206',4),
('QUARTO 207',4),
('QUARTO 208',4),
('CORREDOR',4),
('COZINHA',4),
('BANHEIRO',4),
('SALA DE INFORMÁTICA',4);

            /*      CAMPUS III  */

           /* PISO I - CAMPUS III */
INSERT INTO comodo (nome,andar) VALUES
('QUARTO 101',5),
('QUARTO 102',5),
('QUARTO 103',5),
('QUARTO 104',5),
('QUARTO 105',5),
('QUARTO 106',5),
('QUARTO 107',5),
('QUARTO 108',5),
('CORREDOR',5),
('SALA DE INFORMÁTICA',5),
('SALA DE ESTUDOS',5),
('COZINHA',5),
('BANHEIRO',5);

           /* PISO II - CAMPUS III */
INSERT INTO comodo (nome,andar) VALUES
('QUARTO 201',6),
('QUARTO 202',6),
('QUARTO 203',6),
('QUARTO 204',6),
('QUARTO 205',6),
('QUARTO 206',6),
('QUARTO 207',6),
('QUARTO 208',6),
('CORREDOR',6),
('SALA DE INFORMÁTICA',6),
('SALA DE ESTUDOS',6),
('COZINHA',6),
('BANHEIRO',6);

           /* PISO III - CAMPUS III */
INSERT INTO comodo (nome,andar) VALUES
('QUARTO 301',7),
('QUARTO 302',7),
('QUARTO 303',7),
('QUARTO 304',7),
('QUARTO 305',7),
('QUARTO 306',7),
('QUARTO 307',7),
('QUARTO 308',7),
('CORREDOR',7),
('SALA DE INFORMÁTICA',7),
('SALA DE ESTUDOS',7),
('COZINHA',7),
('BANHEIRO',7);

           /* PISO IV - CAMPUS III */
INSERT INTO comodo (nome,andar) VALUES
('QUARTO 401',8),
('QUARTO 402',8),
('QUARTO 403',8),
('QUARTO 404',8),
('QUARTO 405',8),
('QUARTO 406',8),
('QUARTO 407',8),
('QUARTO 408',8),
('CORREDOR',8),
('SALA DE INFORMÁTICA',8),
('SALA DE ESTUDOS',8),
('COZINHA',8),
('BANHEIRO',8);

            /* CAMPUS IV */
            
          /* PISO I - CAMPUS IV */
INSERT INTO comodo (nome,andar) VALUES
('QUARTO 101',9),
('QUARTO 102',9),
('QUARTO 103',9),
('QUARTO 104',9),
('QUARTO 105',9),
('QUARTO 106',9),
('QUARTO 107',9),
('QUARTO 108',9),
('CORREDOR',9),
('SALA DE INFORMÁTICA',9),
('SALA DE ESTUDOS',9),
('COZINHA',9),
('BANHEIRO',9);

           /* PISO II - CAMPUS IV */
INSERT INTO comodo (nome,andar) VALUES
('QUARTO 201',10),
('QUARTO 202',10),
('QUARTO 203',10),
('QUARTO 204',10),
('QUARTO 205',10),
('QUARTO 206',10),
('QUARTO 207',10),
('QUARTO 208',10),
('CORREDOR',10),
('SALA DE INFORMÁTICA',10),
('SALA DE ESTUDOS',10),
('COZINHA',10),
('BANHEIRO',10);

           /* PISO III - CAMPUS IV */
INSERT INTO comodo (nome,andar) VALUES
('QUARTO 301',11),
('QUARTO 302',11),
('QUARTO 303',11),
('QUARTO 304',11),
('QUARTO 305',11),
('QUARTO 306',11),
('QUARTO 307',11),
('QUARTO 308',11),
('CORREDOR',11),
('SALA DE INFORMÁTICA',11),
('SALA DE ESTUDOS',11),
('COZINHA',11),
('BANHEIRO',11);

           /* PISO IV - CAMPUS IV */
INSERT INTO comodo (nome,andar) VALUES
('QUARTO 401',12),
('QUARTO 402',12),
('QUARTO 403',12),
('QUARTO 404',12),
('QUARTO 405',12),
('QUARTO 406',12),
('QUARTO 407',12),
('QUARTO 408',12),
('CORREDOR',12),
('SALA DE INFORMÁTICA',12),
('SALA DE ESTUDOS',12),
('COZINHA',12),
('BANHEIRO',12);

            /*      BIOMÉDICA       */
            
INSERT INTO comodo (nome,andar) VALUES
('CASA 4',13),
('CASA 6',13),
('CASA 8',13),
('CASA 10',13),
('CASA 12',13),
('CASA 14',13),
('CASA 16',13),
('CASA 18',13),
('CASA 20',13),
('CASA 22',13),
('CASA 24',13),
('CASA 26',13),
('CASA 28',13),
('CASA 30',13),
('CASA 32',13);