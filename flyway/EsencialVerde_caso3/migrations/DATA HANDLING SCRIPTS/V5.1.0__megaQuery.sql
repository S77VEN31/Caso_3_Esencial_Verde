-----------------------------------------------------------
-- Autor: joseGranados & stivenGuzman
-- Fecha: 30/04/2023
-- Descripcion: select with structure like join, group by, order by, for json, except and others
-----------------------------------------------------------
-- Este query realiza una consulta a dos tablas, "contacts" e "invoices", y devuelve información sobre los contactos que han hecho compras en la tienda. Para ello, utiliza una operación de "left join" para relacionar las dos tablas por medio de un campo llamado "buyerContact" en la tabla de "invoices", que contiene el ID del contacto que realizó la compra.
-- Luego, aplica dos funciones de agregación, "MAX" y "COUNT", para obtener la fecha de la última factura y el número total de facturas para cada contacto. Además, utiliza una cláusula "HAVING" para filtrar aquellos contactos que hayan realizado al menos una compra.
-- Finalmente, utiliza la cláusula "EXCEPT" para obtener aquellos contactos que cumplan con los criterios anteriores pero que no hayan realizado ninguna compra en el año 2022. Y, si se aplica la cláusula "ORDER BY", ordena el resultado de la consulta en base al nombre del contacto.
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
