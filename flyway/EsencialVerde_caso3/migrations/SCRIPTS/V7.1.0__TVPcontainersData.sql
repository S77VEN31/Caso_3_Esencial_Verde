-----------------------------------------------------------
-- Autor: joseGranados & stivenGuzman
-- Fecha: 15/05/2023
-- Descripcion: PROCEDURE to the insertion of the trazability of containers and exchange of containers 
-----------------------------------------------------------
-- Drop the existing objects if needed
IF OBJECT_ID('InsertContainersData', 'P') IS NOT NULL
    DROP PROCEDURE InsertContainersData;
GO
CREATE PROCEDURE InsertContainersData
	@carrier VARCHAR(255),
    @plate VARCHAR(255),
    @location VARCHAR(255),
    @company VARCHAR(255),
    @producer VARCHAR(255),
    @wasteType VARCHAR(255),
    @operationType VARCHAR(255),
    @quantity INT
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
		IF (@quantity = 0) BEGIN
            RAISERROR('You must enter the container quantity', 16, 1)
        END

		IF (@operationType = 'Pickup') 
		BEGIN 
			IF (
				SELECT COUNT(*) AS AvailableContainers
				FROM containersXwasteTypes AS cw
				JOIN containers AS c ON c.containerId = cw.containerId
				JOIN wasteTypes AS wt ON wt.wasteTypeId = cw.wasteTypeId
				WHERE wt.name = @wasteType
				AND c.isInUse = 1
			) >= @quantity
			BEGIN
				-- Devolver los N primeros containers inUse que tengan el tipo de basura que decuelve el cliente
				INSERT INTO containerLogs 
				(containerId, 
				carrierId,
				fleetId,
				operationType,
				producerId)
				SELECT TOP(@quantity) 
				containerId, 
				(SELECT contactId FROM contacts WHERE name + ' ' + surname1 + ' ' + ISNULL(surname2, '') = @carrier),
				(SELECT LEFT(@plate, LEN(@plate) - 6) AS ExtractedValue),
				1,	-- Operation
				(SELECT producerId FROM producers WHERE name = @producer)
				FROM 
				containers

				-- Actualizar el estado de los containers
				UPDATE containers
				SET isInUse = 0
				WHERE containerId IN 
				(SELECT TOP (@quantity) containerId     
				FROM containerLogs     
				ORDER BY containerId DESC);
				-- Termina el reembolso de containers
			END
			ELSE
			BEGIN
				-- There are not enough containers available
				RAISERROR('There are not enough containers for the specified waste type and quantity.', 16, 1)
				----- CAM<BIAR ESTA PICHA
			END
		END
		ELSE
		BEGIN
			IF (
				SELECT COUNT(*) AS AvailableContainers
				FROM containersXwasteTypes AS cw
				JOIN containers AS c ON c.containerId = cw.containerId
				JOIN wasteTypes AS wt ON wt.wasteTypeId = cw.wasteTypeId
				WHERE wt.name = @wasteType
				AND c.isInUse = 0
			) >= @quantity
			BEGIN
				-- Meter los N primeros containers a containerLogs si hay suficientes disponibles
				INSERT INTO containerLogs 
				(containerId, 
				carrierId,
				fleetId,
				operationType,
				producerId)
				SELECT TOP(@quantity) 
				containerId, 
				(SELECT contactId FROM contacts WHERE name + ' ' + surname1 + ' ' + ISNULL(surname2, '') = @carrier),
				(SELECT LEFT(@plate, LEN(@plate) - 6) AS ExtractedValue),
				2,	-- Operation
				(SELECT producerId FROM producers WHERE name = @producer)
				FROM 
				containers

				-- Actualizar el estado de los containers
				UPDATE containers
				SET isInUse = 1
				WHERE containerId IN 
				(SELECT TOP (@quantity) containerId     
				FROM containerLogs     
				ORDER BY containerId DESC);
				-- Termina la entrega de containers
			END
			ELSE
			BEGIN
				-- There are not enough containers available
				RAISERROR('There are not enough containers for the specified waste type and quantity.', 16, 1)
			END
		END

		-- Hacer rollback en caso de que alguna validacion no se cumpla
		IF @InicieTransaccion = 1 BEGIN
			COMMIT
		END
	END TRY
	BEGIN CATCH
		SET @ErrorNumber = ERROR_NUMBER()
		SET @ErrorSeverity = ERROR_SEVERITY()
		SET @ErrorState = ERROR_STATE()
		SET @Message = ERROR_MESSAGE()
		
		IF @InicieTransaccion = 1 BEGIN
			ROLLBACK
		END
		RAISERROR('%s - Error Number: %i', 
			@ErrorSeverity, @ErrorState, @Message, @CustomError)
	END CATCH	
    
END;
RETURN 0
GO