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

IF OBJECT_ID ('CASI_COMPILA.Transferencias') IS NOT NULL DROP TABLE CASI_COMPILA.Transferencias
IF OBJECT_ID ('CASI_COMPILA.Cuentas') IS NOT NULL DROP TABLE CASI_COMPILA.Cuentas
IF OBJECT_ID ('CASI_COMPILA.Estados_Cuentas') IS NOT NULL DROP TABLE CASI_COMPILA.Estados_Cuentas
IF OBJECT_ID ('CASI_COMPILA.Monedas') IS NOT NULL DROP TABLE CASI_COMPILA.Monedas
IF OBJECT_ID ('CASI_COMPILA.Tipos_Cuentas') IS NOT NULL DROP TABLE CASI_COMPILA.Tipos_Cuentas
IF OBJECT_ID ('CASI_COMPILA.Funcionalidades_Roles') IS NOT NULL DROP TABLE CASI_COMPILA.Funcionalidades_Roles
IF OBJECT_ID ('CASI_COMPILA.Funcionalidades') IS NOT NULL DROP TABLE CASI_COMPILA.Funcionalidades
IF OBJECT_ID ('CASI_COMPILA.Usuarios_Roles') IS NOT NULL DROP TABLE CASI_COMPILA.Usuarios_Roles
IF OBJECT_ID ('CASI_COMPILA.Usuarios') IS NOT NULL DROP TABLE CASI_COMPILA.Usuarios
IF OBJECT_ID ('CASI_COMPILA.Roles') IS NOT NULL DROP TABLE CASI_COMPILA.Roles
IF OBJECT_ID ('CASI_COMPILA.Tarjetas') IS NOT NULL DROP TABLE CASI_COMPILA.Tarjetas
IF OBJECT_ID ('CASI_COMPILA.Emisores_Tarjetas') IS NOT NULL DROP TABLE CASI_COMPILA.Emisores_Tarjetas
IF OBJECT_ID ('CASI_COMPILA.Clientes') IS NOT NULL DROP TABLE CASI_COMPILA.Clientes
IF OBJECT_ID ('CASI_COMPILA.Paises') IS NOT NULL DROP TABLE CASI_COMPILA.Paises
IF OBJECT_ID ('CASI_COMPILA.Tipos_Documento') IS NOT NULL DROP TABLE CASI_COMPILA.Tipos_Documento
IF OBJECT_ID ('CASI_COMPILA.Bancos') IS NOT NULL DROP TABLE CASI_COMPILA.Bancos
IF OBJECT_ID ('CASI_COMPILA.Alta_Rol') IS NOT NULL DROP PROCEDURE CASI_COMPILA.Alta_Rol
IF OBJECT_ID ('CASI_COMPILA.Mod_Estado_Rol') IS NOT NULL DROP PROCEDURE CASI_COMPILA.Mod_Estado_Rol
IF OBJECT_ID ('CASI_COMPILA.Asociar_Rol_Func') IS NOT NULL DROP PROCEDURE CASI_COMPILA.Asociar_Rol_Func
IF OBJECT_ID ('CASI_COMPILA.Alta_Usuario') IS NOT NULL DROP PROCEDURE CASI_COMPILA.Alta_Usuario
IF OBJECT_ID ('CASI_COMPILA.Baja_Usuario') IS NOT NULL DROP PROCEDURE CASI_COMPILA.Baja_Usuario
IF OBJECT_ID ('CASI_COMPILA.Asignar_Rol_Usuario') IS NOT NULL DROP PROCEDURE CASI_COMPILA.Asignar_Rol_Usuario
IF OBJECT_ID ('CASI_COMPILA.Nueva_Moneda') IS NOT NULL DROP PROCEDURE CASI_COMPILA.Nueva_Moneda
IF OBJECT_ID ('CASI_COMPILA.Agregar_Estado_Cuenta') IS NOT NULL DROP PROCEDURE CASI_COMPILA.Agregar_Estado_Cuenta
IF OBJECT_ID ('CASI_COMPILA.Agregar_Funcionalidad') IS NOT NULL DROP PROCEDURE CASI_COMPILA.Agregar_Funcionalidad
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
	Pais_Desc VARCHAR(250) NOT NULL UNIQUE
	)

--Esto se hace porque hay paises que aparecen en cuentas y no en clientes

INSERT INTO CASI_COMPILA.Paises
(Pais_Codigo, Pais_Desc)
SELECT * FROM (SELECT Cli_Pais_Codigo, Cli_Pais_Desc FROM gd_esquema.Maestra 
UNION SELECT Cuenta_Pais_Codigo, Cuenta_Pais_Desc FROM gd_esquema.Maestra) AS P


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
SELECT DISTINCT Banco_Cogido, Banco_Nombre, Banco_Direccion 
FROM gd_esquema.Maestra WHERE Banco_Cogido IS NOT NULL

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

EXEC CASI_COMPILA.Alta_Rol @Nombre = 'ADMINISTRADOR GENERAL', @Estado = 1
EXEC CASI_COMPILA.Alta_Rol @Nombre = 'CLIENTE', @Estado = 1

PRINT 'Tabla Roles creada correctamente'

GO

-------------------------------Funcionalidades de los roles---------------------------------

CREATE TABLE CASI_COMPILA.Funcionalidades(
	Func_Cod SMALLINT IDENTITY(1,1) PRIMARY KEY,
	Func_Desc VARCHAR(40) NOT NULL
)

GO

CREATE PROCEDURE CASI_COMPILA.Agregar_Funcionalidad
(@Desc VARCHAR(40))
AS
BEGIN

INSERT INTO CASI_COMPILA.Funcionalidades
(Func_Desc)
VALUES
(@Desc)

END

GO

--Se insertan las funcionalidades

EXEC CASI_COMPILA.Agregar_Funcionalidad @Desc = 'ABM DE ROL'
EXEC CASI_COMPILA.Agregar_Funcionalidad @Desc = 'ABM DE USUARIO'
EXEC CASI_COMPILA.Agregar_Funcionalidad @Desc = 'ABM DE CLIENTE'
EXEC CASI_COMPILA.Agregar_Funcionalidad @Desc = 'ABM DE CUENTA'
EXEC CASI_COMPILA.Agregar_Funcionalidad @Desc = 'ASOCIAR/DESASOCIAR TARJETAS DE CREDITO'
EXEC CASI_COMPILA.Agregar_Funcionalidad @Desc = 'DEPOSITOS'
EXEC CASI_COMPILA.Agregar_Funcionalidad @Desc = 'RETIRO DE EFECTIVO'
EXEC CASI_COMPILA.Agregar_Funcionalidad @Desc = 'TRANSFERENCIAS ENTRE CUENTAS'
EXEC CASI_COMPILA.Agregar_Funcionalidad @Desc = 'FACTURACION DE COSTOS'
EXEC CASI_COMPILA.Agregar_Funcionalidad @Desc = 'CONSULTA DE SALDOS'
EXEC CASI_COMPILA.Agregar_Funcionalidad @Desc = 'LISTADO ESTADISTICO'

GO

--Como es muchos a muchos, se crea una tabla intermedia

CREATE TABLE CASI_COMPILA.Funcionalidades_Roles(
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

INSERT INTO CASI_COMPILA.Funcionalidades_Roles
(Rol_Cod, Func_Cod)
VALUES
(@Rol_Cod, @Func_Cod)

END 

GO

--Se asignan funcionalidades a los roles

--El administrador tiene todas las funcionalidades

DECLARE @Cod INT = 1

WHILE(@Cod <= 11)   --Cantidad de funcionalidades: 11 (es fijo)
BEGIN

EXEC CASI_COMPILA.Asociar_Rol_Func @Rol_Cod = 1, @Func_Cod = @Cod
SET @Cod = @Cod + 1

END

GO

EXEC CASI_COMPILA.Asociar_Rol_Func @Rol_Cod = 2, @Func_Cod = 4 --ABM de cuenta
EXEC CASI_COMPILA.Asociar_Rol_Func @Rol_Cod = 2, @Func_Cod = 5 --Asociar/Desasociar tarjetas de crédito
EXEC CASI_COMPILA.Asociar_Rol_Func @Rol_Cod = 2, @Func_Cod = 6 --Depositos
EXEC CASI_COMPILA.Asociar_Rol_Func @Rol_Cod = 2, @Func_Cod = 7 --Retiro de efectivo
EXEC CASI_COMPILA.Asociar_Rol_Func @Rol_Cod = 2, @Func_Cod = 8 --Transferencias entre cuentas
EXEC CASI_COMPILA.Asociar_Rol_Func @Rol_Cod = 2, @Func_Cod = 9 --Facturacion de costos
EXEC CASI_COMPILA.Asociar_Rol_Func @Rol_Cod = 2, @Func_Cod = 10 --Consulta de saldos


PRINT 'Tablas Funcionalidades y Funcionalidades_Rol creadas correctamente'

GO

-----------------------------------Usuarios----------------------------------------------

CREATE TABLE CASI_COMPILA.Usuarios(
	User_Cod NUMERIC(18,0) IDENTITY(1,1) PRIMARY KEY,
	User_Nombre VARCHAR(50) NOT NULL UNIQUE,
	User_Password VARCHAR(50) NOT NULL,
	User_Fecha_Creacion DATETIME NOT NULL,
	User_Fecha_Mod DATETIME NOT NULL,
	User_Preg_Secreta VARCHAR(255) NOT NULL,
	User_Resp_Secreta VARCHAR(255) NOT NULL,
	User_Cli_Codigo NUMERIC(18,0) UNIQUE FOREIGN KEY REFERENCES CASI_COMPILA.Clientes, --Puede ser null si es admin
	User_Estado BIT NOT NULL -- 1= ACTIVO 0 = INACTIVO
	)

GO

--Entre usuarios y roles hay una relacion muchos a muchos

CREATE TABLE CASI_COMPILA.Usuarios_Roles(
	User_Cod NUMERIC(18,0) NOT NULL FOREIGN KEY REFERENCES CASI_COMPILA.Usuarios,
	Rol_Cod TINYINT NOT NULL FOREIGN KEY REFERENCES CASI_COMPILA.Roles,
	PRIMARY KEY (User_Cod, Rol_Cod),
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

INSERT INTO CASI_COMPILA.Usuarios_Roles
(User_Cod, Rol_Cod, User_Rol_Estado)
VALUES
(@Usuario, @Rol, 1) --Se asume que cuando se asigna un rol este se activa por defecto

END

GO

CREATE PROCEDURE CASI_COMPILA.Alta_Usuario
(@Nombre VARCHAR(50), @Password VARCHAR(50), @User_Rol TINYINT, @PregSecreta VARCHAR(255), 
@RespSecreta VARCHAR(255), @Cliente NUMERIC(18,0) = NULL) --Si es admin y no es cliente, no se ingresa el parametro
														  --Inicialmente tiene un solo rol, despues se pueden agregar mas
AS
BEGIN

INSERT INTO CASI_COMPILA.Usuarios
(User_Nombre, User_Password, User_Fecha_Creacion, User_Fecha_Mod, User_Preg_Secreta, User_Resp_Secreta, User_Cli_Codigo,User_Estado)
VALUES
(@Nombre, @Password, GETDATE(), GETDATE(), @PregSecreta, @RespSecreta, @Cliente, 1) --Cuando se cre, por defecto esta activado

DECLARE @User_Cod NUMERIC(18,0) = SCOPE_IDENTITY() --Obtiene el ultimo codigo de usuario generado

EXEC CASI_COMPILA.Asignar_Rol_Usuario @Usuario = @User_Cod, @Rol = @User_Rol

END

GO

CREATE PROCEDURE CASI_COMPILA.Baja_Usuario
(@User_Cod NUMERIC(18,0))
AS
BEGIN

UPDATE CASI_COMPILA.Usuarios  SET User_Estado = 0, User_Fecha_Mod = GETDATE() WHERE User_Cod = @User_Cod

END

GO

--Se crea el usuario admin pedido

EXEC CASI_COMPILA.Alta_Usuario @Nombre = 'admin', @Password = 'w23e', @User_Rol = 1,
@PregSecreta = '', @RespSecreta = ''

------------------------------------Monedas--------------------------------------------

CREATE TABLE CASI_COMPILA.Monedas(
	Moneda_Codigo TINYINT IDENTITY(1,1) PRIMARY KEY,
	Moneda_Desc VARCHAR(15) NOT NULL UNIQUE
)

GO

CREATE PROCEDURE CASI_COMPILA.Nueva_Moneda
(@Desc VARCHAR(15))
AS
BEGIN

INSERT INTO CASI_COMPILA.Monedas
(Moneda_Desc)
VALUES
(@Desc)

END

GO

--Por ahora, la unica moneda es el dolar

EXEC CASI_COMPILA.Nueva_Moneda @Desc = 'DOLAR'

PRINT 'Tabla Monedas creada correctamente'

GO		

-----------------------------------Cuentas---------------------------------------------

--Tipos de cuentas (Consultar por los tipos de cuentas de la tabla maestra, ver que se asume)

CREATE TABLE CASI_COMPILA.Tipos_Cuentas(
	Tipo_Cod TINYINT IDENTITY(1,1) PRIMARY KEY,
	Tipo_Nombre VARCHAR(50) NOT NULL UNIQUE,
	Tipo_Dias_Duracion SMALLINT NOT NULL,
	Tipo_Costo NUMERIC(10,2)
)

GO

--Posibles estados de una cuenta

CREATE TABLE CASI_COMPILA.Estados_Cuentas(
	Estado_Codigo TINYINT IDENTITY(1,1) PRIMARY KEY,
	Estado_Desc VARCHAR(25) NOT NULL UNIQUE
)

GO

CREATE PROCEDURE CASI_COMPILA.Agregar_Estado_Cuenta
(@Desc VARCHAR(25))
AS
BEGIN

INSERT INTO CASI_COMPILA.Estados_Cuentas
(Estado_Desc)
VALUES
(@Desc)

END

GO

EXEC CASI_COMPILA.Agregar_Estado_Cuenta @Desc = 'PENDIENTE DE ACTIVACION'
EXEC CASI_COMPILA.Agregar_Estado_Cuenta @Desc = 'CERRADA'
EXEC CASI_COMPILA.Agregar_Estado_Cuenta @Desc = 'INHABILITADA'
EXEC CASI_COMPILA.Agregar_Estado_Cuenta @Desc = 'HABILITADA'

GO

--REVISAR!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

CREATE TABLE CASI_COMPILA.Cuentas(
	Cuenta_Numero NUMERIC(18,0) PRIMARY KEY,
	Cuenta_Fecha_Creacion DATETIME NOT NULL,
	Cuenta_Estado_Cod TINYINT NOT NULL FOREIGN KEY REFERENCES CASI_COMPILA.Estados_Cuentas,
	Cuenta_Pais_Codigo  NUMERIC(18,0) NOT NULL FOREIGN KEY REFERENCES CASI_COMPILA.Paises,
	Cuenta_Fecha_Cierre DATETIME,
	Cuenta_Cli_Codigo NUMERIC(18,0) NOT NULL FOREIGN KEY REFERENCES CASI_COMPILA.Clientes,
	Cuenta_Tipo_Cod TINYINT FOREIGN KEY REFERENCES CASI_COMPILA.Tipos_Cuentas, --Tendria que ser NOT NULL, lo dejo asi xq en la tabla maestra no estan los tipos asociados a cada cuenta
	Cuenta_Moneda_Codigo TINYINT NOT NULL FOREIGN KEY REFERENCES CASI_COMPILA.Monedas
	)
	
GO

PRINT 'Tabla Cuentas creada correctamente'
	
--Hay que cargar los datos de la tabla!!!!

GO

-------------------------------------------Tarjetas----------------------------------------

CREATE TABLE CASI_COMPILA.Emisores_Tarjetas(
	Emisor_Cod TINYINT IDENTITY(1,1) PRIMARY KEY,
	Emisor_Desc VARCHAR(255) NOT NULL UNIQUE
)

GO

--Se cargan los emisores desde la tabla maestra

INSERT INTO CASI_COMPILA.Emisores_Tarjetas
(Emisor_Desc)
SELECT DISTINCT Tarjeta_Emisor_Descripcion FROM gd_esquema.Maestra WHERE Tarjeta_Emisor_Descripcion IS NOT NULL

GO

PRINT 'Tabla emisores de tarjetas creada correctamente'

CREATE TABLE CASI_COMPILA.Tarjetas(
	Tarjeta_Numero VARCHAR(16) PRIMARY KEY,
	Tarj_Emisor_Cod TINYINT NOT NULL FOREIGN KEY REFERENCES CASI_COMPILA.Emisores_Tarjetas,
	Tarjeta_Fecha_Emision DATETIME NOT NULL,
	Tarjeta_Fecha_Vencimiento DATETIME NOT NULL,
	Tarjeta_Codigo_Seg VARCHAR(3) NOT NULL,
	Tarj_Cli_Codigo NUMERIC(18,0) NOT NULL FOREIGN KEY REFERENCES CASI_COMPILA.Clientes
)


--Falta levantar los datos de las tarjetas

PRINT 'Tabla Tarjetas creada correctamente'

GO

--------------------------------------Transferencias---------------------------------------

CREATE TABLE CASI_COMPILA.Transferencias(
	Transf_Cod NUMERIC(18,0) IDENTITY(1,1) PRIMARY KEY,
	Transf_Cta_Origen NUMERIC(18,0) NOT NULL FOREIGN KEY REFERENCES CASI_COMPILA.Cuentas,
	Transf_Cta_Dest NUMERIC(18,0) NOT NULL FOREIGN KEY REFERENCES CASI_COMPILA.Cuentas,
	Transf_Fecha DATETIME NOT NULL,
	Tranf_Importe NUMERIC(18,2) NOT NULL,
	Tranf_Costo NUMERIC(18,2)
)

--Falta cargar las transferencias de la tabla maestra


PRINT 'Tabla transferencias creada correctamente'





	

