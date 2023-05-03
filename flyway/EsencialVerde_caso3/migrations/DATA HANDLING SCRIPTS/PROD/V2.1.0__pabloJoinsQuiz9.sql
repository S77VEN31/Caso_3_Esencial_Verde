USE caso3;
-- Inserts para la tabla wasteTypes
INSERT INTO caso3.dbo.wasteTypes (name, description)
VALUES ('Plastic', 'Waste generated from plastic materials.'),
       ('Glass', 'Waste generated from glass materials.'),
       ('Paper', 'Waste generated from paper materials.'),
       ('Metal', 'Waste generated from metal materials.'),
       ('Organic', 'Waste generated from organic materials.');

-- Inserts para la tabla treatmentMethods
INSERT INTO caso3.dbo.treatmentMethods (name, description)
VALUES ('Recycling', 'Process of converting waste materials into new materials and objects.'),
       ('Incineration', 'Combustion of waste materials.'),
       ('Landfill', 'Method of disposing waste by burying it in the ground.'),
       ('Composting', 'Process of organic waste decomposition into a soil amendment.'),
       ('Pyrolysis', 'Thermal decomposition of waste in the absence of oxygen.');

-- Inserts para la tabla countries
INSERT INTO caso3.dbo.countries (name, nameCode, phoneCode)
VALUES ('Mexico', 'MX', 52),
       ('United States', 'US', 1),
       ('Canada', 'CA', 1),
       ('Japan', 'JP', 81),
       ('Brazil', 'BR', 55);

-- Inserts para la tabla countryTreatmentCost
INSERT INTO caso3.dbo.countryTreatmentCost (treatmentMethodId, countryId, cost, checksum)
VALUES (1, 1, 1000.00, CONVERT(VARBINARY(64), 'Recycling-MX-1000.00')),
       (2, 2, 5000.00, CONVERT(VARBINARY(64), 'Incineration-US-5000.00')),
       (3, 3, 2500.00, CONVERT(VARBINARY(64), 'Landfill-CA-2500.00')),
       (4, 4, 3000.00, CONVERT(VARBINARY(64), 'Composting-JP-3000.00')),
       (5, 5, 2000.00, CONVERT(VARBINARY(64), 'Pyrolysis-BR-2000.00'));

-- Obtener todos los costos de tratamiento por país y tipo de residuo:
SELECT c.name AS country, w.name AS waste_type, ct.cost
FROM countryTreatmentCost ct
INNER JOIN countries c ON ct.countryId = c.countryId
INNER JOIN wasteTypes w ON ct.wasteTypeId = w.wasteTypeId;

-- Obtener todos los métodos de tratamiento activos y sus respectivos costos por país:
SELECT c.name AS country, tm.name AS treatment_method, ct.cost
FROM countryTreatmentCost ct
INNER JOIN countries c ON ct.countryId = c.countryId
INNER JOIN treatmentMethods tm ON ct.treatmentMethodId = tm.methodId
WHERE tm.active = 1;

-- Obtener todos los residuos que se pueden tratar en cada país y método de tratamiento:
SELECT c.name AS country, tm.name AS treatment_method, w.name AS waste_type
FROM countryTreatmentCost ct
INNER JOIN countries c ON ct.countryId = c.countryId
INNER JOIN treatmentMethods tm ON ct.treatmentMethodId = tm.methodId
INNER JOIN wasteTypes w ON ct.wasteTypeId = w.wasteTypeId;

-- Obtener la cantidad total de costos de tratamiento por país:
SELECT c.name AS country, SUM(ct.cost) AS total_cost
FROM countryTreatmentCost ct
INNER JOIN countries c ON ct.countryId = c.countryId
GROUP BY c.name;

-- Obtener los países que tienen tratamientos para todos los tipos de residuos disponibles:
SELECT c.name AS country
FROM countries c
WHERE NOT EXISTS (
    SELECT w.wasteTypeId
    FROM wasteTypes w
    WHERE NOT EXISTS (
        SELECT ct.countryTreatmentCostId
        FROM countryTreatmentCost ct
        WHERE ct.wasteTypeId = w.wasteTypeId AND ct.countryId = c.countryId
    )
);
