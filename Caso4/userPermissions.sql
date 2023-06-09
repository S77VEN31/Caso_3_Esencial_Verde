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
