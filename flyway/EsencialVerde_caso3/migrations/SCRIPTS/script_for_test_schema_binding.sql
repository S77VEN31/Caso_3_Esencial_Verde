IF OBJECT_ID('dbo.VistaRelacionada', 'V') IS NOT NULL
    DROP VIEW dbo.VistaRelacionada;
GO
CREATE VIEW dbo.VistaRelacionada
WITH SCHEMABINDING
AS
SELECT c.name AS countryName, s.name AS stateName, ci.name AS cityName, l.latitude, l.longitude, r.name AS regionName
FROM dbo.countries AS c
INNER JOIN dbo.states AS s ON c.countryId = s.countryId
INNER JOIN dbo.cities AS ci ON s.stateId = ci.stateId
INNER JOIN dbo.locations AS l ON ci.cityId = l.cityId
INNER JOIN dbo.regionAreas AS ra ON ci.cityId = ra.cityId
INNER JOIN dbo.regions AS r ON ra.regionAreasId = r.regionAreaId;
GO
ALTER TABLE dbo.cities
DROP COLUMN name;