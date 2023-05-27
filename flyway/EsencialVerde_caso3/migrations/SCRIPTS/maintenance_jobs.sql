USE MASTER
GO
SP_CONFIGURE 'SHOW ADVANCE', 1
GO
RECONFIGURE WITH OVERRIDE
GO
SP_CONFIGURE 'AGENT XPs', 1
GO
RECONFIGURE WITH OVERRIDE
GO

--docker exec -it --user root d46f516b1695 bash
--/opt/mssql/bin/mssql-conf set sqlagent.enabled true

-- Codigo para poner en el job de recompilar los SP
DECLARE @ProcedureName nvarchar(max)

DECLARE ProcedureCursor CURSOR FOR
SELECT QUOTENAME(s.name) + '.' + QUOTENAME(o.name) AS ProcedureName
FROM sys.objects o
INNER JOIN sys.schemas s ON o.schema_id = s.schema_id
WHERE o.type = 'P'

OPEN ProcedureCursor
FETCH NEXT FROM ProcedureCursor INTO @ProcedureName

WHILE @@FETCH_STATUS = 0
BEGIN
    EXEC sp_recompile @objname = @ProcedureName
    FETCH NEXT FROM ProcedureCursor INTO @ProcedureName
END

CLOSE ProcedureCursor
DEALLOCATE ProcedureCursor




EXEC sp_addlinkedserver   
   @server = 'LinkedS', 
   @srvproduct = '', 
   @provider = 'SQLNCLI', 
   @datasrc = 'localhost, 1433';

EXEC sp_addlinkedsrvlogin 
   @rmtsrvname = 'LinkedS',
   @useself = 'False',
   @rmtuser = 'sa',
   @rmtpassword = 'Sven1234';

INSERT INTO [LinkedS].[caso3].[dbo].[containerLogs]
SELECT * FROM [sys].[dm_exec_query_stats];