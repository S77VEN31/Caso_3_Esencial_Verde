-----------------------------------------------------------
-- Autor: joseGranados & stivenGuzman
-- Fecha: 30/04/2023
-- Descripcion: basic script with 4 joins
-- shows relationship between countries, states, cities, locations, regionAreas and regions
-----------------------------------------------------------
-- Activar opcion para ver el tiempo de ejecución
SET STATISTICS TIME ON;

-------------
-- Selects --
-------------

SELECT countries.name AS country_name, states.name AS state_name, cities.name AS city_name, locations.zipcode, locations.latitude, locations.longitude, regionAreas.name AS region_area_name, regions.name AS region_name
FROM countries
JOIN states ON countries.countryId = states.countryId
JOIN cities ON states.stateId = cities.stateId
JOIN locations ON cities.cityId = locations.cityId
JOIN regionAreas ON regionAreas.cityId = cities.cityId OR regionAreas.stateId = states.stateId OR regionAreas.countryId = countries.countryId
JOIN regions ON regions.regionAreaId = regionAreas.regionAreasId;

-- Duración: CPU time = 0 ms,  elapsed time = 1 ms.

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

SELECT * FROM location_data;

-- Duración: CPU time = 15 ms,  elapsed time = 1 ms.

-----------------------------------------------------------
-- Vista Indexada
-----------------------------------------------------------
-- Activar opciones necesarias para soportar vistas indexadas
SET NUMERIC_ROUNDABORT OFF;
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT,
   QUOTED_IDENTIFIER, ANSI_NULLS ON;

-- Crear vista con esquema vinculado
IF OBJECT_ID('dbo.MyIndexedView', 'view') IS NOT NULL
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
         dbo.countries
         JOIN dbo.states ON countries.countryId = states.countryId
         JOIN dbo.cities ON states.stateId = cities.stateId
         JOIN dbo.locations ON cities.cityId = locations.cityId
         JOIN dbo.regionAreas ON regionAreas.cityId = cities.cityId 
            OR regionAreas.stateId = states.stateId 
            OR regionAreas.countryId = countries.countryId
         JOIN dbo.regions ON regions.regionAreaId = regionAreas.regionAreasId;
GO
-- Crear índice agrupado en la vista
DROP idx_MyIndexedView IF EXISTS;
CREATE UNIQUE CLUSTERED INDEX idx_MyIndexedView
	ON dbo.MyIndexedView (country_name, state_name, city_name, zipcode, latitude, longitude, region_area_name, region_name);
GO
SELECT * FROM dbo.MyIndexedView;

-- Duración: CPU time = 17 ms,  elapsed time = 1 ms.


-- Justificación de la diferencia de tiempos de ejecución entre la vista dinámica y la vista indexada

-- En general, un SELECT en una vista indexada puede ser más rápido que en una vista dinámica porque la vista indexada ya ha sido preprocesada
-- y almacenada en el disco con un índice asociado, lo que permite que las consultas futuras puedan ser resueltas rápidamente utilizando el índice. 
-- Por otro lado, una vista dinámica se genera dinámicamente cada vez que se llama, lo que puede ser más lento porque los datos deben ser procesados
-- y combinados en tiempo real.

-- Sin embargo, hay situaciones en las que una vista indexada puede ser más lenta que una vista dinámica. Por ejemplo, si los datos subyacentes a 
-- la vista cambian con frecuencia, la vista indexada tendrá que ser actualizada con la misma frecuencia, lo que puede resultar en un mayor tiempo de
-- procesamiento en comparación con la vista dinámica.

-- También es importante tener en cuenta que la velocidad de una vista indexada dependerá en gran medida de la calidad del índice que se ha creado. 
-- Un índice ineficiente o inadecuado puede ralentizar significativamente las consultas de una vista indexada.