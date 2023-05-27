
-- How get the info of the SPs
SELECT O.name, M.definition, O.type_desc, O.type 
FROM sys.sql_modules M 
INNER JOIN sys.objects O ON M.object_id=O.object_id 
WHERE O.type IN ('P');
GO

sp_HelpText GetLastNContactsByType;


DROP PROCEDURE IF EXISTS GetLastNContactsByType
GO

CREATE PROCEDURE GetLastNContactsByType
    @contactType VARCHAR(255),
    @N INT
WITH ENCRYPTION
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
GO

ALTER PROC GetLastNContactsByType
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
GO

ALTER PROC GetLastNContactsByType
    @contactType VARCHAR(255),
    @N INT
WITH ENCRYPTION
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
