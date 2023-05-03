-El query busca obtener información de las facturas creadas por un cliente en particular y mostrar la cantidad total que ha pagado en cada moneda en que se le ha facturado.
-Primero se hace un JOIN de las tablas invoices, payments y customers para obtener la información de la factura, el pago y el cliente al que pertenece la factura. Luego se hace un LEFT JOIN con la tabla transactions para obtener el nombre de la moneda en la que se hizo el pago.
-A continuación, se usa la función de agregación SUM para sumar los montos pagados por el cliente en cada moneda y se agrupa la información por el nombre de la moneda.
-El resultado se ordena de forma descendente por el monto total pagado en cada moneda y se utiliza la cláusula FOR JSON para formatear la salida en formato JSON. Por último, se utiliza la cláusula EXCEPT para excluir cualquier factura que tenga un monto total pagado de cero.

SELECT c.contactId, 
    t.translationValue AS customerName, 
        SUM(p.amount) AS totalPayments
    FROM contacts c
    INNER JOIN invoices i ON c.contactId = i.buyerContact
    INNER JOIN payments p ON i.invoiceId = p.invoiceId
    INNER JOIN translations t ON t.translationKey = c.name AND t.textObjectTypeId = 1
    WHERE c.active = 1
    GROUP BY c.contactId, t.translationValue
    EXCEPT
    SELECT c.contactId, 
        t.translationValue AS customerName, 
        SUM(p.amount) AS totalPayments
    FROM contacts c
    INNER JOIN invoices i ON c.contactId = i.buyerContact
    INNER JOIN payments p ON i.invoiceId = p.invoiceId
    INNER JOIN translations t ON t.translationKey = c.name AND t.textObjectTypeId = 1
    WHERE c.active = 1 AND YEAR(p.paymentDate) = 2022
    GROUP BY c.contactId, t.translationValue
    FOR JSON AUTO;