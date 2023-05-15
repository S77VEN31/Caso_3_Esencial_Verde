-----------------------------------------------------------
-- Autor: joseGranados & stivenGuzman
-- Fecha: 13/05/2023
-- Descripcion: PROCEDURE to the API REST
-----------------------------------------------------------
CREATE PROCEDURE GetUnusedContainersForWasteType
    @wasteTypeId INT
AS
BEGIN
    SELECT c.containerId, c.manufacturerInfo, c.maxWeight
    FROM containers c
    INNER JOIN containersXwasteTypes cxwt ON c.containerId = cxwt.containerId
    WHERE cxwt.wasteTypeId = @wasteTypeId AND c.isInUse = 0
END;
-----------------------------------------------------------
-- Autor: joseGranados & stivenGuzman
-- Fecha: 13/05/2023
-- Descripcion: PROCEDURE to the API REST
-----------------------------------------------------------
CREATE PROCEDURE GetLastNContactsByType
    @contactType VARCHAR(255),
    @N INT
AS
BEGIN
    SELECT TOP (@N)
        contactId,
        name,
        surname1,
        surname2,
        email,
        phone,
        notes,
        contactType,
        active,
        createAt,
        updateAt,
        CHECKSUM
    FROM contacts
    WHERE contactType = @contactType
    ORDER BY createAt DESC;
END;