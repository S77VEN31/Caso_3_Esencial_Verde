-- ------------ --
--  Procedures  --
-- ------------ --
DROP PROCEDURE IF EXISTS UpdateExistingContact;
GO

CREATE PROCEDURE UpdateExistingContact
    @ContactId INT,
    @Name VARCHAR(255) = NULL,
    @Surname1 VARCHAR(255) = NULL,
    @Surname2 VARCHAR(255) = NULL,
    @Email VARCHAR(255) = NULL,
    @Phone VARCHAR(20) = NULL,
    @Notes VARCHAR(255) = NULL,
    @ContactType VARCHAR(255) = NULL,
    @Active BIT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Inicio de la transacción
        BEGIN TRANSACTION;

        -- Verificar si se ha proporcionado un valor para la columna 'name'
        IF @Name IS NOT NULL
        BEGIN
            -- Realizar la actualización solo si se proporciona un valor para 'name'
            UPDATE contacts
            SET name = @Name
            WHERE contactId = @ContactId;
        END

        -- Realizar la actualización de las demás columnas
        UPDATE contacts
        SET
            surname1 = ISNULL(@Surname1, surname1),
            surname2 = ISNULL(@Surname2, surname2),
            email = ISNULL(@Email, email),
            phone = ISNULL(@Phone, phone),
            notes = ISNULL(@Notes, notes),
            contactType = ISNULL(@ContactType, contactType),
            active = ISNULL(@Active, active),
            updateAt = GETDATE()
        WHERE contactId = @ContactId;
        
        -- Verificar si se ha actualizado algún registro
        IF @@ROWCOUNT = 0
        BEGIN
            -- No se encontró ningún registro para actualizar, realizar un INSERT
            INSERT INTO contacts (contactId, name, surname1, surname2, email, phone, notes, contactType, active, updateAt)
            VALUES (@ContactId, @Name, @Surname1, @Surname2, @Email, @Phone, @Notes, @ContactType, @Active, GETDATE());
        END

        -- Verificar si ya existe un contacto con el mismo número de teléfono o correo electrónico
        IF EXISTS (SELECT 1 FROM contacts WHERE (phone = @Phone OR email = @Email) AND contactId <> @ContactId)
        BEGIN
            -- Error: ya existe un contacto con el mismo número de teléfono o correo electrónico
            -- Realizar un rollback
            WAITFOR DELAY '00:00:05'; -- Espera de 5 segundos
            ROLLBACK TRANSACTION;
            THROW 51000, 'Ya existe un contacto con el mismo número de teléfono o correo electrónico.', 1;
        END

        -- Confirmar la transacción
        COMMIT TRANSACTION;

        -- Mensaje de éxito
        PRINT 'La actualización del contacto se completó correctamente.';
    END TRY
    BEGIN CATCH
        -- Si ocurre un error, deshacer la transacción
        ROLLBACK TRANSACTION;

        -- Mensaje de error
        PRINT 'Error en la actualización del contacto. Se ha deshecho.';

        -- Mostrar información detallada del error
        PRINT ERROR_MESSAGE();
    END CATCH;
END;
GO

-- Modificación del procedimiento GetContactsGmailNumber
DROP PROCEDURE IF EXISTS GetContactsGmailNumber;
GO
CREATE PROCEDURE GetContactsGmailNumber
AS
BEGIN
SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Simulación de un retraso para aumentar la posibilidad de un error de "LOST UPDATE"
        WAITFOR DELAY '00:00:02'; -- Espera de 2 segundos
        
        SELECT *
        FROM contacts
        WHERE (phone IS NOT NULL OR email LIKE '%@gmail.com%') AND (phone IS NOT NULL OR email IS NOT NULL);
        
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        
        THROW;
    END CATCH;
END;
-- ---------------------------------------------------------------------------------------------------------------------------
--a) Dirty Read:
-- En este escenario, una transacción realiza una lectura de datos sin esperar a que otra transacción haya confirmado sus cambios. 
-- Esto puede llevar a que la transacción lea datos inconsistentes o transitorios, lo que se conoce como lectura sucia (dirty read). 
-- En el ejemplo proporcionado, la Transacción 1 lee un contacto antes de que la Transacción 2 lo modifique, lo que podría resultar en la lectura de datos no válidos.
-- ---------------------------------------------------------------------------------------------------------------------------

-DROP PROCEDURE IF EXISTS UpdateExistingContact;
GO

CREATE PROCEDURE UpdateExistingContact
    @ContactId INT,
    @Name VARCHAR(255) = NULL,
    @Surname1 VARCHAR(255) = NULL,
    @Surname2 VARCHAR(255) = NULL,
    @Email VARCHAR(255) = NULL,
    @Phone VARCHAR(20) = NULL,
    @Notes VARCHAR(255) = NULL,
    @ContactType VARCHAR(255) = NULL,
    @Active BIT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Inicio de la transacción
        BEGIN TRANSACTION;

        -- Verificar si se ha proporcionado un valor para la columna 'name'
        IF @Name IS NOT NULL
        BEGIN
            -- Realizar la actualización solo si se proporciona un valor para 'name'
            UPDATE contacts
            SET name = @Name
            WHERE contactId = @ContactId;
        END

        -- Realizar la actualización de las demás columnas
        UPDATE contacts
        SET
            surname1 = ISNULL(@Surname1, surname1),
            surname2 = ISNULL(@Surname2, surname2),
            email = ISNULL(@Email, email),
            phone = ISNULL(@Phone, phone),
            notes = ISNULL(@Notes, notes),
            contactType = ISNULL(@ContactType, contactType),
            active = ISNULL(@Active, active),
            updateAt = GETDATE()
        WHERE contactId = @ContactId;
		
        -- Verificar si se ha actualizado algún registro
        IF @@ROWCOUNT = 0
        BEGIN
            -- No se encontró ningún registro para actualizar, realizar un INSERT
            INSERT INTO contacts (contactId, name, surname1, surname2, email, phone, notes, contactType, active, updateAt)
            VALUES (@ContactId, @Name, @Surname1, @Surname2, @Email, @Phone, @Notes, @ContactType, @Active, GETDATE());
        END

        -- Verificar si ya existe un contacto con el mismo número de teléfono o correo electrónico
        IF EXISTS (SELECT 1 FROM contacts WHERE (phone = @Phone OR email = @Email) AND contactId <> @ContactId)
        BEGIN
            -- Error: ya existe un contacto con el mismo número de teléfono o correo electrónico
            -- Realizar un rollback
			WAITFOR DELAY '00:00:05'; -- Espera de 2 segundos
            ROLLBACK TRANSACTION;
            THROW 51000, 'Ya existe un contacto con el mismo número de teléfono o correo electrónico.', 1;
        END

        -- Confirmar la transacción
        COMMIT TRANSACTION;

        -- Mensaje de éxito
        PRINT 'La actualización del contacto se completó correctamente.';
    END TRY
    BEGIN CATCH
        -- Si ocurre un error, deshacer la transacción
        ROLLBACK TRANSACTION;

        -- Mensaje de error
        PRINT 'Error en la actualización del contacto. Se ha deshecho.';

        -- Mostrar información detallada del error
        PRINT ERROR_MESSAGE();
    END CATCH;
END;
GO

DROP PROCEDURE IF EXISTS GetContactsGmailNumber;
GO
CREATE PROCEDURE GetContactsGmailNumber
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        SELECT *
        FROM contacts
        WHERE (phone IS NOT NULL OR email LIKE '%@gmail.com%') AND (phone IS NOT NULL OR email IS NOT NULL);
        
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        
        THROW;
    END CATCH;
END;

-- Primer EXEC: Actualizar el contacto 2 con el mismo número de teléfono que el contacto 1
EXEC UpdateExistingContact
    @ContactId = 2,
    @Phone = '1234567890';
-- Segundo EXEC: Obtener los contactos filtrados por teléfono o correo electrónico con el procedimiento GetContactsGmailNumber
EXEC GetContactsGmailNumber

-- El problema se soluciona cambiando el nivel de isolación antes de las transaction del procedimiento

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

-- ---------------------------------------------------------------------------------------------------------------------------
-- b) Lost Update:
-- En el ejemplo, la Transacción 1 lee un contacto y la Transacción 2 modifica el mismo contacto antes de que la Transacción 1
-- confirme sus cambios. Como resultado, los cambios realizados por la Transacción 1 se pierden.
-- ---------------------------------------------------------------------------------------------------------------------------
-- Modificación del procedimiento UpdateExistingContact
DROP PROCEDURE IF EXISTS UpdateExistingContact;
GO

CREATE PROCEDURE UpdateExistingContact
    @ContactId INT,
    @Name VARCHAR(255) = NULL,
    @Surname1 VARCHAR(255) = NULL,
    @Surname2 VARCHAR(255) = NULL,
    @Email VARCHAR(255) = NULL,
    @Phone VARCHAR(20) = NULL,
    @Notes VARCHAR(255) = NULL,
    @ContactType VARCHAR(255) = NULL,
    @Active BIT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Inicio de la transacción
        BEGIN TRANSACTION;

        -- Obtener los valores actuales del contacto antes de la actualización
        DECLARE @CurrentName VARCHAR(255), @CurrentSurname1 VARCHAR(255);
        SELECT @CurrentName = name, @CurrentSurname1 = surname1
        FROM contacts
        WHERE contactId = @ContactId;

        -- Hacer una pausa para simular una concurrencia temporal
        WAITFOR DELAY '00:00:02'; -- Espera de 2 segundos

    

        -- Actualizar los demás campos con los valores proporcionados
        UPDATE contacts
        SET
			name = ISNULL(@Name, @CurrentName),
			surname1 = ISNULL(@Surname1, @CurrentSurname1),
            surname2 = ISNULL(@Surname2, surname2),
            email = ISNULL(@Email, email),
            phone = ISNULL(@Phone, phone),
            notes = ISNULL(@Notes, notes),
            contactType = ISNULL(@ContactType, contactType),
            active = ISNULL(@Active, active),
            updateAt = GETDATE()
        WHERE contactId = @ContactId;

        -- Confirmar la transacción
        COMMIT TRANSACTION;

        -- Mostrar los valores actualizados
        SELECT *
        FROM contacts
        WHERE contactId = @ContactId;

        -- Mensaje de éxito
        PRINT 'La actualización del contacto se completó correctamente.';
    END TRY
    BEGIN CATCH
        -- Si ocurre un error, deshacer la transacción
        ROLLBACK TRANSACTION;

        -- Mensaje de error
        PRINT 'Error en la actualización del contacto. Se ha deshecho.';

        -- Mostrar información detallada del error
        PRINT ERROR_MESSAGE();
    END CATCH;
END;
GO



-- Solo modificamos el primer procedure
-- Transacción 1
-- Transacción 1
EXEC UpdateExistingContact
    @ContactId = 7,
    @Name = 'a';

-- Transacción 2 (ejecutada simultáneamente con la Transacción 1)
EXEC UpdateExistingContact
    @ContactId = 7,
    @Surname1 = 'a';

-- Se juntaron dos actualizaciones de datos que en un inicio no debieron ejecutarse juntas

-- Solución

-- Para evitar el error de actualización perdida, podemos utilizar bloqueos (locks) en la base de datos para garantizar
-- la exclusividad de la actualización. Podemos lograr esto utilizando la cláusula UPDLOCK en la consulta de actualización.
-- Aquí hay una modificación al procedimiento UpdateExistingContact que incluye bloqueos:
-- Modificación del procedimiento UpdateExistingContact
-- Modificación del procedimiento UpdateExistingContact
DROP PROCEDURE IF EXISTS UpdateExistingContact;
GO

CREATE PROCEDURE UpdateExistingContact
    @ContactId INT,
    @Name VARCHAR(255) = NULL,
    @Surname1 VARCHAR(255) = NULL,
    @Surname2 VARCHAR(255) = NULL,
    @Email VARCHAR(255) = NULL,
    @Phone VARCHAR(20) = NULL,
    @Notes VARCHAR(255) = NULL,
    @ContactType VARCHAR(255) = NULL,
    @Active BIT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Inicio de la transacción
        BEGIN TRANSACTION;

        -- Obtener los valores actuales del contacto antes de la actualización
        DECLARE @CurrentName VARCHAR(255), @CurrentSurname1 VARCHAR(255);

        SELECT @CurrentName = name, @CurrentSurname1 = surname1 
        FROM contacts WITH (UPDLOCK)
        WHERE contactId = @ContactId;

        -- Hacer una pausa para simular una concurrencia temporal
        WAITFOR DELAY '00:00:02'; -- Espera de 2 segundos

        -- Actualizar los campos utilizando UPDLOCK y los valores actuales obtenidos
        UPDATE contacts WITH (UPDLOCK)
        SET
            name = ISNULL(@Name, @CurrentName),
            surname1 = ISNULL(@Surname1, @CurrentSurname1),
            surname2 = ISNULL(@Surname2, surname2),
            email = ISNULL(@Email, email),
            phone = ISNULL(@Phone, phone),
            notes = ISNULL(@Notes, notes),
            contactType = ISNULL(@ContactType, contactType),
            active = ISNULL(@Active, active),
            updateAt = GETDATE()
        WHERE contactId = @ContactId;

        -- Confirmar la transacción
        COMMIT TRANSACTION;

        -- Mostrar los valores actualizados
        SELECT *
        FROM contacts
        WHERE contactId = @ContactId;

        -- Mensaje de éxito
        PRINT 'La actualización del contacto se completó correctamente.';
    END TRY
    BEGIN CATCH
        -- Si ocurre un error, deshacer la transacción
        ROLLBACK TRANSACTION;

        -- Mensaje de error
        PRINT 'Error en la actualización del contacto. Se ha deshecho.';

        -- Mostrar información detallada del error
        PRINT ERROR_MESSAGE();
    END CATCH;
END;
GO
-- ---------------------------------------------------------------------------------------------------------------------------
-- c) Phantom:
--En el ejemplo dado, la Transacción 1 realiza una consulta para obtener contactos con un cierto tipo, 
-- pero la Transacción 2 inserta un nuevo contacto que también cumple con ese criterio. Como resultado,
-- la Transacción 1 "ve" un nuevo "contacto fantasma" que no estaba presente al principio.
-- ---------------------------------------------------------------------------------------------------------------------------

-- Transacción 1
BEGIN TRANSACTION
    -- Leer los contactos que coinciden con un criterio específico
    SELECT * FROM contacts WHERE contactType = 'Cliente'

-- Transacción 2
BEGIN TRANSACTION
    -- Insertar un nuevo contacto que también coincide con el criterio de la Transacción 1
    INSERT INTO contacts (name, contactType) VALUES ('Nuevo Contacto', 'Cliente');

-- Confirmar o revertir las transacciones según sea necesario
COMMIT TRANSACTION -- Transacción 1
COMMIT TRANSACTION -- Transacción 2

-- ---------------------------------------------------------------------------------------------------------------------------
-- d) Deadlock:
-- En el ejemplo proporcionado, tanto la Transacción 1 como la Transacción 2 intentan modificar diferentes contactos,
-- pero en un orden opuesto. Si ambas transacciones se ejecutan simultáneamente, podrían bloquearse mutuamente y quedar
-- atrapadas en un estado de espera 
-- ---------------------------------------------------------------------------------------------------------------------------

-- Transacción 1
BEGIN TRANSACTION
    -- Modificar el contacto 1
    EXEC UpdateExistingContact
        @ContactId = 1,
        @Email = 'nuevoemail@example.com',
        @Phone = '1234567890',
        @Active = 0;

-- Transacción 2
BEGIN TRANSACTION
    -- Modificar el contacto 2
    EXEC UpdateExistingContact
        @ContactId = 2,
        @Email = 'otroemail@example.com',
        @Phone = '9876543210',
        @Active = 1;

-- Confirmar o revertir las transacciones según sea necesario
COMMIT TRANSACTION -- Transacción 1
COMMIT TRANSACTION -- Transacción 2