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
IF OBJECT_ID ('CASI_COMPILA.Documentos') IS NOT NULL DROP TABLE CASI_COMPILA.Documentos
IF OBJECT_ID ('CASI_COMPILA.Estados_Cuentas') IS NOT NULL DROP TABLE CASI_COMPILA.Estados_Cuentas
IF OBJECT_ID ('CASI_COMPILA.Monedas') IS NOT NULL DROP TABLE CASI_COMPILA.Monedas
IF OBJECT_ID ('CASI_COMPILA.Tipos_Cuentas') IS NOT NULL DROP TABLE CASI_COMPILA.Tipos_Cuentas
IF OBJECT_ID ('CASI_COMPILA.Depositos') IS NOT NULL DROP TABLE CASI_COMPILA.Depositos
IF OBJECT_ID ('CASI_COMPILA.Funcionalidades_Roles') IS NOT NULL DROP TABLE CASI_COMPILA.Funcionalidades_Roles
IF OBJECT_ID ('CASI_COMPILA.Funcionalidades') IS NOT NULL DROP TABLE CASI_COMPILA.Funcionalidades
IF OBJECT_ID ('CASI_COMPILA.Auditoria_Login') IS NOT NULL DROP TABLE CASI_COMPILA.Auditoria_Login
IF OBJECT_ID ('CASI_COMPILA.Usuarios_Roles') IS NOT NULL DROP TABLE CASI_COMPILA.Usuarios_Roles
IF OBJECT_ID ('CASI_COMPILA.Usuarios') IS NOT NULL DROP TABLE CASI_COMPILA.Usuarios
IF OBJECT_ID ('CASI_COMPILA.Roles') IS NOT NULL DROP TABLE CASI_COMPILA.Roles
IF OBJECT_ID ('CASI_COMPILA.Tarjetas') IS NOT NULL DROP TABLE CASI_COMPILA.Tarjetas
IF OBJECT_ID ('CASI_COMPILA.Emisores_Tarjetas') IS NOT NULL DROP TABLE CASI_COMPILA.Emisores_Tarjetas
IF OBJECT_ID ('CASI_COMPILA.Clientes') IS NOT NULL DROP TABLE CASI_COMPILA.Clientes
IF OBJECT_ID ('CASI_COMPILA.Administradores') IS NOT NULL DROP TABLE CASI_COMPILA.Administradores
IF OBJECT_ID ('CASI_COMPILA.Paises') IS NOT NULL DROP TABLE CASI_COMPILA.Paises
IF OBJECT_ID ('CASI_COMPILA.Tipos_Documento') IS NOT NULL DROP TABLE CASI_COMPILA.Tipos_Documento
IF OBJECT_ID ('CASI_COMPILA.Bancos') IS NOT NULL DROP TABLE CASI_COMPILA.Bancos
IF OBJECT_ID ('CASI_COMPILA.Cheques') IS NOT NULL DROP TABLE CASI_COMPILA.Cheques
IF OBJECT_ID ('CASI_COMPILA.Retiros') IS NOT NULL DROP TABLE CASI_COMPILA.Retiros
IF OBJECT_ID ('CASI_COMPILA.Comisiones') IS NOT NULL DROP TABLE CASI_COMPILA.Comisiones
IF OBJECT_ID ('CASI_COMPILA.Facturas') IS NOT NULL DROP TABLE CASI_COMPILA.Facturas
IF OBJECT_ID ('CASI_COMPILA.Asociar_Rol_Func') IS NOT NULL DROP PROCEDURE CASI_COMPILA.Asociar_Rol_Func
IF OBJECT_ID ('CASI_COMPILA.Nuevo_Rol') IS NOT NULL DROP PROCEDURE CASI_COMPILA.Nuevo_Rol
IF OBJECT_ID ('CASI_COMPILA.Alta_Usuario') IS NOT NULL DROP PROCEDURE CASI_COMPILA.Alta_Usuario
IF OBJECT_ID ('CASI_COMPILA.Baja_Usuario') IS NOT NULL DROP PROCEDURE CASI_COMPILA.Baja_Usuario
IF OBJECT_ID ('CASI_COMPILA.Asignar_Rol_Usuario') IS NOT NULL DROP PROCEDURE CASI_COMPILA.Asignar_Rol_Usuario
IF OBJECT_ID ('CASI_COMPILA.Nuevo_Doc') IS NOT NULL DROP PROCEDURE CASI_COMPILA.Nuevo_Doc
IF OBJECT_ID ('CASI_COMPILA.Nuevo_Cliente') IS NOT NULL DROP PROCEDURE CASI_COMPILA.Nuevo_Cliente
IF OBJECT_ID ('CASI_COMPILA.Nueva_Moneda') IS NOT NULL DROP PROCEDURE CASI_COMPILA.Nueva_Moneda
IF OBJECT_ID ('CASI_COMPILA.Agregar_Estado_Cuenta') IS NOT NULL DROP PROCEDURE CASI_COMPILA.Agregar_Estado_Cuenta
IF OBJECT_ID ('CASI_COMPILA.Agregar_Funcionalidad') IS NOT NULL DROP PROCEDURE CASI_COMPILA.Agregar_Funcionalidad
IF OBJECT_ID ('CASI_COMPILA.Cambiar_Estado') IS NOT NULL DROP FUNCTION CASI_COMPILA.Cambiar_Estado

PRINT 'Tablas eliminadas correctamente'

GO

--Se crean las tablas y se las carga con los datos correspondientes


--------------------------------Paises----------------------------------------------------

CREATE TABLE CASI_COMPILA.Paises (
	Pais_Codigo NUMERIC(18,0) IDENTITY PRIMARY KEY,
	Pais_Desc VARCHAR(250) NOT NULL UNIQUE
	)

PRINT 'Tabla CASI_COMPILA.Paises creada correctamente'

GO

----------------------------------Bancos------------------------------------------------

CREATE TABLE CASI_COMPILA.Bancos (
	Banco_Codigo NUMERIC(18,0) IDENTITY PRIMARY KEY,
	Banco_Nombre VARCHAR(255) NOT NULL,
	Banco_Direccion VARCHAR(255) NOT NULL,
	UNIQUE(Banco_Nombre, Banco_Direccion)
	)

PRINT 'Tabla CASI_COMPILA.Bancos creada correctamente'

GO

-------------------------------------Roles-----------------------------------------------

CREATE TABLE CASI_COMPILA.Roles(
	Rol_Cod NUMERIC(18,0) IDENTITY PRIMARY KEY,
	Rol_Nombre VARCHAR(50) NOT NULL UNIQUE,
	Rol_Estado BIT NOT NULL -- 1=ACTIVO 0=NO ACTIVO
)


/*

                              Supertipo = Roles
                                     |
                                     |
                                     |
                           |----------------------|
                           |                      |
                           |                      |
                           |                      | 
                   Subtipo=Clientes       Subtipo=Administradores

*/

PRINT 'Tabla CASI_COMPILA.Roles creada correctamente'

GO

-------------------------------------Documentos-------------------------------------------

CREATE TABLE CASI_COMPILA.Tipos_Documento (
	Tipo_Doc_Cod NUMERIC(18,0) IDENTITY PRIMARY KEY,
	Tipo_Doc_Desc VARCHAR(255) NOT NULL UNIQUE
	)
	
GO
	
CREATE TABLE CASI_COMPILA.Documentos(
	Doc_Cod NUMERIC(18,0) IDENTITY PRIMARY KEY,
	Doc_Num NUMERIC(15,0),
	Doc_Tipo_Cod NUMERIC(18,0) NOT NULL FOREIGN KEY REFERENCES CASI_COMPILA.Tipos_Documento,
	UNIQUE(Doc_Num,Doc_Tipo_Cod)
)

PRINT 'Tablas CASI_COMPILA.Tipos_Documento y CASI_COMPILA.Documentos creadas correctamente'

GO

----------------------------------Clientes---------------------------------------------


CREATE TABLE CASI_COMPILA.Clientes(
	Cli_Codigo NUMERIC(18,0) IDENTITY PRIMARY KEY REFERENCES CASI_COMPILA.Roles,
	Cli_Nombre VARCHAR(255) NOT NULL,
	Cli_Apellido VARCHAR(255) NOT NULL,
	Cli_Pais_Codigo NUMERIC(18,0) NOT NULL FOREIGN KEY REFERENCES CASI_COMPILA.Paises,
	Cli_Dom_Calle VARCHAR(255) NOT NULL,
	Cli_Dom_Nro NUMERIC(18,0) NOT NULL,
	Cli_Dom_Piso NUMERIC(18,0),
	Cli_Dom_Depto VARCHAR(10),
	Cli_Doc_Cod NUMERIC(18,0) NOT NULL FOREIGN KEY REFERENCES CASI_COMPILA.Documentos,
	Cli_Fecha_Nac DATETIME NOT NULL,
	Cli_Mail VARCHAR(255) NOT NULL UNIQUE
	)
	
PRINT 'Tabla CASI_COMPILA.Clientes creada correctamente'

GO 

----------------------------------Administradores---------------------------------------

CREATE TABLE CASI_COMPILA.Administradores(
	Admin_Cod NUMERIC(18,0) IDENTITY PRIMARY KEY REFERENCES CASI_COMPILA.Roles
	--Ver que poner aca
)

PRINT 'Tabla CASI_COMPILA.Administradores creada correctamente'

GO

-------------------------------Funcionalidades de los roles---------------------------------

CREATE TABLE CASI_COMPILA.Funcionalidades(
	Func_Cod SMALLINT IDENTITY PRIMARY KEY,
	Func_Desc VARCHAR(40) NOT NULL UNIQUE
)

GO

--Como es muchos a muchos, se crea una tabla intermedia

CREATE TABLE CASI_COMPILA.Funcionalidades_Roles(
	Rol_Cod NUMERIC(18,0) NOT NULL FOREIGN KEY REFERENCES CASI_COMPILA.Roles,
	Func_Cod SMALLINT NOT NULL FOREIGN KEY REFERENCES CASI_COMPILA.Funcionalidades,
	PRIMARY KEY (Rol_Cod, Func_Cod) --De esta forma, no se puede repetir la funcion dentro de un rol
)

PRINT 'Tablas CASI_COMPILA.Funcionalidades y CASI_COMPILA.Funcionalidades_Roles creadas correctamente'

GO

-----------------------------------Usuarios----------------------------------------------

CREATE TABLE CASI_COMPILA.Usuarios(
	User_Cod NUMERIC(18,0) IDENTITY PRIMARY KEY,
	User_Nombre VARCHAR(50) NOT NULL UNIQUE,
	User_Password VARCHAR(255),
	User_Fecha_Creacion DATETIME NOT NULL,
	User_Fecha_Mod DATETIME NOT NULL,
	User_Preg_Secreta VARCHAR(255),
	User_Resp_Secreta VARCHAR(255),
	User_Estado BIT NOT NULL, -- 1= ACTIVO 0 = INACTIVO
	User_Intentos_Restantes TINYINT NOT NULL,
	)

GO

--Entre usuarios y roles hay una relacion muchos a muchos

CREATE TABLE CASI_COMPILA.Usuarios_Roles(
	User_Cod NUMERIC(18,0) NOT NULL FOREIGN KEY REFERENCES CASI_COMPILA.Usuarios,
	Rol_Cod NUMERIC(18,0) NOT NULL FOREIGN KEY REFERENCES CASI_COMPILA.Roles,
	PRIMARY KEY (User_Cod, Rol_Cod),
	User_Rol_Estado BIT NOT NULL
)

GO

--Por cada cliente en la tabla de clientes, genero un usuario (nombre user = nombre + apellido en minuscula)

--Falta definir passwords y preg secreta

DECLARE @Cli_Cod NUMERIC(18,0)
DECLARE @Cli_Nombre VARCHAR(255)
DECLARE @Cli_Apellido VARCHAR(255)
DECLARE @User VARCHAR(255)
DECLARE Cli_Cursor CURSOR FOR SELECT c.Cli_Codigo, c.Cli_Nombre, c.Cli_Apellido FROM CASI_COMPILA.Clientes c

OPEN Cli_Cursor FETCH NEXT FROM Cli_Cursor INTO @Cli_Cod, @Cli_Nombre, @Cli_Apellido
WHILE @@FETCH_STATUS = 0
BEGIN
	SET @User = LOWER(@Cli_Nombre + @Cli_Apellido)
	EXEC CASI_COMPILA.Alta_Usuario @Nombre = @User, @Password = '',
	@User_Rol = 2, @PregSecreta = '', @RespSecreta = '', @Cliente = @Cli_Cod
	FETCH NEXT FROM Cli_Cursor INTO @Cli_Cod, @Cli_Nombre, @Cli_Apellido
END
CLOSE Cli_Cursor
DEALLOCATE Cli_Cursor

	
PRINT 'Tabla CASI_COMPILA.Usuarios y Tabla CASI_COMPILA.Usuarios_Roles creadas correctamente'

GO

------------------------------------Monedas--------------------------------------------

CREATE TABLE CASI_COMPILA.Monedas(
	Moneda_Codigo TINYINT IDENTITY PRIMARY KEY,
	Moneda_Desc VARCHAR(15) NOT NULL UNIQUE
)

PRINT 'Tabla CASI_COMPILA.Monedas creada correctamente'

GO

-----------------------------------Cuentas---------------------------------------------


CREATE TABLE CASI_COMPILA.Tipos_Cuentas(         --revisar
	Tipo_Cod TINYINT IDENTITY PRIMARY KEY,
	Tipo_Nombre VARCHAR(50) NOT NULL UNIQUE,
	Tipo_Dias_Duracion SMALLINT NOT NULL,
	Tipo_Costo NUMERIC(10,2)
)

GO

--Posibles estados de una cuenta

CREATE TABLE CASI_COMPILA.Estados_Cuentas(
	Estado_Codigo TINYINT IDENTITY PRIMARY KEY,
	Estado_Desc VARCHAR(25) NOT NULL UNIQUE
)

GO


CREATE TABLE CASI_COMPILA.Cuentas(
	Cuenta_Numero NUMERIC(18,0) PRIMARY KEY,
	Cuenta_Fecha_Creacion DATETIME NOT NULL,
	Cuenta_Estado_Cod TINYINT NOT NULL FOREIGN KEY REFERENCES CASI_COMPILA.Estados_Cuentas,
	Cuenta_Pais_Codigo  NUMERIC(18,0) NOT NULL FOREIGN KEY REFERENCES CASI_COMPILA.Paises,
	Cuenta_Fecha_Cierre DATETIME,
	Cuenta_Cli_Codigo NUMERIC(18,0) NOT NULL FOREIGN KEY REFERENCES CASI_COMPILA.Clientes,
	Cuenta_Tipo_Cod TINYINT NOT NULL FOREIGN KEY REFERENCES CASI_COMPILA.Tipos_Cuentas,
	Cuenta_Moneda_Codigo TINYINT NOT NULL FOREIGN KEY REFERENCES CASI_COMPILA.Monedas
	)
	
GO

PRINT 'Tabla CASI_COMPILA.Cuentas, CASI_COMPILA.Tipos_Cuentas y CASI_COMPILA.Estados_Cuentas creadas correctamente'

GO

-------------------------------------------Tarjetas----------------------------------------

CREATE TABLE CASI_COMPILA.Emisores_Tarjetas(
	Emisor_Cod TINYINT IDENTITY PRIMARY KEY,
	Emisor_Desc VARCHAR(255) NOT NULL UNIQUE
)

GO

CREATE TABLE CASI_COMPILA.Tarjetas(
	Tarjeta_Cod NUMERIC(18,0) IDENTITY PRIMARY KEY,
	Tarjeta_Numero VARCHAR(16) NOT NULL,
	Tarjeta_Emisor_Cod TINYINT NOT NULL FOREIGN KEY REFERENCES CASI_COMPILA.Emisores_Tarjetas,
	Tarjeta_Fecha_Emision DATETIME NOT NULL,
	Tarjeta_Fecha_Vencimiento DATETIME NOT NULL,
	Tarjeta_Codigo_Seg VARCHAR(3) NOT NULL,
	Tarjeta_Cli_Codigo NUMERIC(18,0) NOT NULL FOREIGN KEY REFERENCES CASI_COMPILA.Clientes,
	UNIQUE(Tarjeta_Numero, Tarjeta_Emisor_Cod),
)

PRINT 'Tabla CASI_COMPILA.Tarjetas y CASI_COMPILA.Emisores_Tarjetas creadas correctamente'

GO

--------------------------------------Transferencias---------------------------------------

CREATE TABLE CASI_COMPILA.Transferencias(
	Transf_Cod NUMERIC(18,0) IDENTITY(1,1) PRIMARY KEY,
	Transf_Cta_Origen NUMERIC(18,0) NOT NULL FOREIGN KEY REFERENCES CASI_COMPILA.Cuentas,
	Transf_Cta_Dest NUMERIC(18,0) NOT NULL FOREIGN KEY REFERENCES CASI_COMPILA.Cuentas,
	Transf_Fecha DATETIME NOT NULL,
	Tranf_Importe NUMERIC(18,2) NOT NULL,
	Tranf_Costo NUMERIC(18,2) NOT NULL
)


PRINT 'Tabla CASI_COMPILA.Transferencias creada correctamente'

GO

----------------------------------------Depositos------------------------------------------

CREATE TABLE CASI_COMPILA.Depositos(
	Deposito_Codigo NUMERIC(18,0) IDENTITY(1,1) PRIMARY KEY,
	Deposito_Fecha DATETIME NOT NULL,
	Deposito_Importe NUMERIC(18,2) NOT NULL,
	Deposito_Moneda_Cod TINYINT NOT NULL FOREIGN KEY REFERENCES CASI_COMPILA.Monedas,
	Deposito_Tarjeta_Cod NUMERIC(18,0) NOT NULL FOREIGN KEY REFERENCES CASI_COMPILA.Tarjetas,
	Deposito_Cuenta_Numero NUMERIC(18,0) NOT NULL REFERENCES CASI_COMPILA.Cuentas
)

PRINT 'Tabla CASI_COMPILA.Depositos creada correctamente'

GO

-----------------------------------------Cheques-------------------------------------------

CREATE TABLE CASI_COMPILA.Cheques(
	Cheque_Numero NUMERIC(18,0) IDENTITY(1,1) PRIMARY KEY,
	Cheque_Fecha DATETIME NOT NULL,
	Cheque_Importe NUMERIC(18,2) NOT NULL,
	Cheque_Banco_Codigo NUMERIC(18,0) NOT NULL FOREIGN KEY REFERENCES CASI_COMPILA.Bancos
)

PRINT 'Tabla CASI_COMPILA.Cheques creada correctamente'

GO

------------------------------------------Retiros-------------------------------------------

CREATE TABLE CASI_COMPILA.Retiros(
	Retiro_Codigo NUMERIC(18,0) IDENTITY(1,1) PRIMARY KEY,
	Retiro_Fecha DATETIME NOT NULL,
	Retiro_Importe NUMERIC(18,2) NOT NULL,
	Retiro_Cheque_Numero NUMERIC(18,0) NOT NULL FOREIGN KEY REFERENCES CASI_COMPILA.Cheques,
	Retiro_Cuenta_Numero NUMERIC(18,0) NOT NULL REFERENCES CASI_COMPILA.Cuentas
)

PRINT 'Tabla CASI_COMPILA.Retiros creada correctamente'

GO

-------------------------------------------Facturas----------------------------------------

CREATE TABLE CASI_COMPILA.Facturas(
	Factura_Num NUMERIC(18,0) IDENTITY(1,1) PRIMARY KEY,
	Factura_Cuenta_Numero NUMERIC(18,0) NOT NULL REFERENCES CASI_COMPILA.Cuentas,
	Factura_Monto NUMERIC(18,0) NOT NULL,
	Factura_Pagada BIT NOT NULL  --NO PAGADA=0    PAGADA=1
)

PRINT 'Tabla CASI_COMPILA.Facturas creada correctamente'

GO

------------------------------------------Comisiones---------------------------------------

CREATE TABLE CASI_COMPILA.Comisiones(
	Comision_Codigo NUMERIC(18,0) IDENTITY(1,1) PRIMARY KEY,
	Comision_Monto NUMERIC(18,2) NOT NULL,
	Comision_Desc VARCHAR(50) NOT NULL,
	Comision_Factura_Num NUMERIC(18,0) NOT NULL FOREIGN KEY REFERENCES CASI_COMPILA.Facturas
)

PRINT 'Tabla CASI_COMPILA.Comisiones creada correctamente'


GO

-----------------------------------------Auditoria login-----------------------------------

CREATE TABLE CASI_COMPILA.Auditoria_Login(
	Login_Cod NUMERIC(18,0) IDENTITY(1,1) PRIMARY KEY,
	Login_Usuario VARCHAR(255) NOT NULL,
	Login_Fecha DATETIME NOT NULL,
	
	--FALTAN COSAS
)

PRINT 'Tabla ASI_COMPILA.Auditoria_Login creada correctamente'

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


------------------------------------------Procedures-----------------------------------------

CREATE PROCEDURE CASI_COMPILA.Nuevo_Rol(@Nombre VARCHAR(50))
AS
BEGIN
	INSERT INTO CASI_COMPILA.Roles
	(Rol_Nombre, Rol_Estado)
	VALUES
	(@Nombre, 1)
END

GO

CREATE PROCEDURE CASI_COMPILA.Nuevo_Doc(@Num NUMERIC(15,0) = NULL, @Tipo NUMERIC(18,0))
AS
BEGIN
	INSERT INTO CASI_COMPILA.Documentos
	(Doc_Num, Doc_Tipo_Cod)
	VALUES
	(@Num, @Tipo)
END

GO

CREATE PROCEDURE CASI_COMPILA.Nuevo_Cliente(@Nom VARCHAR(255), @Apell VARCHAR(255), @Pais NUMERIC(18,0), 
@Calle VARCHAR(255), @Nro NUMERIC(18,0), @Piso NUMERIC(18,0), @Depto VARCHAR(10), @Doc NUMERIC(18,0), 
@Nac DATETIME, @Mail VARCHAR(255))
AS
BEGIN
	INSERT INTO CASI_COMPILA.Clientes
	(Cli_Nombre, Cli_Apellido, Cli_Pais_Codigo, Cli_Dom_Calle, Cli_Dom_Nro, Cli_Dom_Piso, Cli_Dom_Depto, 
	Cli_Doc_Cod, Cli_Fecha_Nac, Cli_Mail)
	VALUES
	(@Nom, @Apell, @Pais, @Calle, @Nro, @Piso, @Depto, @Doc, @Nac, @Mail)
END

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

CREATE PROCEDURE CASI_COMPILA.Asociar_Rol_Func
(@Rol_Cod NUMERIC(18,0), @Func_Cod SMALLINT)
AS
BEGIN

	INSERT INTO CASI_COMPILA.Funcionalidades_Roles
	(Rol_Cod, Func_Cod)
	VALUES
	(@Rol_Cod, @Func_Cod)

END 

GO

CREATE PROCEDURE CASI_COMPILA.Alta_Usuario --El password y la respuesta secreta deben llegar encriptadas
(@Nombre VARCHAR(50), @Password VARCHAR(50) = NULL, @PregSecreta VARCHAR(255) = NULL, 
@RespSecreta VARCHAR(255) = NULL)								
AS
BEGIN

	DECLARE @Fecha DATETIME = GETDATE()

	INSERT INTO CASI_COMPILA.Usuarios
	(User_Nombre, User_Password, User_Fecha_Creacion, User_Fecha_Mod, User_Preg_Secreta, 
	User_Resp_Secreta, User_Estado, User_Intentos_Restantes)
	VALUES
	(@Nombre, @Password, @Fecha, @Fecha, @PregSecreta, @RespSecreta, 1, 0)

END

GO

CREATE PROCEDURE CASI_COMPILA.Baja_Usuario
(@User_Cod NUMERIC(18,0))
AS
BEGIN

	UPDATE CASI_COMPILA.Usuarios  SET User_Estado = 0, User_Fecha_Mod = GETDATE() WHERE User_Cod = @User_Cod

END

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
------------------------------------------Carga de datos-----------------------------------

	
--Paises

SET IDENTITY_INSERT CASI_COMPILA.Paises ON

INSERT INTO CASI_COMPILA.Paises
(Pais_Codigo, Pais_Desc)
SELECT * FROM (SELECT Cli_Pais_Codigo, Cli_Pais_Desc FROM gd_esquema.Maestra 
UNION SELECT Cuenta_Pais_Codigo, Cuenta_Pais_Desc FROM gd_esquema.Maestra) AS P

SET IDENTITY_INSERT CASI_COMPILA.Paises OFF

GO

--Tipos Documentos

SET IDENTITY_INSERT CASI_COMPILA.Tipos_Documento ON

INSERT INTO CASI_COMPILA.Tipos_Documento
(Tipo_Doc_Cod, Tipo_Doc_Desc)
SELECT DISTINCT Cli_Tipo_Doc_Cod, Cli_Tipo_Doc_Desc FROM gd_esquema.Maestra

SET IDENTITY_INSERT CASI_COMPILA.Tipos_Documento OFF

GO

--Bancos

SET IDENTITY_INSERT CASI_COMPILA.Bancos ON

INSERT INTO CASI_COMPILA.Bancos
(Banco_Codigo, Banco_Nombre, Banco_Direccion)
SELECT DISTINCT Banco_Cogido, Banco_Nombre, Banco_Direccion 
FROM gd_esquema.Maestra WHERE Banco_Cogido IS NOT NULL

SET IDENTITY_INSERT CASI_COMPILA.Bancos OFF

GO

--Funcionalidades

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

--Monedas

EXEC CASI_COMPILA.Nueva_Moneda @Desc = 'DOLAR'


GO	

--Estados de las cuentas

EXEC CASI_COMPILA.Agregar_Estado_Cuenta @Desc = 'PENDIENTE DE ACTIVACION'
EXEC CASI_COMPILA.Agregar_Estado_Cuenta @Desc = 'CERRADA'
EXEC CASI_COMPILA.Agregar_Estado_Cuenta @Desc = 'INHABILITADA'
EXEC CASI_COMPILA.Agregar_Estado_Cuenta @Desc = 'HABILITADA'

GO

--Emisores de tarjetas

INSERT INTO CASI_COMPILA.Emisores_Tarjetas
(Emisor_Desc)
SELECT DISTINCT Tarjeta_Emisor_Descripcion FROM gd_esquema.Maestra WHERE Tarjeta_Emisor_Descripcion IS NOT NULL

GO

--Se crea el usuario admin pedido (pass y respuesta secreta con encriptacion SHA256)

EXEC CASI_COMPILA.Alta_Usuario @Nombre = 'admin', 
@Password = 'E6-B8-70-50-BF-CB-81-43-FC-B8-DB-01-70-A4-DC-9E-D0-0D-90-4D-DD-3E-2A-4A-D1-B1-E8-DC-0F-DC-9B-E7',  --w23e
@PregSecreta = '¿Que dia cursa gestion de datos?', 
@RespSecreta = 'DB-30-E7-7B-9F-80-EA-07-07-DA-0C-71-D1-1F-99-35-93-5D-F5-98-90-F3-89-95-C0-6E-BE-06-2B-27-32-56' --sabado



GO
