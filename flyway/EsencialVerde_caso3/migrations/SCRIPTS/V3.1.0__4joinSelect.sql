-----------------------------------------------------------
-- Autor: joseGranados & stivenGuzman
-- Fecha: 30/04/2023
-- Descripcion: basic script with 4 joins
-- shows relationship between countries, states, cities, locations, regionAreas and regions
-----------------------------------------------------------
-- Activar opcion para ver el tiempo de ejecución
SET STATISTICS TIME ON;
-----------------------------------------------------------
-- Select Normal
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

-- Duración:   CPU time = 403922 ms,  elapsed time = 578681 ms. --

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
CREATE UNIQUE CLUSTERED INDEX idx_MyIndexedView
	ON dbo.MyIndexedView (country_name, state_name, city_name, zipcode, latitude, longitude, region_area_name, region_name);
GO
SELECT * FROM dbo.MyIndexedView;

-- Duración: CPU time = 427125 ms,  elapsed time = 596607 ms.--

-----------------------------------------------------------
-- Justificación de la diferencia de tiempos de ejecución entre la vista dinámica y la vista indexada
-----------------------------------------------------------

-- En general, un SELECT en una vista indexada puede ser más rápido que en una vista dinámica porque la vista indexada ya ha sido preprocesada
-- y almacenada en el disco con un índice asociado, lo que permite que las consultas futuras puedan ser resueltas rápidamente utilizando el índice. 
-- Por otro lado, una vista dinámica se genera dinámicamente cada vez que se llama, lo que puede ser más lento porque los datos deben ser procesados
-- y combinados en tiempo real.

-- En el caso de la vista "location_data", se une varias tablas, lo que significa que la consulta es bastante compleja y puede llevar mucho tiempo
-- para procesar. Además, la vista indexada también puede utilizar índices adicionales, como se muestra en el ejemplo con el índice agrupado, lo que
-- puede acelerar aún más las consultas que utilizan la vista.