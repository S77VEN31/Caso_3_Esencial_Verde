SELECT p.producerId, p.name AS producerName, cl.weight, cl.operationType,
       co.name AS producerCountry, s.name AS producerState, ci.name AS producerCity, 
       l.zipcode AS producerZipcode, l.latitude AS producerLatitude, l.longitude AS producerLongitude, 
       comp.companyName AS producerCompany, cl.wasteCollectorId
FROM containerLogs cl
INNER JOIN producers p ON cl.producerId = p.producerId
INNER JOIN locations l ON p.locationId = l.locationId
INNER JOIN cities ci ON l.cityId = ci.cityId
INNER JOIN states s ON ci.stateId = s.stateId
INNER JOIN countries co ON s.countryId = co.countryId
INNER JOIN companies comp ON p.companyId = comp.companyId
WHERE cl.operationType = 1;
-- con acumulado
SELECT p.producerId, p.name AS producerName, SUM(cl.weight) AS accumulatedWeight, cl.operationType,
       co.name AS producerCountry, s.name AS producerState, ci.name AS producerCity, 
       l.zipcode AS producerZipcode, l.latitude AS producerLatitude, l.longitude AS producerLongitude, 
       comp.companyName AS producerCompany, cl.wasteCollectorId
FROM containerLogs cl
INNER JOIN producers p ON cl.producerId = p.producerId
INNER JOIN locations l ON p.locationId = l.locationId
INNER JOIN cities ci ON l.cityId = ci.cityId
INNER JOIN states s ON ci.stateId = s.stateId
INNER JOIN countries co ON s.countryId = co.countryId
INNER JOIN companies comp ON p.companyId = comp.companyId
WHERE cl.operationType = 1
GROUP BY p.producerId, p.name, cl.operationType, co.name, s.name, ci.name, l.zipcode, l.latitude, l.longitude, comp.companyName, cl.wasteCollectorId;

SELECT c.wasteCollectorId AS collectorId, c.name AS collectorName, cl.weight, cl.operationType,
       co.name AS collectorCountry, s.name AS collectorState, ci.name AS collectorCity,
       lc.zipcode AS collectorZipcode, lc.latitude AS collectorLatitude, lc.longitude AS collectorLongitude,
       c.companyId AS collectorCompany
FROM containerLogs cl
INNER JOIN wasteCollectors c ON cl.wasteCollectorId = c.wasteCollectorId
INNER JOIN locations lc ON c.locationId = lc.locationId
INNER JOIN cities ci ON lc.cityId = ci.cityId
INNER JOIN states s ON ci.stateId = s.stateId
INNER JOIN countries co ON s.countryId = co.countryId
WHERE cl.operationType = 1;

SELECT c.wasteCollectorId AS collectorId, c.name AS collectorName, 
       SUM(cl.weight) AS totalWeight, cl.operationType,
       co.name AS collectorCountry, s.name AS collectorState, ci.name AS collectorCity,
       lc.zipcode AS collectorZipcode, lc.latitude AS collectorLatitude, lc.longitude AS collectorLongitude,
       c.companyId AS collectorCompany
FROM containerLogs cl
INNER JOIN wasteCollectors c ON cl.wasteCollectorId = c.wasteCollectorId
INNER JOIN locations lc ON c.locationId = lc.locationId
INNER JOIN cities ci ON lc.cityId = ci.cityId
INNER JOIN states s ON ci.stateId = s.stateId
INNER JOIN countries co ON s.countryId = co.countryId
WHERE cl.operationType = 1
GROUP BY c.wasteCollectorId, c.name, cl.operationType, co.name, s.name, ci.name, lc.zipcode, lc.latitude, lc.longitude, c.companyId;
