-- Drop the existing objects if needed
IF OBJECT_ID('InsertContainersData', 'P') IS NOT NULL
    DROP PROCEDURE InsertContainersData;

IF OBJECT_ID('containersData', 'TT') IS NOT NULL
    DROP TYPE containersData;

IF OBJECT_ID('ContainersDataTable', 'U') IS NOT NULL
    DROP TABLE ContainersDataTable;

CREATE TABLE ContainersDataTable (
    carrier VARCHAR(500),
    plate VARCHAR(500),
    location VARCHAR(500),
    company VARCHAR(500),
    producer VARCHAR(500),
    wasteType VARCHAR(500),
    operationType VARCHAR(500),
    quantity VARCHAR(500)
);

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
    
    
    

    SET @InicieTransaccion = 0
	IF @@TRANCOUNT=0 BEGIN
		SET @InicieTransaccion = 1
		SET TRANSACTION ISOLATION LEVEL READ COMMITTED
		BEGIN TRANSACTION		
	END

    BEGIN TRY
		SET @CustomError = 2001

        
		
		IF NOT EXISTS (
            SELECT *
            FROM @containersData
        ) BEGIN
            RAISERROR('No hay recipientes para registrar', 16, 1)
        END

        IF (SELECT COUNT(*) FROM @containersData WHERE Producer = 'no ingresado') != 0 BEGIN
            RAISERROR('Debe ingresar el productor', 16, 1)
        END

        INSERT INTO ContainersDataTable (carrier, plate, location, company, producer, wasteType, operationType, quantity)
        SELECT carrier, plate, location, company, producer, wasteType, operationType, quantity
        FROM @containersData;


		IF @InicieTransaccion=1 BEGIN
			COMMIT
		END
	END TRY
	BEGIN CATCH
		SET @ErrorNumber = ERROR_NUMBER()
		SET @ErrorSeverity = ERROR_SEVERITY()
		SET @ErrorState = ERROR_STATE()
		SET @Message = ERROR_MESSAGE()
		
		IF @InicieTransaccion=1 BEGIN
			ROLLBACK
		END
		RAISERROR('%s - Error Number: %i', 
			@ErrorSeverity, @ErrorState, @Message, @CustomError)
	END CATCH	


    
END;
RETURN 0
GO

SELECT * FROM ContainersDataTable;
