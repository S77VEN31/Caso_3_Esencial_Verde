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