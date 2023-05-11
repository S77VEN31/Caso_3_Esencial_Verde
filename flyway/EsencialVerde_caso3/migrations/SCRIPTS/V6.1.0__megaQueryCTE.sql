-----------------------------------------------------------
-- Autor: joseGranados & stivenGuzman
-- Fecha: 30/04/2023
-- Descripcion: same  megaQuery but with improvements and CTE (Common Table Expression) and others
-----------------------------------------------------------
DROP INDEX contacts.idx_contacts_contactId;
DROP INDEX invoices.idx_invoices_buyerContact;

CREATE INDEX idx_contacts_contactId ON contacts (contactId);
CREATE INDEX idx_invoices_buyerContact ON invoices (buyerContact);

WITH cteContactInvoices AS (
    SELECT c.contactId, c.name, c.surname1, 
           MAX(i.postdate) AS lastInvoiceDate, 
           COUNT(i.invoiceId) AS totalInvoices,
           SUM(p.amount) AS totalPayments
    FROM contacts c
    LEFT JOIN invoices i ON c.contactId = i.buyerContact
    INNER JOIN payments p ON i.invoiceId = p.invoiceId
    GROUP BY c.contactId, c.name, c.surname1
    HAVING COUNT(i.invoiceId) >= 1
), cteFilteredInvoices AS (
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
)
SELECT *
FROM cteContactInvoices
EXCEPT
SELECT *
FROM cteFilteredInvoices
ORDER BY totalInvoices DESC
FOR JSON AUTO;

