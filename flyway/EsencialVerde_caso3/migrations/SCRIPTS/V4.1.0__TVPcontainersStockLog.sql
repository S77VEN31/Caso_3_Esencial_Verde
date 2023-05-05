-----------------------------------------------------------
-- Autor: joseGranados & stivenGuzman
-- Fecha: 29/04/2023
-- Descripcion: TVP to insert containersStockLogs
-----------------------------------------------------------

CREATE TYPE dbo.ContainersStockLogTableType AS TABLE
(
   wasteCollectorId INT,
   producerId INT NOT NULL,
   containerId INT NOT NULL,
   action INT NOT NULL,
   CHECKSUM VARBINARY(64)
);
GO
CREATE PROCEDURE dbo.usp_InsertContainersStockLog
   @TVP ContainersStockLogTableType READONLY
AS
BEGIN
   SET NOCOUNT ON;
   DECLARE @ErrorNumber INT, @ErrorSeverity INT, @ErrorState INT, @CustomError INT;
   DECLARE @Message VARCHAR(200);
   DECLARE @InicieTransaccion BIT;

   SET @InicieTransaccion = 0;
   IF @@TRANCOUNT = 0
   BEGIN
      SET @InicieTransaccion = 1;
      SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
      BEGIN TRANSACTION;
   END;

   BEGIN TRY
      SET @CustomError = 2001;

      INSERT INTO containersStockLogs (wasteCollectorId, producerId, containerId, action, createAt, updateAt, CHECKSUM)
      SELECT wasteCollectorId, producerId, containerId, action, GETDATE(), GETDATE(), CHECKSUM
      FROM @TVP;

      IF @InicieTransaccion = 1
      BEGIN
         COMMIT;
      END;
   END TRY
   BEGIN CATCH
      SET @ErrorNumber = ERROR_NUMBER();
      SET @ErrorSeverity = ERROR_SEVERITY();
      SET @ErrorState = ERROR_STATE();
      SET @Message = ERROR_MESSAGE();

      IF @InicieTransaccion = 1
      BEGIN
         ROLLBACK;
      END;
      RAISERROR('%s - Error Number: %i',
         @ErrorSeverity, @ErrorState, @Message, @CustomError);
   END CATCH;
END;
GO

-- Ejecutar el procedimiento almacenado usp_InsertContainersStockLog
-- DECLARE @TVP ContainersStockLogTableType;

-- INSERT INTO @TVP (wasteCollectorId, producerId, containerId, action, CHECKSUM)
-- VALUES
-- (1, 2, 3, 1, 0x0000),
-- (2, 2, 4, 2, 0x0000),
-- (3, 3, 5, 1, 0x0000);

-- BEGIN TRANSACTION;
-- EXEC dbo.usp_InsertContainersStockLog @TVP;
-- COMMIT TRANSACTION;



