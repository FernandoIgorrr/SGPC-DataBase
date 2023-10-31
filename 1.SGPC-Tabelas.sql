CREATE SCHEMA sgpcdatabase
    AUTHORIZATION postgres;

SET SCHEMA 'sgpcdatabase';

-- gerencia de pessoal: funcionario e bolsista test

CREATE TABLE tipo_bolsista(
	id	 		SMALLSERIAL,
    descricao	VARCHAR(20),

	PRIMARY KEY (id)
);

CREATE TABLE tipo_patrimonio(
	id			SMALLSERIAL,
    descricao	VARCHAR(30),

    PRIMARY KEY (id)
);

CREATE TABLE nivel_usuario(
	id	 		SMALLSERIAL,
    descricao	VARCHAR(20),

	PRIMARY KEY (id)
);

CREATE TABLE tipo_supervisor(
	id			SMALLSERIAL,
	descricao	VARCHAR(20),

	PRIMARY KEY(id)
);

CREATE TABLE usuario(
    id              SMALLINT        NOT NULL,
	usuario			VARCHAR(25)		UNIQUE NOT NULL,
	senha			VARCHAR(40)		NOT NULL,
    nome			VARCHAR(100)	NOT NULL,
    email       	VARCHAR(50),
    telefone    	VARCHAR(12),
	ativo			BOOLEAN			NOT NULL,
	nivel_de_acesso	SMALLINT 		NOT NULL,
	data_chegada	DATE,
	data_saida		DATE,


	PRIMARY KEY (id),
	FOREIGN KEY (nivel_de_acesso) REFERENCES nivel_usuario(id)
);

CREATE TABLE bolsista(
    matricula       VARCHAR(12),
    usuario         SMALLINT,
    tipo_bolsista   SMALLINT,

    PRIMARY KEY (matricula),
    FOREIGN KEY (usuario)       REFERENCES usuario(id),
    FOREIGN KEY (tipo_bolsista) REFERENCES tipo_bolsista(id)
);

CREATE TABLE supervisor(
    usuario         SMALLINT,
    tipo_supervisor   SMALLINT,

    PRIMARY KEY (usuario),
    FOREIGN KEY (usuario)       REFERENCES usuario(id),
    FOREIGN KEY (tipo_supervisor) REFERENCES tipo_supervisor(id)
);

-- gerencia dos predios

CREATE TABLE complexo(
	id		SMALLSERIAL NOT NULL,
    nome	VARCHAR(20) NOT NULL,

	PRIMARY KEY (id)
);

CREATE TABLE predio(
	id			SMALLSERIAL NOT NULL,
    nome		VARCHAR(20) NOT NULL,
    complexo	SMALLINT 	NOT NULL,

	PRIMARY KEY (id),
    FOREIGN KEY (complexo)	REFERENCES Complexo(id)
);

CREATE TABLE andar(
	id 		SMALLSERIAL NOT NULL,
    nome	VARCHAR(20) NOT NULL,
    predio	SMALLINT	NOT NULL,

	PRIMARY KEY (id),
    FOREIGN KEY (Predio)	REFERENCES Predio(id)
);

CREATE TABLE comodo(
	id		SMALLSERIAL NOT NULL,
    nome	VARCHAR(20) NOT NULL,
    andar	SMALLINT 	NOT NULL,

	PRIMARY KEY (id),
	FOREIGN KEY (Andar)	REFERENCES Andar(id)
);

-- gerencia de patrimonio

CREATE TABLE patrimonio(
	id			SERIAL	    NOT NULL UNIQUE,
    tombamento	VARCHAR(12) UNIQUE,
    descricao	TEXT	    NOT NULL,
    estado		VARCHAR(30)	NOT NULL,
    tipo		SMALLINT	NOT NULL,
    localidade	SMALLINT	NOT NULL,
    alienado    BOOLEAN		NOT NULL,

    PRIMARY KEY (id),
    FOREIGN KEY (tipo) 			REFERENCES tipo_patrimonio(id),
    FOREIGN KEY (localidade)	REFERENCES comodo(id)
);

CREATE TABlE os_pc(
	id		SMALLSERIAL,
    nome 	TEXT,

    PRIMARY KEY (id)
);

CREATE TABlE modelo_pc(
	id 		SMALLSERIAL,
    modelo 	TEXT,

    PRIMARY KEY (id)
);

CREATE TABlE ram_pc(
	id 	SMALLINT,
    ram TEXT,

    PRIMARY KEY (id)
);

CREATE TABlE ram_ddr_pc(
	id 	SMALLINT,
    ddr TEXT,

    PRIMARY KEY (id)
);

CREATE TABlE hd_pc(
	id SMALLINT,
    hd TEXT,

    PRIMARY KEY (id)
);

CREATE TABLE patrimonio_pc(
	id			INTEGER		NOT NULL UNIQUE,
    serialpc    VARCHAR 	UNIQUE,
    modelo		SMALLINT,
    os			SMALLINT,
    ram			SMALLINT	NOT NULL,
    ram_ddr		SMALLINT	NOT NULL,
    hd			SMALLINT	NOT NULL,

    PRIMARY KEY (id),
    FOREIGN KEY (id) 		REFERENCES patrimonio(id),
	FOREIGN KEY (modelo)    REFERENCES modelo_pc(id),
    FOREIGN KEY (os)        REFERENCES os_pc(id),
    FOREIGN KEY (ram)       REFERENCES ram_pc(id),
    FOREIGN KEY (ram_ddr)   REFERENCES ram_ddr_pc(id),
	FOREIGN KEY (hd)        REFERENCES hd_pc(id)
);

CREATE TABLE historico_patrimonio(
    id              SERIAL   	NOT NULL,
    patrimonio      SMALLINT    NOT NULL,
    comodo          SMALLINT    NOT NULL,
    bolsista        VARCHAR(12) ,
    data_chegada    DATE        NOT NULL DEFAULT CURRENT_DATE,
    data_saida      DATE,

    PRIMARY KEY (id),
    FOREIGN KEY (patrimonio)    REFERENCES patrimonio(id),
    FOREIGN KEY (bolsista)	    REFERENCES usuario(usuario),
    FOREIGN KEY (comodo)        REFERENCES comodo(id)
);

CREATE TABLE manejo(
    id                  SERIAL   	NOT NULL,
    patrimonio	        INTEGER	    NOT NULL,
    usuario             VARCHAR(25) NOT NULL,
    comodo_anterior     SMALLINT    NOT NULL,
    comodo_posterior    SMALLINT    NOT NULL,
    data_manejo         DATE        NOT NULL DEFAULT CURRENT_DATE,

    PRIMARY KEY (id),
    FOREIGN KEY (patrimonio)	    REFERENCES patrimonio(id),
    FOREIGN KEY (usuario)	        REFERENCES usuario(usuario),
    FOREIGN KEY (comodo_anterior)	REFERENCES comodo(id),
    FOREIGN KEY (comodo_posterior)	REFERENCES comodo(id)
);

CREATE TABLE responsabilidade(
    bolsista	VARCHAR(12),
    predio		SMALLINT,

    FOREIGN KEY (bolsista)   REFERENCES bolsista(matricula),
    FOREIGN KEY (predio)     REFERENCES predio(id)
);


--	CHAMADOS

CREATE TABLE tipo_chamado(
	id 			SMALLINT	NOT NULL,
	descricao 	TEXT 		NOT NULL,

	PRIMARY KEY (id)
);

CREATE TABLE estado_chamado(
	id 			SMALLINT	NOT NULL,
	descricao	TEXT		NOT NULL,

	PRIMARY KEY (id)
);

CREATE TABLE chamado(
	id				SERIAL	 	NOT NULL UNIQUE,
	criador			VARCHAR(25)	NOT NULL,
	fechador		VARCHAR(25),
	data_abertura	TIMESTAMP 	NOT NULL DEFAULT NOW(),
	data_fechamento	TIMESTAMP,
	titulo			TEXT		NOT NULL,
	descricao		TEXT 		NOT NULL,
	localidade		SMALLINT	NOT NULL,
	estado			SMALLINT	NOT NULL,
	tipo			SMALLINT 	NOT NULL,

	PRIMARY KEY (id),
	FOREIGN KEY (criador)		REFERENCES usuario(usuario),
	FOREIGN KEY (fechador)		REFERENCES usuario(usuario),
	FOREIGN KEY (localidade)	REFERENCES comodo(id),
    FOREIGN KEY (estado)        REFERENCES estado_chamado(id),
	FOREIGN KEY (tipo)			REFERENCES tipo_chamado(id)
);

CREATE TABLE chamado_patrimonio(
	id_chamado		INTEGER 	NOT NULL,
	id_patrimonio 	INTEGER 	NOT NULL,
	
	FOREIGN KEY (id_chamado) 	REFERENCES chamado(id),
	FOREIGN KEY (id_patrimonio) REFERENCES patrimonio(id)
);

CREATE TABLE chamado_bolsista(
	id_chamado	INTEGER		NOT NULL,
	usuario 	VARCHAR(25) NOT NULL,
	
	FOREIGN KEY (id_chamado)		    REFERENCES chamado(id),
	FOREIGN KEY (usuario)	REFERENCES usuario(usuario)
);

CREATE TABLE chamado_comentario(
	id				SERIAL		NOT NULL,
	id_chamado		INTEGER		NOT NULL,
	usuario			VARCHAR(25)	NOT NULL,
	comentario		TEXT		NOT NULL,
	data_comentario	TIMESTAMP 	NOT NULL DEFAULT NOW(),

	PRIMARY KEY (id),
	FOREIGN KEY (id_chamado)	REFERENCES chamado(id),
	FOREIGN KEY (usuario)		REFERENCES usuario(usuario)
);

CREATE TABLE chamado_historico(
	id				SERIAL		NOT NULL,
	id_chamado		INTEGER		NOT NULL,
	estado_anterior	SMALLINT	NOT NULL,
	estado_atual	SMALLINT	NOT NULL,
	usuario			VARCHAR(25)	NOT NULL,
	data_mudanca	TIMESTAMP	NOT NULL DEFAULT NOW(),
	
	PRIMARY KEY (id),
	FOREIGN KEY (id_chamado)		REFERENCES chamado(id),
	FOREIGN KEY (estado_anterior)	REFERENCES estado_chamado(id),
	FOREIGN KEY (estado_atual)		REFERENCES estado_chamado(id),
	FOREIGN KEY (usuario)			REFERENCES usuario(usuario)
);

--Tarefas

CREATE TABLE estado_tarefa(
	id 			SMALLINT	NOT NULL,
	descricao	TEXT		NOT NULL,

	PRIMARY KEY (id)
);

CREATE TABLE tarefa(
    id                  SMALLINT          NOT NULL,
    atribuidor			SMALLINT		NOT NULL,
	atribuido			SMALLINT	NOT NULL,
    descricao           TEXT            NOT NULL,
    prazo               SMALLINT,
    data_abertura	    TIMESTAMP 	    NOT NULL DEFAULT NOW(),
	data_fechamento	    TIMESTAMP       NOT NULL,
    estado              SMALLINT        NOT NULL,

    PRIMARY KEY (id),
    FOREIGN KEY (atribuidor)    REFERENCES usuario(usuario),
    FOREIGN KEY (atribuido)     REFERENCES usuario(usuario),
    FOREIGN KEY (estado)        REFERENCES estado_tarefa(id)
);

