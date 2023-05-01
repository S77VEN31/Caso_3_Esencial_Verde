-----------------------------------------------------------
-- Autor: joseGranados & stivenGuzman
-- Fecha: 30/04/2023
-- Descripcion: basic script with 4 joins
-- shows relationship between countries, states, cities, locations, regionAreas and regions
-----------------------------------------------------------
SELECT countries.name AS country_name, states.name AS state_name, cities.name AS city_name, locations.zipcode, locations.latitude, locations.longitude, regionAreas.name AS region_area_name, regions.name AS region_name
FROM countries
JOIN states ON countries.countryId = states.countryId
JOIN cities ON states.stateId = cities.stateId
JOIN locations ON cities.cityId = locations.cityId
JOIN regionAreas ON regionAreas.cityId = cities.cityId OR regionAreas.stateId = states.stateId OR regionAreas.countryId = countries.countryId
JOIN regions ON regions.regionAreaId = regionAreas.regionAreasId;

-----------------------------------------------------------
-- Vista Dinámica
-----------------------------------------------------------
CREATE VIEW location_data AS
SELECT 
  countries.name AS country_name, 
  states.name AS state_name, 
  cities.name AS city_name, 
  locations.zipcode, 
  locations.latitude, 
  locations.longitude, 
  regionAreas.name AS region_area_name, 
  regions.name AS region_name
FROM countries
JOIN states ON countries.countryId = states.countryId
JOIN cities ON states.stateId = cities.stateId
JOIN locations ON cities.cityId = locations.cityId
JOIN regionAreas ON regionAreas.cityId = cities.cityId OR regionAreas.stateId = states.stateId OR regionAreas.countryId = countries.countryId
JOIN regions ON regions.regionAreaId = regionAreas.regionAreasId;

-----------------------------------------------------------
-- Vista Indexada
-----------------------------------------------------------
-- Activar opciones necesarias para soportar vistas indexadas
SET NUMERIC_ROUNDABORT OFF;
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT,
   QUOTED_IDENTIFIER, ANSI_NULLS ON;

-- Crear vista con esquema vinculado
IF OBJECT_ID ('dbo.MyIndexedView', 'view') IS NOT NULL
	DROP VIEW dbo.MyIndexedView;
GO
	CREATE VIEW dbo.MyIndexedView
	WITH SCHEMABINDING
		AS
	SELECT
		countries.name AS country_name,
		states.name AS state_name,
		cities.name AS city_name,
		locations.zipcode,
		locations.latitude,
		locations.longitude,
		regionAreas.name AS region_area_name,
		regions.name AS region_name
	FROM
		countries
		JOIN states ON countries.countryId = states.countryId
		JOIN cities ON states.stateId = cities.stateId
		JOIN locations ON cities.cityId = locations.cityId
		JOIN regionAreas ON regionAreas.cityId = cities.cityId OR regionAreas.stateId = states.stateId OR regionAreas.countryId = countries.countryId
		JOIN regions ON regions.regionAreaId = regionAreas.regionAreasId;
GO
-- Crear índice agrupado en la vista
CREATE UNIQUE CLUSTERED INDEX idx_MyIndexedView
	ON dbo.MyIndexedView (country_name, state_name, city_name, zipcode, latitude, longitude, region_area_name, region_name);
GO

SET STATISTICS TIME ON;
SELECT * FROM dbo.MyIndexedView;