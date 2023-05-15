export const queries = {    
    // Queries for containers
    getAllContainers: 'SELECT TOP 10 * FROM contacts',
    getContainersByWaste: 'EXEC GetUnusedContainersForWasteType @wasteTypeId = @Id',
    // Queries for contacts
    getAllContacts: 'SELECT * FROM contacts',
    getLast10Contacts: 'SELECT TOP 10 * FROM contacts ORDER BY contactId DESC',
    createNewContact: 'INSERT INTO contacts (name, surname1, surname2, email, phone, notes, contactType) VALUES (@name, @surname1, @surname2, @email, @phone, @notes, @contactType)',
    getLast10ContactsByType: 'EXEC GetLastNContactsByType @contactType = @type, @N = @quantity',
}