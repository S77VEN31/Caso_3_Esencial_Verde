-- ----------------- ------
--  Primer Procedure ------
-- ----------------- ------
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

--- Ejemplo de Problemas

-- ---------------------------------------------------------------------------------------------------------------------------
--a) Dirty Read:
-- En este escenario, una transacción realiza una lectura de datos sin esperar a que otra transacción haya confirmado sus cambios. 
-- Esto puede llevar a que la transacción lea datos inconsistentes o transitorios, lo que se conoce como lectura sucia (dirty read). 
-- En el ejemplo proporcionado, la Transacción 1 lee un contacto antes de que la Transacción 2 lo modifique, lo que podría resultar en la lectura de datos no válidos.
-- ---------------------------------------------------------------------------------------------------------------------------

-- Transacción 1
BEGIN TRANSACTION
    -- Realizar una lectura sucia (dirty read)
    SELECT * FROM contacts WITH (NOLOCK) WHERE contactId = 1

-- Transacción 2
BEGIN TRANSACTION
    -- Modificar el contacto mientras la Transacción 1 aún no ha sido confirmada
    EXEC UpdateExistingContact
        @ContactId = 1,
        @Email = 'nuevoemail@example.com',
        @Phone = '1234567890',
        @Active = 0;

-- Confirmar o revertir las transacciones según sea necesario
COMMIT TRANSACTION -- Transacción 1
COMMIT TRANSACTION -- Transacción 2

-- ---------------------------------------------------------------------------------------------------------------------------
-- b) Lost Update:
-- En el ejemplo, la Transacción 1 lee un contacto y la Transacción 2 modifica el mismo contacto antes de que la Transacción 1
-- confirme sus cambios. Como resultado, los cambios realizados por la Transacción 1 se pierden.
-- ---------------------------------------------------------------------------------------------------------------------------

-- Transacción 1
BEGIN TRANSACTION
    -- Leer el contacto sin bloquearlo
    SELECT * FROM contacts WHERE contactId = 1

-- Transacción 2
BEGIN TRANSACTION
    -- Modificar el mismo contacto sin haber confirmado la Transacción 1
    EXEC UpdateExistingContact
        @ContactId = 1,
        @Email = 'nuevoemail@example.com',
        @Phone = '1234567890',
        @Active = 0;

-- Confirmar o revertir las transacciones según sea necesario
COMMIT TRANSACTION -- Transacción 1
COMMIT TRANSACTION -- Transacción 2

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

-- ------------------- ------
--  Segundo Procedure  ------
-- ------------------- ------
CREATE PROCEDURE GetProducerDetails
    @ProducerId INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM producers
    WHERE producerId = @ProducerId;
END;

-- Ejemplo de ejecución

EXEC GetProducerDetails @ProducerId = 1;

--- Ejemplo de Problemas

-- ---------------------------------------------------------------------------------------------------------------------------
-- a) Dirty Read: 
-- En este ejemplo, la transacción 1 realiza una lectura del productor con ID 1,
-- pero antes de que se complete la transacción, la transacción 2 actualiza el nombre del mismo productor.
-- Como resultado, la transacción 1 podría leer un nombre no válido o no confirmado debido a la lectura sucia (dirty read).
-- ---------------------------------------------------------------------------------------------------------------------------

-- Transacción 1
BEGIN TRANSACTION;
EXEC GetProducerDetails @ProducerId = 1;

-- Transacción 2 (en paralelo con la transacción 1)
BEGIN TRANSACTION;
UPDATE producers
SET name = 'Nuevo Nombre'
WHERE producerId = 1;
COMMIT;

-- Continuar con la transacción 1
COMMIT;

-- ---------------------------------------------------------------------------------------------------------------------------
-- b) Lost Update: 
-- En este ejemplo, la transacción 1 realiza una lectura y una posterior actualización del balance del productor con ID 1. 
-- Sin embargo, entre la lectura y la actualización, la transacción 2 también actualiza el balance del mismo productor. 
-- Como resultado, la actualización realizada por la transacción 1 puede perderse debido a la sobreescritura (lost update).
-- ---------------------------------------------------------------------------------------------------------------------------

-- Transacción 1
BEGIN TRANSACTION;
EXEC GetProducerDetails @ProducerId = 1;

-- Transacción 2 (en paralelo con la transacción 1)
BEGIN TRANSACTION;
INSERT INTO producers (name, locationId, companyId, balance)
VALUES ('Nuevo Productor', 2, 1, 0);
COMMIT;

-- Continuar con la transacción 1
COMMIT;

-- ---------------------------------------------------------------------------------------------------------------------------
-- c) Phantom:
-- En este ejemplo, la transacción 1 realiza una lectura de los productores existentes. Entre la lectura y la confirmación de la transacción,
-- la transacción 2 inserta un nuevo productor. Como resultado, la transacción 1 puede mostrar un conjunto diferente de productores en la lectura,
-- lo que genera una "aparición" de nuevos registros (phantom).
-- ---------------------------------------------------------------------------------------------------------------------------
-- Transacción 1
BEGIN TRANSACTION;
EXEC GetProducerDetails @ProducerId = 1;

-- Transacción 2 (en paralelo con la transacción 1)
BEGIN TRANSACTION;
INSERT INTO producers (name, locationId, companyId, balance)
VALUES ('Nuevo Productor', 2, 1, 0);
COMMIT;

-- Continuar con la transacción 1
COMMIT;

-- ---------------------------------------------------------------------------------------------------------------------------
-- d) Deadlock:
-- En este ejemplo, tanto la transacción 1 como la transacción 2 intentan ejecutar el stored procedure "GetProducerDetails"
-- en paralelo para diferentes productores (ID 1 y ID 2). Si ambas transacciones mantienen los bloqueos adquiridos durante la ejecución del
-- stored procedure y no se liberan, se producirá un deadlock.
-- ---------------------------------------------------------------------------------------------------------------------------
-- Transacción 1
BEGIN TRANSACTION;
EXEC GetProducerDetails @ProducerId = 1;

-- Transacción 2 (en paralelo con la transacción 1)
BEGIN TRANSACTION;
EXEC GetProducerDetails @ProducerId = 2;

-- Continuar con la transacción 1
COMMIT;
