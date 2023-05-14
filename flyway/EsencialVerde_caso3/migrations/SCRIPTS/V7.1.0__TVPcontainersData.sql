CREATE TYPE containersData AS TABLE (
    carrier VARCHAR(500),
    plate VARCHAR(500),
    location VARCHAR(500),
    company VARCHAR(500),
    producer VARCHAR(500),
    wasteType VARCHAR(500),
    operationType VARCHAR(500),
    quantity VARCHAR(500)
);

SELECT * FROM sys.types WHERE is_user_defined = 1 AND name = 'containersData'

