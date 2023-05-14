-- Drop the existing objects if needed
IF OBJECT_ID('InsertContainersData', 'P') IS NOT NULL
    DROP PROCEDURE InsertContainersData;

IF OBJECT_ID('containersData', 'TT') IS NOT NULL
    DROP TYPE containersData;


-- Recreate the type and procedure
IF NOT EXISTS (SELECT * FROM sys.types WHERE name = 'containersData' AND is_table_type = 1)
BEGIN
    CREATE TYPE containersData AS TABLE (
        carrier VARCHAR(500),
        plate VARCHAR(500),
        location VARCHAR(500),
        company VARCHAR(500),
        producer VARCHAR(500),
        wasteType VARCHAR(500),
        operationType VARCHAR(500),
        quantity VARCHAR(500)
    );
END
GO

CREATE PROCEDURE InsertContainersData
    @containersData containersData READONLY
AS
BEGIN

    SET NOCOUNT ON -- Do not return metadata

    DECLARE @ErrorNumber INT, @ErrorSeverity INT, @ErrorState INT, @CustomError INT
	DECLARE @Message VARCHAR(200)
	DECLARE @InicieTransaccion BIT
    -- Declaracion de otras variables
    -- Variables para la recoleccion

    DECLARE @Now DATETIME

    INSERT INTO ContainersDataTable (carrier, plate, location, company, producer, wasteType, operationType, quantity)
    SELECT carrier, plate, location, company, producer, wasteType, operationType, quantity
    FROM @containersData;
END;
GO

SELECT * FROM ContainersDataTable;
DELETE FROM ContainersDataTable