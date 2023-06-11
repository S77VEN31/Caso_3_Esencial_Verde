-- a) demuestre que es posible tener SP encriptados y que un atacante no va a poder ver el código del mismo tip 
SELECT O.name, M.definition, O.type_desc, O.type 
FROM sys.sql_modules M 
INNER JOIN sys.objects O ON M.object_id=O.object_id 
WHERE O.type IN ('P');
GO

sp_HelpText GetLastNContactsByType;


DROP PROCEDURE IF EXISTS GetLastNContactsByType
GO

CREATE PROCEDURE GetLastNContactsByType
    @contactType VARCHAR(255),
    @N INT
WITH ENCRYPTION
AS
BEGIN
    SELECT TOP (@N)
        contactId,
        name,
        surname1,
        surname2,
        email,
        phone,
        notes,
        contactType,
        active,
        createAt,
        updateAt,
        CHECKSUM
    FROM contacts
    WHERE contactType = @contactType
    ORDER BY createAt DESC;
END;
GO

ALTER PROC GetLastNContactsByType
    @contactType VARCHAR(255),
    @N INT
AS
BEGIN
    SELECT TOP (@N)
        contactId,
        name,
        surname1,
        surname2,
        email,
        phone,
        notes,
        contactType,
        active,
        createAt,
        updateAt,
        CHECKSUM
    FROM contacts
    WHERE contactType = @contactType
    ORDER BY createAt DESC;
END;
GO

ALTER PROC GetLastNContactsByType
    @contactType VARCHAR(255),
    @N INT
WITH ENCRYPTION
AS
BEGIN
    SELECT TOP (@N)
        contactId,
        name,
        surname1,
        surname2,
        email,
        phone,
        notes,
        contactType,
        active,
        createAt,
        updateAt,
        CHECKSUM
    FROM contacts
    WHERE contactType = @contactType
    ORDER BY createAt DESC;
END;


-- b) por medio de un script asegúrese que un schemabinding nos proteje la lógica de negocios de la base de datos ante cambios estructurales en las tablas 
IF OBJECT_ID('dbo.VistaRelacionada', 'V') IS NOT NULL
    DROP VIEW dbo.VistaRelacionada;
GO
CREATE VIEW dbo.VistaRelacionada
WITH SCHEMABINDING
AS
SELECT c.name AS countryName, s.name AS stateName, ci.name AS cityName, l.latitude, l.longitude, r.name AS regionName
FROM dbo.countries AS c
INNER JOIN dbo.states AS s ON c.countryId = s.countryId
INNER JOIN dbo.cities AS ci ON s.stateId = ci.stateId
INNER JOIN dbo.locations AS l ON ci.cityId = l.cityId
INNER JOIN dbo.regionAreas AS ra ON ci.cityId = ra.cityId
INNER JOIN dbo.regions AS r ON ra.regionAreasId = r.regionAreaId;
GO
ALTER TABLE dbo.cities
DROP COLUMN name;

-- c) cree dos jobs del sistema, uno que recompile todos los stored procedures, sacando la lista de los mismos de las vistas del sistema, y que eso lo haga 1 vez por semana. 
DECLARE @ProcedureName nvarchar(max)

SELECT @ProcedureName = COALESCE(@ProcedureName + ';', '') + 'EXEC sp_recompile ''' + QUOTENAME(s.name) + '.' + QUOTENAME(o.name) + ''''
FROM sys.objects o
INNER JOIN sys.schemas s ON o.schema_id = s.schema_id
WHERE o.type = 'P'

EXEC sp_executesql @ProcedureName

-- Finalmente, otro que se encargue de pasar los registros de la bitácora del sistema a una bitácora gemela en un linked server,
EXEC sp_addlinkedserver
  @server = 'LinkedServer',
  @srvproduct = '',
  @provider = 'SQLNCLI',
  @datasrc = 'JPablix\MSSQLSERVER01'

INSERT INTO LinkedServer.caso3_test.dbo.eventLogs
(date, time, eventTypeId, eventSourceId, eventStatusId, logMessage, logDetails)
SELECT date, time, eventTypeId, eventSourceId, eventStatusId, logMessage, logDetails
FROM caso3.dbo.eventLogs;


DELETE FROM caso3.dbo.eventLogs WHERE eventId > 0;