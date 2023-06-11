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
-- En este escenario, una transacción realiza una actualización de datos que no debe proceder debido a que el número telefónico ya existe
-- Por esta razón, la transacción debe de proceder a hacer rollback, sin embargo antes de hacer rollback, la transacción 2 realiza una lectura de datos
-- Esta lectura va a precenciar el dato ingresado el cual es incorrecto en el momento, es esta lectura la que se conoce como dirty read
-- ---------------------------------------------------------------------------------------------------------------------------

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

-- T1
EXEC UpdateExistingContact
    @ContactId = 2,
    @Phone = '1234567890';
-- T2 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
EXEC GetContactsGmailNumber

-- Solución:
-- El problema se soluciona cambiando el nivel de isolación antes de las transaction del procedimiento
-- el nivel de isolación READ COMMITTED solo permite leer los datos que ya han sido confirmados por una transacción

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

-- ---------------------------------------------------------------------------------------------------------------------------
-- b) Lost Update:
-- En este ejemplo que improvisamos ocurre algo conocido como lost update, esto ocurre cuando una actualización procede por encima de otra
-- Es decir, que una actualización de datos procedió al mismo tiempo que otra, entorpeciendo la primera actualización y haciendo como si esta
-- no hubiera ocurrido. Por esto Si actualizamos el nombre y luego el apellido solo uno de los dos se actualiza, esto es un lost update.
-- ---------------------------------------------------------------------------------------------------------------------------

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
        WAITFOR DELAY '00:00:04'; -- Espera de 2 segundos
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


-- T2
EXEC UpdateExistingContact
    @ContactId = 7,
    @Name = 'a';

-- T1
EXEC UpdateExistingContact
    @ContactId = 7,
    @Surname1 = 'a';

-- Solución
-- Para evitar el error de actualización perdida, podemos utilizar bloqueos (locks) en la base de datos para garantizar
-- la exclusividad de la actualización. Podemos lograr esto utilizando la cláusula UPDLOCK en la consulta de actualización.
-- Aquí hay una modificación al procedimiento UpdateExistingContact que incluye bloqueos:

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
--En el ejemplo dado, primero se actualiza un usuario con una caracteristica y este es visualizado mediante
-- un select donde busque la misma. Sin embargo, mientras se estaba procesando el tiempo en el que se iba a 
-- visualizar el dato actualizado, se actualiza otro usuario que cumple la condicion
-- Este no estaba presenciado al inicio de la transacción y por lo tanto se conoce como phantom, o phantom read
-- ---------------------------------------------------------------------------------------------------------------------------

DROP PROCEDURE IF EXISTS GetContactsGmailNumber
GO
CREATE PROCEDURE GetContactsGmailNumber
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Establecer el nivel de aislamiento en SNAPSHOT antes de iniciar la transacción
        BEGIN TRANSACTION;

        -- Esperar 2 segundos (comando WAITFOR) antes de realizar la consulta SELECT
        WAITFOR DELAY '00:00:04';

        -- Realizar la consulta SELECT con bloqueo explícito (HOLDLOCK)
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

-- T1
EXEC UpdateExistingContact @ContactId = 1, @Name = 'Ernesto', @Surname1 = 'Travis', @ContactType = 'Cliente';

-- T1
EXEC GetContactsGmailNumber;

-- T2
EXEC UpdateExistingContact @ContactId = 2, @Name = 'Victor', @Surname1 = 'Smith', @ContactType = 'Cliente';


-- Solución
-- Para evitar el problema de los contactos fantasma se utiliza un bloqueo de nivel de instantánea (SNAPSHOT)
-- Esto lo que hace es tomar una "instantanea" de la base de datos en el momento en que se inicia la transacción
-- De esta manera desde que inicia hasta que termina la transacción, la base de datos no se modifica

ALTER DATABASE [caso3] SET ALLOW_SNAPSHOT_ISOLATION ON;

DROP PROCEDURE IF EXISTS GetContactsGmailNumber
GO
CREATE PROCEDURE GetContactsGmailNumber
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Establecer el nivel de aislamiento en SNAPSHOT antes de iniciar la transacción
        SET TRANSACTION ISOLATION LEVEL SNAPSHOT;
        BEGIN TRANSACTION;

        -- Esperar 2 segundos (comando WAITFOR) antes de realizar la consulta SELECT
        WAITFOR DELAY '00:00:04';

        -- Realizar la consulta SELECT con bloqueo explícito (HOLDLOCK)
        SELECT *
        FROM contacts WITH (HOLDLOCK)
        WHERE (phone IS NOT NULL OR email LIKE '%@gmail.com%') AND (phone IS NOT NULL OR email IS NOT NULL);

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;

-- ---------------------------------------------------------------------------------------------------------------------------
-- d) Deadlock:
-- En el ejemplo proporcionado, tanto la Transacción 1 como la Transacción 2 intentan modificar diferentes contactos,
-- pero en un orden opuesto. Si ambas transacciones se ejecutan simultáneamente, existe un peligro latete de bloquearse mutuamente
--  y quedar atrapadas en un estado de espera que el sistema da base de datos detecta como un deadlock.
-- ---------------------------------------------------------------------------------------------------------------------------

-- Los procedures se dejan tal cual pero se debe correr en diferentes querys lo sguiente

-- T1
BEGIN TRANSACTION;

-- Hacer algo en la transacción 1
EXEC UpdateExistingContact @ContactId = 1, @Name = 'Alberto';

-- Esperar un poco para permitir que la transacción 2 se inicie
WAITFOR DELAY '00:00:05';

-- Intentar acceder a los recursos bloqueados por la transacción 2
EXEC UpdateExistingContact @ContactId = 2, @Name = 'Jesus';

COMMIT;

-- T2
BEGIN TRANSACTION;

-- Hacer algo en la transacción 2
EXEC UpdateExistingContact @ContactId = 2, @Name = 'Mainor';

-- Esperar un poco para permitir que la transacción 1 se inicie
WAITFOR DELAY '00:00:05';

-- Intentar acceder a los recursos bloqueados por la transacción 1
EXEC UpdateExistingContact @ContactId = 1, @Name = 'Pedro';

COMMIT;

-- Solución
-- En este caso, se utilizaron dos enfoques:
-- Bloqueo explícito: Se utilizó la cláusula WITH (UPDLOCK) en las consultas de actualización para adquirir
-- un bloqueo de escritura exclusivo en las filas afectadas. Esto asegura que ninguna otra transacción pueda
-- leer o escribir en esas filas hasta que se complete la transacción actual. Al adquirir los bloqueos en un
-- orden consistente, se evita el ciclo de bloqueo mutuo y se resuelve el deadlock.

-- Nivel de aislamiento: Se estableció el nivel de aislamiento de la transacción en SERIALIZABLE. Este nivel de
-- aislamiento garantiza que las transacciones se ejecuten de forma serializada, es decir, una tras otra. Cuando
-- se utiliza SERIALIZABLE, las transacciones obtienen bloqueos de lectura y escritura en todos los datos que leen
-- y escriben, lo que evita los deadlocks. Sin embargo, esto también puede llevar a una degradación del rendimiento
-- y la concurrencia, ya que puede haber un mayor bloqueo y espera de recursos.

ALTER PROCEDURE UpdateExistingContact
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

        -- Establecer el nivel de aislamiento a SERIALIZABLE
        SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

        -- Verificar si se ha proporcionado un valor para la columna 'name'
        IF @Name IS NOT NULL
        BEGIN
            -- Realizar la actualización solo si se proporciona un valor para 'name'
            UPDATE contacts WITH (UPDLOCK)
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
        IF EXISTS (SELECT 1 FROM contacts WITH (UPDLOCK) WHERE (phone = @Phone OR email = @Email) AND contactId <> @ContactId)
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
        IF @@TRANCOUNT > 0
           
    -- Mensaje de error
    PRINT 'Error en la actualización del contacto. Se ha deshecho.';

    -- Mostrar información detallada del error
    PRINT ERROR_MESSAGE();
END CATCH;
END;