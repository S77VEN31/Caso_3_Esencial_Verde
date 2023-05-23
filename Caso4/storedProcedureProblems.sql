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
END

-- Visualizamos algún contacto previo a actualizar
SELECT * FROM contacts WHERE contactId = 1

-- Ejemplo de Ejecución
EXEC UpdateExistingContact
    @ContactId = 3,
    @Email = 'nuevoemail@example.com',
    @Phone = '1234567890',
    @Active = 0;


-- Ejemplo de Deadlock NO FUNCIONA!!!!!!!!!!!!!!!!!!!!!!!!!!!!


-- Transacción 1
BEGIN TRANSACTION;
EXEC UpdateExistingContact @ContactId = 1, @Email = 'nuevoemail1@example.com';
WAITFOR DELAY '00:00:05'; -- Agregamos un retraso para simular una operación prolongada
EXEC UpdateExistingContact @ContactId = 2, @Email = 'nuevoemail2@example.com';
COMMIT;

-- Transacción 2
BEGIN TRANSACTION;
EXEC UpdateExistingContact @ContactId = 2, @Email = 'nuevoemail2@example.com';
WAITFOR DELAY '00:00:05'; -- Agregamos un retraso para simular una operación prolongada
EXEC UpdateExistingContact @ContactId = 1, @Email = 'nuevoemail1@example.com';
COMMIT;


