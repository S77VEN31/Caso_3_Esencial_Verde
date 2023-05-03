SELECT c.customerId, 
       t.translationValue AS customerName, 
       SUM(p.amount) AS totalPayments
FROM customers c
INNER JOIN invoices i ON c.customerId = i.customerId
INNER JOIN payments p ON i.invoiceId = p.invoiceId
INNER JOIN translations t ON t.translationKey = c.customerName AND t.textObjectTypeId = 1
WHERE c.active = 1
GROUP BY c.customerId, t.translationValue
EXCEPT
SELECT c.customerId, 
       t.translationValue AS customerName, 
       SUM(p.amount) AS totalPayments
FROM customers c
INNER JOIN invoices i ON c.customerId = i.customerId
INNER JOIN payments p ON i.invoiceId = p.invoiceId
INNER JOIN translations t ON t.translationKey = c.customerName AND t.textObjectTypeId = 1
WHERE c.active = 1 AND YEAR(p.paymentDate) = 2022
GROUP BY c.customerId, t.translationValue
FOR JSON AUTO;
