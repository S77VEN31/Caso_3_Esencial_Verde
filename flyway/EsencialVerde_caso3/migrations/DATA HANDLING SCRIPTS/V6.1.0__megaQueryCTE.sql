-----------------------------------------------------------
-- Autor: joseGranados & stivenGuzman
-- Fecha: 30/04/2023
-- Descripcion: same  megaQuery but with improvements and CTE (Common Table Expression) and others
-----------------------------------------------------------
-- Las mejoras realizadas son:
-- Usar un CTE (Common Table Expression) para crear una tabla temporal "customer_payments" que contiene los datos
-- de clientes y pagos. Esto permite reutilizar la consulta en la subconsulta "customer_payments_2022" para obtener
--  solo los datos de clientes y pagos del año 2023, luego se puede filtrar mejor.
-- Utilizar el operador "EXCEPT" en lugar de "NOT IN" para mejorar la eficiencia del query.
-- Utilizar la cláusula "FOR JSON AUTO" para generar la salida en formato JSON.
-- Crear un índice en la columna "active" de la tabla "contacts" para mejorar el rendimiento de la cláusula "WHERE"
-- en la consulta principal.
-- Crear un índice en la columna "paymentDate" de la tabla "payments" para mejorar el rendimiento de la cláusula
-- "WHERE" en la subconsulta "customer_payments_2022".

WITH customer_payments AS (
    SELECT c.contactId, 
           t.translationValue AS customerName, 
           SUM(p.amount) AS totalPayments
    FROM contacts c
    INNER JOIN invoices i ON c.contactId = i.buyerContact
    INNER JOIN payments p ON i.invoiceId = p.invoiceId
    INNER JOIN translations t ON t.translationKey = c.name AND t.textObjectTypeId = 1
    WHERE c.active = 1
    GROUP BY c.contactId, t.translationValue
),
customer_payments_2022 AS (
    SELECT c.contactId, 
           t.translationValue AS customerName, 
           SUM(p.amount) AS totalPayments
    FROM contacts c
    INNER JOIN invoices i ON c.contactId = i.buyerContact
    INNER JOIN payments p ON i.invoiceId = p.invoiceId
    INNER JOIN translations t ON t.translationKey = c.name AND t.textObjectTypeId = 1
    WHERE c.active = 1 AND YEAR(p.paymentDate) = 2022
    GROUP BY c.contactId, t.translationValue
)
SELECT cp.contactId, cp.customerName, cp.totalPayments
FROM customer_payments cp
EXCEPT
SELECT cp_2022.contactId, cp_2022.customerName, cp_2022.totalPayments
FROM customer_payments_2022 cp_2022
FOR JSON AUTO;
