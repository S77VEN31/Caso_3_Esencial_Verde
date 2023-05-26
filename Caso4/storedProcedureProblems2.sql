-- ------------ --
--  Procedures  --
-- ------------ --
DROP PROCEDURE IF EXISTS UpdateExistingContact;
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

        UPDATE contacts
        SET
            name = ISNULL(@Name, name),
            surname1 = ISNULL(@Surname1, surname1),
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

-- Ejemplo de Ejecución
EXEC UpdateExistingContact
    @ContactId = 1,
    @Name = 'John',
    @Email = 'john@example.com',
    @Phone = '1234567890',
    @Active = 1;

-- ---------------------------------------------------------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS InsertNewContact;
CREATE PROCEDURE InsertNewContact
    @Name VARCHAR(255),
    @Surname1 VARCHAR(255),
    @Surname2 VARCHAR(255) = NULL,
    @Email VARCHAR(255) = NULL,
    @Phone VARCHAR(20) = NULL,
    @Notes VARCHAR(255) = NULL,
    @ContactType VARCHAR(255),
    @Active BIT = 1
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Inicio de la transacción
        BEGIN TRANSACTION;

        -- Verificar si ya existe un contacto con el mismo número de teléfono o correo electrónico
        IF EXISTS (SELECT 1 FROM contacts WHERE phone = @Phone OR email = @Email)
        BEGIN
            -- Error: ya existe un contacto con el mismo número de teléfono o correo electrónico
            THROW 51000, 'Ya existe un contacto con el mismo número de teléfono o correo electrónico.', 1;
        END
        ELSE
        BEGIN
            -- Insertar el nuevo contacto
            INSERT INTO contacts (name, surname1, surname2, email, phone, notes, contactType, active)
            VALUES (@Name, @Surname1, @Surname2, @Email, @Phone, @Notes, @ContactType, @Active);
        END

        -- Confirmar la transacción
        COMMIT TRANSACTION;

        -- Mensaje de éxito
        PRINT 'El nuevo contacto se insertó correctamente.';
    END TRY
    BEGIN CATCH
        -- Si ocurre un error, deshacer la transacción
        ROLLBACK TRANSACTION;

        -- Mostrar mensaje de error
        PRINT 'Error al insertar el nuevo contacto. Se ha deshecho.';

        -- Mostrar información detallada del error
        PRINT ERROR_MESSAGE();
    END CATCH;
END;

-- Ejemplo de Ejecución
EXEC InsertNewContact
    @Name = 'María',
    @Surname1 = 'Gómez',
    @Surname2 = 'López',
    -- @Email = 'maria@example.com',
    -- @Phone = '1234567890',
    -- @Notes = 'Este es un nuevo contacto',
    -- @ContactType = 'Proveedor',
    -- @Active = 1;

--- Ejemplo de Problemas
-- ---------------------------------------------------------------------------------------------------------------------------
-- a) Dirty Read:
-- La situación de "dirty read" ocurre cuando una transacción lee datos no confirmados
-- de otra transacción que aún no ha sido confirmada o ha sido deshecha. Podemos simular
-- esto de la siguiente manera:
-- ---------------------------------------------------------------------------------------------------------------------------

-- Transacción 1
BEGIN TRANSACTION;
EXEC InsertNewContact @Name = 'John', @Surname1 = 'Doe', @ContactType = 'Cliente';

-- Transacción 2
BEGIN TRANSACTION;

DECLARE @ultimo INT;
SELECT TOP 1 @ultimo=contactId FROM contacts ORDER BY contactId DESC;

EXEC UpdateExistingContact @ContactId = @ultimo, @Name = 'Updated Name';

-- Transacción 2 realiza un WAIT para simular un retraso
WAITFOR DELAY '00:00:05';

-- Transacción 2 confirma la actualización
COMMIT TRANSACTION;

-- Transacción 1 intenta leer el nombre actualizado antes de confirmar
SELECT name FROM contacts WHERE contactId = @ultimo;

-- Transacción 1 no ha confirmado, pero aún puede leer los datos actualizados (dirty read)
-- Esto debería mostrar el nombre actualizado, pero no debería ser así


-- ---------------------------------------------------------------------------------------------------------------------------
-- b) Lost Update:
-- La situación de "lost update" ocurre cuando dos transacciones intentan actualizar
-- los mismos datos simultáneamente, y una de ellas sobrescribe los cambios realizados
-- por la otra sin tener en cuenta los cambios previos. Podemos simular esto de la siguiente manera:
-- ---------------------------------------------------------------------------------------------------------------------------

-- Transacción 1
BEGIN TRANSACTION;
EXEC UpdateExistingContact @ContactId = 1, @Name = 'Update 1';

-- Transacción 2
BEGIN TRANSACTION;
EXEC UpdateExistingContact @ContactId = 1, @Name = 'Update 2';

-- Transacción 2 realiza un WAIT para simular un retraso
WAITFOR DELAY '00:00:05';

-- Transacción 2 confirma la actualización
COMMIT TRANSACTION;

-- Transacción 1 confirma la actualización
COMMIT TRANSACTION;

-- Ambas transacciones intentan actualizar el mismo contacto
-- La transacción 2 sobrescribe los cambios realizados por la transacción 1 (lost update)
-- El nombre debería ser 'Update 2', pero se perdió el cambio realizado por la transacción 1


-- ---------------------------------------------------------------------------------------------------------------------------
-- c) Phantom:
-- La situación de "phantom" ocurre cuando una transacción realiza una operación basada
-- en un conjunto de resultados, pero otro proceso inserta o elimina filas que cumplen
-- con los criterios de la consulta original, lo que hace que la operación se comporte de
-- manera inesperada. Podemos simular esto de la siguiente manera:
-- ---------------------------------------------------------------------------------------------------------------------------

-- Transacción 1
BEGIN TRANSACTION;
SELECT * FROM contacts WHERE contactType = 'Cliente';

-- Transacción 2
BEGIN TRANSACTION;
EXEC InsertNewContact @Name = 'New Contact', @Surname1 = 'Doe', @ContactType = 'Cliente';

-- Transacción 2 realiza un WAIT para simular un retraso
WAITFOR DELAY '00:00:05';

-- Transacción 2 confirma la inserción
COMMIT TRANSACTION;

-- Transacción 1 realiza una operación basada en el conjunto de resultados
-- La transacción 2 inserta un nuevo contacto que cumple con los criterios de la consulta
-- Esto puede hacer que la operación de la transacción 1 se comporte de manera inesperada (phantom)


-- ---------------------------------------------------------------------------------------------------------------------------
-- d) Deadlock:
-- La situación de "deadlock" ocurre cuando dos o más transacciones están esperando
-- mutuamente por recursos bloqueados por las otras transacciones, lo que resulta
-- en un punto muerto donde ninguna transacción puede continuar. Podemos simular esto de la siguiente manera:
-- ---------------------------------------------------------------------------------------------------------------------------
-- Transacción 1
BEGIN TRANSACTION;
EXEC UpdateExistingContact @ContactId = 1, @Name = 'Transaction 1';

-- Transacción 2
BEGIN TRANSACTION;
EXEC InsertNewContact @Name = 'New Contact', @Surname1 = 'Doe', @ContactType = 'Cliente';

-- Transacción 1 intenta insertar un nuevo contacto
-- Esto generará un bloqueo debido a que la transacción 2 ya ha realizado una inserción pero aún no ha confirmado

-- Transacción 1 realiza un WAITFOR para simular un retraso y permitir que la transacción 2 continúe
WAITFOR DELAY '00:00:05';

-- Transacción 1 confirma la actualización
COMMIT TRANSACTION;

-- Transacción 2 confirma la inserción
COMMIT TRANSACTION;

-- Ambas transacciones intentan acceder a recursos bloqueados por la otra
-- Esto resultará en un deadlock, donde ninguna transacción puede continuar hasta que se resuelva el bloqueo

