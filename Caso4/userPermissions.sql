-- Entrega Final

-- Negar todo acceso a un usuario, tambien se puede desde la interfaz grafica
DENY SELECT, INSERT, UPDATE, DELETE ON SCHEMA::dbo TO usuario;

-- Dar permiso de ejecutar algun stored procedure a un usuario, tambien se puede desde la interfaz grafica
GRANT EXECUTE ON OBJECT::dbo.GetContactsGmailNumber TO usuario;

-- Restringir visibilidad de columnas, simplemente se mete en la tabla > propiedades > permisos > select > poner deny en la columna deseada


-- Quitar permiso a columnas o tablas a roles específicos

    -- Crea un rol
    CREATE ROLE usuarioPrueba

    -- Quitar permisos de vista a un rol
    DENY SELECT ON OBJECT::dbo.contacts (name) TO usuarioPrueba

    -- Agrega un usuario al rol
    EXEC sp_addrolemember 'usuarioPrueba', 'stiven_segura'


SELECT
    co.name AS [País o Región],
    p.name AS Industria,
    wt.name AS [Tipo de Residuo],
    SUM(p.balance) AS [Total Recolectado],
    SUM(ctc.cost) AS [Costo de Procesamiento],
    SUM(i.amount) AS [Venta],
    SUM(i.amount) - SUM(ctc.cost) AS [Ganancia Neta]
FROM
    producers p
    INNER JOIN companies c ON p.companyId = c.companyId
    INNER JOIN countries co ON c.companyCategoryId = co.countryId
    LEFT JOIN wasteTypes wt ON p.producerId = wt.wasteTypeId
    LEFT JOIN countryTreatmentCost ctc ON co.countryId = ctc.countryId
    LEFT JOIN invoices i ON c.companyId = i.companyId
--WHERE
  --  co.name = 'Nombre del País'
    --AND i.postdate BETWEEN CONVERT(DATE, 'Fecha Inicial', 120) AND CONVERT(DATE, 'Fecha Final', 120)
GROUP BY
    co.name,
    p.name,
    wt.name
ORDER BY
    [País o Región], p.name, wt.name


    --- FUNCIONAL

WITH treatmentCosts AS (
    SELECT
        wtm.wasteTypeId,
        ctc.cost
    FROM
        countryTreatmentCost ctc
        INNER JOIN wasteTypesXtreatmentMethods wtm ON ctc.treatmentMethodId = wtm.methodId
)
SELECT
    co.name AS country,
    com.companyName AS company,
    wt.name AS wasteType,
    SUM(con.amount) AS totalCollected,
    SUM(ctc.cost * con.amount) AS totalCostProcessed,
    SUM(ctc.cost * con.amount) - SUM(ctc.cost * con.amount * wt2.cost) AS netProfit
FROM
    companies com
    INNER JOIN invoices con ON com.companyId = con.companyId
    INNER JOIN contracts con2 ON con.invoiceId = con2.contractId
    INNER JOIN countries co ON con2.countryId = co.countryId
    INNER JOIN wasteTypes wt ON con2.wasteTypeId = wt.wasteTypeId
    INNER JOIN countryTreatmentCost ctc ON co.countryId = ctc.countryId
    LEFT JOIN treatmentCosts wt2 ON wt.wasteTypeId = wt2.wasteTypeId
GROUP BY
    co.name,
    com.companyName,
    wt.name;


-- Funcional con fechas y power bi
SELECT
co.name AS country,
com.companyName AS company,
wt.name AS wasteType,
i.postdate,
SUM(i.amount) AS totalCollected,
SUM(ctc.cost * i.amount) AS totalCostProcessed,
SUM(ctc.cost * i.amount) - SUM(ctc.cost * i.amount * wt2.cost) AS netProfit
FROM
companies com
INNER JOIN invoices i ON com.companyId = i.companyId
INNER JOIN countries co ON com.countryId = co.countryId
INNER JOIN wasteTypes wt ON i.wasteTypeId = wt.wasteTypeId
INNER JOIN countryTreatmentCost ctc ON co.countryId = ctc.countryId
LEFT JOIN (
SELECT
wtm.wasteTypeId,
ctc.cost
FROM
countryTreatmentCost ctc
INNER JOIN wasteTypesXtreatmentMethods wtm ON ctc.treatmentMethodId = wtm.methodId
) wt2 ON wt.wasteTypeId = wt2.wasteTypeId
GROUP BY
co.name,
com.companyName,
wt.name,
i.postdate

