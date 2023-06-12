SELECT p.producerId, p.name AS producerName, SUM(cl.weight) AS accumulatedWeight, cl.operationType,
       co.name AS collectorCountry, s.name AS collectorState, ci.name AS collectorCity,
       comp.companyName AS producerCompany, cl.wasteCollectorId, wc.name AS wasteCollectorName,
       co_p.name AS producerCountry, s_p.name AS producerState, ci_p.name AS producerCity
FROM containerLogs cl
INNER JOIN producers p ON cl.producerId = p.producerId
INNER JOIN locations l ON cl.wasteCollectorId = l.locationId
INNER JOIN cities ci ON l.cityId = ci.cityId
INNER JOIN states s ON ci.stateId = s.stateId
INNER JOIN countries co ON s.countryId = co.countryId
INNER JOIN companies comp ON p.companyId = comp.companyId
INNER JOIN wasteCollectors wc ON cl.wasteCollectorId = wc.wasteCollectorId
INNER JOIN locations lp ON p.locationId = lp.locationId
INNER JOIN cities ci_p ON lp.cityId = ci_p.cityId
INNER JOIN states s_p ON ci_p.stateId = s_p.stateId
INNER JOIN countries co_p ON s_p.countryId = co_p.countryId
WHERE cl.operationType = 1
GROUP BY p.producerId, p.name, cl.operationType, co.name, s.name, ci.name, comp.companyName, cl.wasteCollectorId, wc.name, co_p.name, s_p.name, ci_p.name;



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
