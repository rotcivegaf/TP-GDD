USE [GD1C2015]

GO

--Se crea el schema, si es que no existe

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = N'CASI_COMPILA')
	EXEC sys.sp_executesql N'CREATE SCHEMA [CASI_COMPILA] AUTHORIZATION [gd]'

GO

--Se borran todos los objetos previamente existentes

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'CASI_COMPILA.Paises') AND type in (N'U')) DROP TABLE CASI_COMPILA.Paises
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'CASI_COMPILA.Tipos_Documento') AND type in (N'U')) DROP TABLE CASI_COMPILA.Tipos_Documento
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'CASI_COMPILA.Bancos') AND type in (N'U')) DROP TABLE CASI_COMPILA.Bancos

--Se crean las tablas y se las carga con los datos correspondientes

CREATE TABLE CASI_COMPILA.Paises (
	Pais_Codigo NUMERIC(18,0) PRIMARY KEY,
	Pais_Desc VARCHAR(250) NOT NULL
	)

INSERT INTO CASI_COMPILA.Paises (Pais_Codigo, Pais_Desc) SELECT DISTINCT Cli_Pais_Codigo, Cli_Pais_Desc FROM gd_esquema.Maestra

PRINT 'Tabla Paises creada correctamente'

GO


CREATE TABLE CASI_COMPILA.Tipos_Documento (
	Tipo_Doc_Cod NUMERIC(18,0) PRIMARY KEY,
	Tipo_Doc_Desc VARCHAR(255) NOT NULL
	)

INSERT INTO CASI_COMPILA.Tipos_Documento (Tipo_Doc_Cod, Tipo_Doc_Desc) SELECT DISTINCT Cli_Tipo_Doc_Cod, Cli_Tipo_Doc_Desc FROM gd_esquema.Maestra

PRINT 'Tabla Tipos_Documento creada correctamente'

GO

CREATE TABLE CASI_COMPILA.Bancos (
	Banco_Codigo NUMERIC(18,0) PRIMARY KEY,
	Banco_Nombre VARCHAR(255) NOT NULL,
	Banco_Direccion VARCHAR(255) NOT NULL,
	)

INSERT INTO CASI_COMPILA.Bancos (Banco_Codigo, Banco_Nombre, Banco_Direccion) SELECT DISTINCT Banco_Cogido, Banco_Nombre, Banco_Direccion FROM gd_esquema.Maestra WHERE Banco_Cogido IS NOT NULL

PRINT 'Tabla Bancos creada correctamente'



	

