-- Drop the existing objects if needed
IF OBJECT_ID('InsertContainersData', 'P') IS NOT NULL
    DROP PROCEDURE InsertContainersData;

IF OBJECT_ID('ContainersDataTable', 'U') IS NOT NULL
    DROP TABLE ContainersDataTable;

CREATE TABLE ContainersDataTable (
    carrier VARCHAR(255),
    plate VARCHAR(255),
    location VARCHAR(255),
    company VARCHAR(255),
    producer VARCHAR(255),
    wasteType VARCHAR(255),
    operationType VARCHAR(255),
    quantity VARCHAR(255)
);




CREATE PROCEDURE InsertContainersData
	@carrier VARCHAR(255),
    @plate VARCHAR(255),
    @location VARCHAR(255),
    @company VARCHAR(255),
    @producer VARCHAR(255),
    @wasteType VARCHAR(255),
    @operationType VARCHAR(255),
    @quantity VARCHAR(255)

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
     
        IF (@producer = 'no ingresado') BEGIN
            RAISERROR('You must enter the producer', 16, 1)
        END

		IF (@wasteType = 'no ingresado') BEGIN
            RAISERROR('You must enter the waste type', 16, 1)
        END

		IF (@operationType = 'no ingresado') BEGIN
            RAISERROR('You must enter the operation type', 16, 1)
        END

		IF (@quantity = 'no ingresado') BEGIN
            RAISERROR('You must enter the container quantity', 16, 1)

        END

        INSERT INTO ContainersDataTable (carrier, plate, location, company, producer, wasteType, operationType, quantity)
		VALUES (@carrier, @plate, @location, @company, @producer,@wasteType, @operationType, @quantity)
      


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