USE [GD1C2015]

GO

--Se crea el schema, si es que no existe

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = N'CASI_COMPILA') 
	BEGIN
	EXEC sys.sp_executesql N'CREATE SCHEMA [CASI_COMPILA] AUTHORIZATION [gd]'
	PRINT 'Schema CASI_COMPILA creado correctamente'
	END

GO

--Se borran todos los objetos previamente existentes

IF OBJECT_ID ('CASI_COMPILA.Cuentas') IS NOT NULL DROP TABLE CASI_COMPILA.Cuentas
IF OBJECT_ID ('CASI_COMPILA.Tipos_Cuentas') IS NOT NULL DROP TABLE CASI_COMPILA.Tipos_Cuentas
IF OBJECT_ID ('CASI_COMPILA.Funcionalidades_Rol') IS NOT NULL DROP TABLE CASI_COMPILA.Funcionalidades_Rol
IF OBJECT_ID ('CASI_COMPILA.Funcionalidades') IS NOT NULL DROP TABLE CASI_COMPILA.Funcionalidades
IF OBJECT_ID ('CASI_COMPILA.Usuarios_Rol') IS NOT NULL DROP TABLE CASI_COMPILA.Usuarios_Rol
IF OBJECT_ID ('CASI_COMPILA.Usuarios') IS NOT NULL DROP TABLE CASI_COMPILA.Usuarios
IF OBJECT_ID ('CASI_COMPILA.Roles') IS NOT NULL DROP TABLE CASI_COMPILA.Roles
IF OBJECT_ID ('CASI_COMPILA.Clientes') IS NOT NULL DROP TABLE CASI_COMPILA.Clientes
IF OBJECT_ID ('CASI_COMPILA.Paises') IS NOT NULL DROP TABLE CASI_COMPILA.Paises
IF OBJECT_ID ('CASI_COMPILA.Tipos_Documento') IS NOT NULL DROP TABLE CASI_COMPILA.Tipos_Documento
IF OBJECT_ID ('CASI_COMPILA.Bancos') IS NOT NULL DROP TABLE CASI_COMPILA.Bancos
IF OBJECT_ID ('CASI_COMPILA.Alta_Rol') IS NOT NULL DROP PROCEDURE CASI_COMPILA.Alta_Rol
IF OBJECT_ID ('CASI_COMPILA.Mod_Estado_Rol') IS NOT NULL DROP PROCEDURE CASI_COMPILA.Mod_Estado_Rol
IF OBJECT_ID ('CASI_COMPILA.Asociar_Rol_Func') IS NOT NULL DROP PROCEDURE CASI_COMPILA.Asociar_Rol_Func
IF OBJECT_ID ('CASI_COMPILA.Desasociar_Rol_Func') IS NOT NULL DROP PROCEDURE CASI_COMPILA.Desasociar_Rol_Func
IF OBJECT_ID ('CASI_COMPILA.Alta_Usuario') IS NOT NULL DROP PROCEDURE CASI_COMPILA.Alta_Usuario
IF OBJECT_ID ('CASI_COMPILA.Baja_Usuario') IS NOT NULL DROP PROCEDURE CASI_COMPILA.Baja_Usuario
IF OBJECT_ID ('CASI_COMPILA.Asignar_Rol_Usuario') IS NOT NULL DROP PROCEDURE CASI_COMPILA.Asignar_Rol_Usuario
IF OBJECT_ID ('CASI_COMPILA.Cambiar_Estado') IS NOT NULL DROP FUNCTION CASI_COMPILA.Cambiar_Estado

PRINT 'Tablas eliminadas correctamente'
GO


-------------------------------------------Funciones---------------------------------------

CREATE FUNCTION CASI_COMPILA.Cambiar_Estado(@Estado BIT)
RETURNS BIT
AS
BEGIN

DECLARE @Retorno BIT

IF(@Estado = 0)
	SET @Retorno = 1
ELSE
	SET @Retorno = 0
	
RETURN @Retorno

END

GO
	

--Se crean las tablas y se las carga con los datos correspondientes


--------------------------------Paises----------------------------------------------------

CREATE TABLE CASI_COMPILA.Paises (
	Pais_Codigo NUMERIC(18,0) PRIMARY KEY,
	Pais_Desc VARCHAR(250) NOT NULL
	)

INSERT INTO CASI_COMPILA.Paises
(Pais_Codigo, Pais_Desc)
SELECT DISTINCT Cli_Pais_Codigo, Cli_Pais_Desc FROM gd_esquema.Maestra

PRINT 'Tabla Paises creada correctamente'

GO

-----------------------------Tipos Documento-------------------------------------------

CREATE TABLE CASI_COMPILA.Tipos_Documento (
	Tipo_Doc_Cod NUMERIC(18,0) PRIMARY KEY,
	Tipo_Doc_Desc VARCHAR(255) NOT NULL
	)

INSERT INTO CASI_COMPILA.Tipos_Documento
(Tipo_Doc_Cod, Tipo_Doc_Desc)
SELECT DISTINCT Cli_Tipo_Doc_Cod, Cli_Tipo_Doc_Desc FROM gd_esquema.Maestra

PRINT 'Tabla Tipos_Documento creada correctamente'

GO

----------------------------------Bancos------------------------------------------------

CREATE TABLE CASI_COMPILA.Bancos (
	Banco_Codigo NUMERIC(18,0) PRIMARY KEY,
	Banco_Nombre VARCHAR(255) NOT NULL,
	Banco_Direccion VARCHAR(255) NOT NULL,
	)

INSERT INTO CASI_COMPILA.Bancos
(Banco_Codigo, Banco_Nombre, Banco_Direccion)
SELECT DISTINCT Banco_Cogido, Banco_Nombre, Banco_Direccion FROM gd_esquema.Maestra WHERE Banco_Cogido IS NOT NULL

PRINT 'Tabla Bancos creada correctamente'

GO


----------------------------------Clientes---------------------------------------------


--REVISAR!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

CREATE TABLE CASI_COMPILA.Clientes(
	Cli_Codigo NUMERIC(18,0) IDENTITY(1,1) PRIMARY KEY, --Ver si dejar esto asi (no hay nro de doc)
	Cli_Nombre VARCHAR(255) NOT NULL,
	Cli_Apellido VARCHAR(255) NOT NULL,
	Cli_Pais_Codigo NUMERIC(18,0) NOT NULL FOREIGN KEY REFERENCES CASI_COMPILA.Paises,
	Cli_Tipo_Doc_Cod NUMERIC(18,0) NOT NULL FOREIGN KEY REFERENCES CASI_COMPILA.Tipos_Documento,
	Cli_Dom_Calle VARCHAR(255) NOT NULL,
	Cli_Dom_Nro NUMERIC (18,0) NOT NULL,
	Cli_Dom_Piso NUMERIC(18,0),
	Cli_Dom_Depto VARCHAR(10),
	Cli_Fecha_Nac DATETIME NOT NULL,
	Cli_Mail VARCHAR(255) NOT NULL
	)
	
INSERT INTO CASI_COMPILA.Clientes
(Cli_Nombre, Cli_Apellido, Cli_Pais_Codigo, Cli_Tipo_Doc_Cod, Cli_Dom_Calle, 
Cli_Dom_Nro, Cli_Dom_Piso, Cli_Dom_Depto, Cli_Fecha_Nac, Cli_Mail)
SELECT DISTINCT Cli_Nombre, Cli_Apellido, Cli_Pais_Codigo, Cli_Tipo_Doc_Cod, Cli_Dom_Calle, 
Cli_Dom_Nro, Cli_Dom_Piso, Cli_Dom_Depto, Cli_Fecha_Nac, Cli_Mail FROM gd_esquema.Maestra


--En esta tabla hay que generar un indice para mayor performance


PRINT 'Tabla Clientes creada correctamente'

GO

-------------------------------------Roles-----------------------------------------------

CREATE TABLE CASI_COMPILA.Roles(
	Rol_Cod TINYINT IDENTITY(1,1) PRIMARY KEY,
	Rol_Nombre VARCHAR(50) NOT NULL UNIQUE,
	Rol_Estado BIT NOT NULL -- 1=ACTIVO 0=NO ACTIVO
)

GO

--ABM Roles

CREATE PROCEDURE CASI_COMPILA.Alta_Rol
(@Nombre VARCHAR(50), @Estado BIT)
AS
BEGIN

INSERT INTO CASI_COMPILA.Roles
(Rol_Nombre, Rol_Estado)
VALUES
(@Nombre, @Estado)

END

GO

CREATE PROCEDURE CASI_COMPILA.Mod_Estado_Rol
(@Rol_Cod TINYINT)
AS
BEGIN

UPDATE CASI_COMPILA.Roles SET Rol_Estado = CASI_COMPILA.Cambiar_Estado(Rol_Estado) WHERE Rol_Cod = @Rol_Cod

END

--Falta la modificacion!!!!
														

GO

--Se cargan los 2 roles iniciales (Administrador y Cliente)

EXEC CASI_COMPILA.Alta_Rol @Nombre = 'ADMINISTRADOR', @Estado = 1
EXEC CASI_COMPILA.Alta_Rol @Nombre = 'CLIENTE', @Estado = 1

PRINT 'Tabla Roles creada correctamente'

GO

-------------------------------Funcionalidades de los roles---------------------------------

CREATE TABLE CASI_COMPILA.Funcionalidades(
	Func_Cod SMALLINT IDENTITY(1,1) PRIMARY KEY,
	Func_Desc VARCHAR(255) NOT NULL
)

GO

--Como es muchos a muchos, se crea una tabla intermedia

CREATE TABLE CASI_COMPILA.Funcionalidades_Rol(
	Rol_Cod TINYINT NOT NULL FOREIGN KEY REFERENCES CASI_COMPILA.Roles,
	Func_Cod SMALLINT NOT NULL FOREIGN KEY REFERENCES CASI_COMPILA.Funcionalidades,
	PRIMARY KEY (Rol_Cod, Func_Cod) --De esta forma, no se puede repetir la funcion dentro de un rol
)

GO

--Se crea procedure para asociar una funcion a un rol

CREATE PROCEDURE CASI_COMPILA.Asociar_Rol_Func
(@Rol_Cod TINYINT, @Func_Cod SMALLINT)
AS
BEGIN

INSERT INTO CASI_COMPILA.Funcionalidades_Rol
(Rol_Cod, Func_Cod)
VALUES
(@Rol_Cod, @Func_Cod)

END 

GO

--Se crea procedure para quitarle una funcion a un rol

CREATE PROCEDURE CASI_COMPILA.Desasociar_Rol_Func
(@Rol_Cod TINYINT, @Func_Cod SMALLINT)
AS
BEGIN

DELETE FROM CASI_COMPILA.Funcionalidades_Rol WHERE Rol_Cod = @Rol_Cod AND Func_Cod = @Func_Cod

END 

GO

PRINT 'Tablas Funcionalidades y Funcionalidades_Rol creadas correctamente'

-----------------------------------Usuarios----------------------------------------------

CREATE TABLE CASI_COMPILA.Usuarios(
	User_Cod NUMERIC(18,0) IDENTITY(1,1) PRIMARY KEY,
	User_Nombre VARCHAR(50) NOT NULL UNIQUE,
	User_Password VARCHAR(50) NOT NULL,
	User_Rol_Cod TINYINT NOT NULL FOREIGN KEY REFERENCES CASI_COMPILA.Roles,
	User_Fecha_Creacion DATETIME NOT NULL,
	User_Fecha_Mod DATETIME NOT NULL,
	User_Preg_Secreta VARCHAR(255) NOT NULL,
	User_Resp_Secreta VARCHAR(255) NOT NULL,
	User_Cli_Codigo NUMERIC(18,0) UNIQUE FOREIGN KEY REFERENCES CASI_COMPILA.Clientes, --Puede ser null si es admin
	User_Estado BIT NOT NULL -- 1= ACTIVO 0 = INACTIVO
	)
	
--Hay que cargarle LOS usuarios (1 por cada cliente + los admin)!!!!!!!!!

GO

--Entre usuarios y roles hay una relacion muchos a muchos

CREATE TABLE CASI_COMPILA.Usuarios_Rol(
	User_Cod NUMERIC(18,0) NOT NULL FOREIGN KEY REFERENCES CASI_COMPILA.Usuarios,
	Rol_Cod TINYINT NOT NULL FOREIGN KEY REFERENCES CASI_COMPILA.Roles,
	User_Rol_Estado BIT NOT NULL  --Un rol puede estar deshabilitado para un user, pero no implica que el rol se desactive en todo el sistema
)

GO
	
PRINT 'Tabla Usuarios y Tabla Usuarios_Rol creada correctamente'

GO

--ABM Usuario

--Asignar un rol a un usuario

CREATE PROCEDURE CASI_COMPILA.Asignar_Rol_Usuario
(@Usuario NUMERIC(18,0), @Rol TINYINT)
AS
BEGIN

INSERT INTO CASI_COMPILA.Usuarios_Rol
(User_Cod, Rol_Cod, User_Rol_Estado)
VALUES
(@Usuario, @Rol, 1) --Se asume que cuando se asigna un rol este se activa por defecto

END

GO

CREATE PROCEDURE CASI_COMPILA.Alta_Usuario
(@Nombre VARCHAR(50), @Password VARCHAR(50), @Rol TINYINT, @PregSecreta VARCHAR(255), 
@RespSecreta VARCHAR(255), @Cliente NUMERIC(18,0) = NULL) --Si es admin y no es cliente, no se ingresa el parametro
AS
BEGIN

INSERT INTO CASI_COMPILA.Usuarios
(User_Nombre, User_Password, User_Fecha_Creacion, User_Fecha_Mod, User_Preg_Secreta, User_Resp_Secreta, User_Cli_Codigo,User_Estado)
VALUES
(@Nombre, @Password, GETDATE(), GETDATE(), @PregSecreta, @RespSecreta, @Cliente, 1) --El rol se asigna aparte

END

GO

CREATE PROCEDURE CASI_COMPILA.Baja_Usuario
(@User_Cod NUMERIC(18,0))
AS
BEGIN

UPDATE CASI_COMPILA.Usuarios  SET User_Estado = 0, User_Fecha_Mod = GETDATE() WHERE User_Cod = @User_Cod

END

GO


		

-----------------------------------Cuentas---------------------------------------------

--Tipos de cuentas (Consultar por los tipos de cuentas de la tabla maestra, ver que se asume)

CREATE TABLE CASI_COMPILA.Tipos_Cuentas(
	Tipo_Cod TINYINT IDENTITY(1,1) PRIMARY KEY,
	Tipo_Nombre VARCHAR(50) NOT NULL UNIQUE,
	Tipo_Dias_Restantes SMALLINT NOT NULL,
	Tipo_Costo NUMERIC(10,2)
)

--REVISAR!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

CREATE TABLE CASI_COMPILA.Cuentas(
	Cuenta_Numero NUMERIC(18,0) PRIMARY KEY,
	Cuenta_Fecha_Creacion DATETIME NOT NULL,
	Cuenta_Estado VARCHAR(255) CHECK(Cuenta_Estado IN ('PENDIENTE DE ACTIVACION', 'CERRADA', 'INHABILITADA', 'HABILITADA')),
	Cuenta_Pais_Codigo  NUMERIC(18,0) NOT NULL FOREIGN KEY REFERENCES CASI_COMPILA.Paises,
	Cuenta_Fecha_Cierre DATETIME,
	Cuenta_Cli_Codigo NUMERIC(18,0) NOT NULL FOREIGN KEY REFERENCES CASI_COMPILA.Clientes,
	Cuenta_Tipo_Cod TINYINT FOREIGN KEY REFERENCES CASI_COMPILA.Tipos_Cuentas --Tendria que ser NOT NULL, lo dejo asi xq en la tabla maestra no estan los tipos asociados a cada cuenta
	)

PRINT 'Tabla Cuentas creada correctamente'
	
--Hay que cargar los datos de la tabla!!!!






	

