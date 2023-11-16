CREATE SCHEMA sgpcdatabase
    AUTHORIZATION postgres;

SET SCHEMA 'sgpcdatabase';

-- gerencia de pessoal: funcionario e bolsista test

CREATE TABLE tipo_usuario(
	id	 		SMALLSERIAL,
    descricao	VARCHAR(20),

	PRIMARY KEY (id)
);

CREATE TABLE tipo_bolsista(
	id	 		SERIAL,
    descricao	VARCHAR(20),

	PRIMARY KEY (id)
);

CREATE TABLE tipo_patrimonio(
	id			SERIAL,
    descricao	VARCHAR(30),

    PRIMARY KEY (id)
);

CREATE TABLE nivel_acesso(
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
    id              UUID DEFAULT    gen_random_uuid(),
	login			VARCHAR(25)		UNIQUE NOT NULL,
	senha			VARCHAR(80)		NOT NULL,
    nome			VARCHAR(100)	NOT NULL,
    email       	VARCHAR(50)     NOT NULL UNIQUE,
    telefone    	VARCHAR(12),
	ativo			BOOLEAN			NOT NULL,
    tipo            VARCHAR(25)        NOT NULL,
	data_chegada	DATE,
	data_saida		DATE,

	PRIMARY KEY (id)
);

CREATE TABLE bolsista(
    id              UUID,
    matricula       VARCHAR(12),
    tipo_bolsista   VARCHAR(30),

    PRIMARY KEY (matricula),
    FOREIGN KEY (id)       REFERENCES usuario(id)
);

CREATE TABLE supervisor(
    id                UUID,
    cargo   VARCHAR(50) NOT NULL,

    PRIMARY KEY (id),
    FOREIGN KEY (id)              REFERENCES usuario(id)
);

-- gerencia dos predios

CREATE TABLE complexo(
	id		SERIAL NOT NULL,
    nome	VARCHAR(20) NOT NULL,

	PRIMARY KEY (id)
);

CREATE TABLE predio(
	id			SERIAL NOT NULL,
    nome		VARCHAR(20) NOT NULL,
    complexo	INT 	NOT NULL,

	PRIMARY KEY (id),
    FOREIGN KEY (complexo)	REFERENCES Complexo(id)
);

CREATE TABLE andar(
	id 		SERIAL NOT NULL,
    nome	VARCHAR(20) NOT NULL,
    predio	INT	NOT NULL,

	PRIMARY KEY (id),
    FOREIGN KEY (Predio)	REFERENCES Predio(id)
);

CREATE TABLE comodo(
	id		SERIAL NOT NULL,
    nome	VARCHAR(20) NOT NULL,
    andar	INT 	NOT NULL,

	PRIMARY KEY (id),
	FOREIGN KEY (Andar)	REFERENCES Andar(id)
);

-- gerencia de patrimonio

CREATE TABLE estado_patrimonio(
    id  SERIAL,
    descricao VARCHAR(25),

    PRIMARY KEY (id)
);

CREATE TABLE patrimonio(
	id			UUID DEFAULT gen_random_uuid(),
    tombamento	VARCHAR(12) UNIQUE,
    descricao	TEXT	    NOT NULL,
    estado		INT	NOT NULL,
    tipo		INT	NOT NULL,
    localidade	INT	NOT NULL,
    alienado    BOOLEAN		NOT NULL,

    PRIMARY KEY (id),
    FOREIGN KEY (tipo) 			REFERENCES tipo_patrimonio(id),
    FOREIGN KEY (estado)        REFERENCES estado_patrimonio(id),
    FOREIGN KEY (localidade)	REFERENCES comodo(id)
);

CREATE TABlE os_pc(
	id		SERIAL,
    descricao 	TEXT,

    PRIMARY KEY (id)
);

CREATE TABlE modelo_pc(
	id 		SERIAL,
    descricao 	TEXT,

    PRIMARY KEY (id)
);

CREATE TABlE ram_pc(
	id 	SERIAL,
    descricao TEXT,

    PRIMARY KEY (id)
);

CREATE TABlE ram_ddr_pc(
	id 	SERIAL,
    descricao TEXT,

    PRIMARY KEY (id)
);

CREATE TABlE hd_pc(
	id SERIAL,
    descricao TEXT,

    PRIMARY KEY (id)
);

CREATE TABLE patrimonio_pc(
	id			UUID,
    serialpc    VARCHAR     UNIQUE,
    modelo		INT    NOT NULL,
    os			INT,
    ram			INT,
    ram_ddr		INT,
    hd			INT,

    PRIMARY KEY (id),

    FOREIGN KEY (id) 		REFERENCES patrimonio(id),
	FOREIGN KEY (modelo)    REFERENCES modelo_pc(id),
    FOREIGN KEY (os)        REFERENCES os_pc(id),
    FOREIGN KEY (ram)       REFERENCES ram_pc(id),
    FOREIGN KEY (ram_ddr)   REFERENCES ram_ddr_pc(id),
	FOREIGN KEY (hd)        REFERENCES hd_pc(id)
);

CREATE TABLE historico_patrimonio(
    id              BIGSERIAL   NOT NULL,
    patrimonio      UUID        NOT NULL,
    comodo          SMALLINT    NOT NULL,
    usuario         UUID        NOT NULL,
    data_chegada    DATE        NOT NULL DEFAULT CURRENT_DATE,
    data_saida      DATE,

    PRIMARY KEY (id),
    FOREIGN KEY (patrimonio)    REFERENCES patrimonio(id),
    FOREIGN KEY (usuario)	    REFERENCES usuario(id),
    FOREIGN KEY (comodo)        REFERENCES comodo(id)
);

CREATE TABLE manejo(
    id                  SERIAL   	NOT NULL,
    patrimonio	        UUID	    NOT NULL,
    usuario             UUID        NOT NULL,
    comodo_anterior     SMALLINT    NOT NULL,
    comodo_posterior    SMALLINT    NOT NULL,
    data_manejo         DATE        NOT NULL DEFAULT CURRENT_DATE,

    PRIMARY KEY (id),
    FOREIGN KEY (patrimonio)	    REFERENCES patrimonio(id),
    FOREIGN KEY (usuario)	        REFERENCES usuario(id),
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
	criador			UUID	    NOT NULL,
	fechador		UUID,
	data_abertura	TIMESTAMP 	NOT NULL DEFAULT NOW(),
	data_fechamento	TIMESTAMP,
	titulo			TEXT		NOT NULL,
	descricao		TEXT 		NOT NULL,
	localidade		SMALLINT	NOT NULL,
	estado			SMALLINT	NOT NULL,
	tipo			SMALLINT 	NOT NULL,

	PRIMARY KEY (id),
	FOREIGN KEY (criador)		REFERENCES usuario(id),
	FOREIGN KEY (fechador)		REFERENCES usuario(id),
	FOREIGN KEY (localidade)	REFERENCES comodo(id),
    FOREIGN KEY (estado)        REFERENCES estado_chamado(id),
	FOREIGN KEY (tipo)			REFERENCES tipo_chamado(id)
);

CREATE TABLE chamado_patrimonio(
	chamado		INTEGER 	NOT NULL,
	patrimonio 	UUID 	NOT NULL,
	
	FOREIGN KEY (chamado) 	REFERENCES chamado(id),
	FOREIGN KEY (patrimonio) REFERENCES patrimonio(id)
);

CREATE TABLE chamado_bolsista(
	chamado	INTEGER		NOT NULL,
	bolsista 	VARCHAR(12) NOT NULL,
	
	FOREIGN KEY (chamado)    REFERENCES chamado(id),
	FOREIGN KEY (bolsista)	    REFERENCES bolsista(matricula)
);

CREATE TABLE chamado_comentario(
	id				SERIAL		NOT NULL,
	chamado		INTEGER		NOT NULL,
	usuario			UUID	NOT NULL,
	comentario		TEXT		NOT NULL,
	data_comentario	TIMESTAMP 	NOT NULL DEFAULT NOW(),

	PRIMARY KEY (id),
	FOREIGN KEY (chamado)	REFERENCES chamado(id),
	FOREIGN KEY (usuario)		REFERENCES usuario(id)
);

CREATE TABLE chamado_historico(
	id				SERIAL		NOT NULL,
	chamado		INTEGER		NOT NULL,
	estado_anterior	SMALLINT	NOT NULL,
	estado_atual	SMALLINT	NOT NULL,
	usuario			UUID 	NOT NULL,
	data_mudanca	TIMESTAMP	NOT NULL DEFAULT NOW(),
	
	PRIMARY KEY (id),
	FOREIGN KEY (chamado)		REFERENCES chamado(id),
	FOREIGN KEY (estado_anterior)	REFERENCES estado_chamado(id),
	FOREIGN KEY (estado_atual)		REFERENCES estado_chamado(id),
	FOREIGN KEY (usuario)			REFERENCES usuario(id)
);

--Tarefas

CREATE TABLE estado_tarefa(
	id 			SMALLINT	NOT NULL,
	descricao	TEXT		NOT NULL,

	PRIMARY KEY (id)
);

CREATE TABLE tarefa(
    id                  SMALLINT          NOT NULL,
    atribuidor			UUID		NOT NULL,
	atribuido			UUID	NOT NULL,
    descricao           TEXT            NOT NULL,
    prazo               SMALLINT,
    data_abertura	    TIMESTAMP 	    NOT NULL DEFAULT NOW(),
	data_fechamento	    TIMESTAMP       NOT NULL,
    estado              SMALLINT        NOT NULL,

    PRIMARY KEY (id),
    FOREIGN KEY (atribuidor)    REFERENCES usuario(id),
    FOREIGN KEY (atribuido)     REFERENCES usuario(id),
    FOREIGN KEY (estado)        REFERENCES estado_tarefa(id)
);

