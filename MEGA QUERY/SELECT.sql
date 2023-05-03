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