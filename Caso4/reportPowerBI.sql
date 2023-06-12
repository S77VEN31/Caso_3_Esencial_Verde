-- Select para el reporte de Power BI
SELECT
	co.name AS country,
	com.companyName AS company,
	wt.name AS wasteType,
	i.postdate,
	SUM(i.amount) AS totalCollected,
	SUM(ctc.cost * i.amount) AS totalCostProcessed,
	SUM(ctc.cost * i.amount) - SUM(ctc.cost * i.amount * wt2.cost) AS netProfit
FROM
	companies com
	INNER JOIN invoices i ON com.companyId = i.companyId
	INNER JOIN countries co ON com.countryId = co.countryId
	INNER JOIN wasteTypes wt ON i.wasteTypeId = wt.wasteTypeId
	INNER JOIN countryTreatmentCost ctc ON co.countryId = ctc.countryId
	LEFT JOIN (
SELECT
	wtm.wasteTypeId,
	ctc.cost
FROM
	countryTreatmentCost ctc
	INNER JOIN wasteTypesXtreatmentMethods wtm ON ctc.treatmentMethodId = wtm.methodId
	) wt2 ON wt.wasteTypeId = wt2.wasteTypeId
GROUP BY
	co.name,
	com.companyName,
	wt.name,
	i.postdate