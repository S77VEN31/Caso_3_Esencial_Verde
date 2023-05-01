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