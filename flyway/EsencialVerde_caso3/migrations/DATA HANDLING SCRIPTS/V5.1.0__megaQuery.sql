-----------------------------------------------------------
-- Autor: joseGranados & stivenGuzman
-- Fecha: 30/04/2023
-- Descripcion: select with structure like join, group by, order by, for json, except and others
-----------------------------------------------------------
SELECT c.contactId, c.name, c.surname1, 
       MAX(i.postdate) AS lastInvoiceDate, 
       COUNT(i.invoiceId) AS totalInvoices,
       SUM(p.amount) AS totalPayments
FROM contacts c
LEFT JOIN invoices i ON c.contactId = i.buyerContact
INNER JOIN payments p ON i.invoiceId = p.invoiceId
GROUP BY c.contactId, c.name, c.surname1
HAVING COUNT(i.invoiceId) >= 1
EXCEPT
SELECT c.contactId, c.name, c.surname1, 
       MAX(i.postdate) AS lastInvoiceDate, 
       COUNT(i.invoiceId) AS totalInvoices,
       SUM(p.amount) AS totalPayments
FROM contacts c
LEFT JOIN invoices i ON c.contactId = i.buyerContact
INNER JOIN payments p ON i.invoiceId = p.invoiceId
WHERE i.postdate >= '2022-01-01'
GROUP BY c.contactId, c.name, c.surname1
HAVING COUNT(i.invoiceId) >= 1
ORDER BY totalInvoices DESC;