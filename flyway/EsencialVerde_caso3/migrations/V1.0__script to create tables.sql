-----------------------------------------------------------
-- Autor: joseGranados & stivenGuzman
-- Fecha: 29/04/2023
-- Descripcion: script to create tables
-- Now all fixes are done
-----------------------------------------------------------
CREATE TABLE countries (   
    countryId INT NOT NULL PRIMARY KEY IDENTITY,      
    name VARCHAR(50) NOT NULL,            
    nameCode VARCHAR(2) NOT NULL,
    phoneCode INT NOT NULL
);

CREATE TABLE states (
    stateId INT PRIMARY KEY IDENTITY,
    name VARCHAR(50) NOT NULL,
    countryId INT NOT NULL,
    FOREIGN KEY (countryId) REFERENCES countries(countryId)
);

CREATE TABLE cities (
    cityId INT NOT NULL PRIMARY KEY IDENTITY,
    name VARCHAR(50) NOT NULL,
    stateId INT FOREIGN KEY REFERENCES states(stateId)
);

CREATE TABLE locations (
    locationId INT NOT NULL PRIMARY KEY IDENTITY,
    latitude DECIMAL(10, 8) NOT NULL,
    longitude DECIMAL(10, 8) NOT NULL,
    zipcode INT NOT NULL,
    cityId INT NOT NULL,
    FOREIGN KEY (cityId) REFERENCES cities(cityId)
);

CREATE TABLE regionAreas (
    regionAreasId INT NOT NULL PRIMARY KEY IDENTITY,
    name VARCHAR(255) NOT NULL,
    cityId INT,
    stateId INT,
    countryId INT,
    FOREIGN KEY (cityId) REFERENCES cities(cityId),
    FOREIGN KEY (stateId) REFERENCES states(stateId),
    FOREIGN KEY (countryId) REFERENCES countries(countryId)
);

CREATE TABLE regions (
    regionId INT NOT NULL PRIMARY KEY IDENTITY,
    name VARCHAR(255) NOT NULL,
    regionAreaId INT NOT NULL,
    FOREIGN KEY (regionAreaId) REFERENCES regionAreas(regionAreasId)
);

CREATE TABLE contacts (
    contactId INT NOT NULL PRIMARY KEY IDENTITY,
    name VARCHAR(255) NOT NULL,
    surname1 VARCHAR(255) NOT NULL,
    surname2 VARCHAR(255),
    email VARCHAR(255),
    phone VARCHAR(20),
    notes VARCHAR(255),
    contactType VARCHAR(255) NOT NULL,
    active BIT NOT NULL DEFAULT 1,
    createAt DATE NOT NULL DEFAULT GETDATE(),
    updateAt DATE NOT NULL DEFAULT GETDATE(),
    checksum VARBINARY(64) NOT NULL
);

CREATE TABLE companyCategories (
    companyCategoryId INT NOT NULL PRIMARY KEY IDENTITY,
    name VARCHAR(255) NOT NULL,
    description VARCHAR(255)
);

CREATE TABLE companies (
    companyId INT NOT NULL PRIMARY KEY IDENTITY,
    companyName VARCHAR(255) NOT NULL,
    companyCategoryId INT, 
    isLocal BIT NOT NULL DEFAULT 1,
    carbonFootprint DECIMAL(10, 2),
    active BIT NOT NULL DEFAULT 1,
    createAt DATE NOT NULL DEFAULT GETDATE(),
    updateAt DATE NOT NULL DEFAULT GETDATE(),
    checksum VARBINARY(64) NOT NULL,
    FOREIGN KEY (companyCategoryId) REFERENCES companyCategories(companyCategoryId)
);

CREATE TABLE sponsorCompanies (
    sponsorId INT NOT NULL PRIMARY KEY IDENTITY,
    sponsorCompany INT NOT NULL,
    percentage DECIMAL(3, 2) NOT NULL,  -- Based in if carbon footprint >= 44
    reason VARCHAR(255) NOT NULL,
    sponsoredRegionId INT NOT NULL,
    active BIT NOT NULL DEFAULT 1,
    createAt DATE NOT NULL DEFAULT GETDATE(),
    updateAt DATE NOT NULL DEFAULT GETDATE(),
    checksum VARBINARY(64) NOT NULL,
    FOREIGN KEY (sponsorCompany) REFERENCES companies(companyId),
    FOREIGN KEY (sponsoredRegionId) REFERENCES regions(regionId)
)

CREATE TABLE producers (
    producerId INT NOT NULL PRIMARY KEY IDENTITY,
    name VARCHAR(255) NOT NULL,
    locationId INT NOT NULL,
    companyId INT,
    balance DECIMAL(10, 2) NOT NULL,
    active BIT NOT NULL DEFAULT 1,
    createAt DATE NOT NULL DEFAULT GETDATE(),
    updateAt DATE NOT NULL DEFAULT GETDATE(),
    checksum VARBINARY(64) NOT NULL,
    FOREIGN KEY (locationId) REFERENCES locations(locationId),
    FOREIGN KEY (companyId) REFERENCES companies(companyId)
);

CREATE TABLE wasteTreatmentSites (
    siteId INT PRIMARY KEY IDENTITY,
    name VARCHAR(255) NOT NULL,
    locationId INT NOT NULL,
    active BIT NOT NULL DEFAULT 1,
    createAt DATE NOT NULL DEFAULT GETDATE(),
    updateAt DATE NOT NULL DEFAULT GETDATE(),
    checksum VARBINARY(64) NOT NULL,
    FOREIGN KEY (locationId) REFERENCES locations(locationId),
);

CREATE TABLE producerXcontacts (
    producerId INT NOT NULL,
    contactId INT NOT NULL,
    FOREIGN KEY (producerId) REFERENCES producers(producerId),
    FOREIGN KEY (contactId) REFERENCES contacts(contactId)
);

CREATE TABLE companiesXcontacts (
    companyId INT NOT NULL,
    contactId INT NOT NULL,
    FOREIGN KEY (companyId) REFERENCES companies(companyId),
    FOREIGN KEY (contactId) REFERENCES contacts(contactId)
);

CREATE TABLE wasteTreatmentSitesXContacts (
    wasteTreatmentSiteId INT NOT NULL,
    contactId INT NOT NULL,
    
    FOREIGN KEY (wasteTreatmentSiteId) REFERENCES wasteTreatmentSites(siteId),
    FOREIGN KEY (contactId) REFERENCES contacts(contactId)
);

CREATE TABLE wasteCollectors (
    wasteCollectorId INT NOT NULL PRIMARY KEY IDENTITY,
    name VARCHAR(255) NOT NULL,
    locationId INT NOT NULL,
    companyId INT,
    active BIT NOT NULL DEFAULT 1,
    createAt DATE NOT NULL DEFAULT GETDATE(),
    updateAt DATE NOT NULL DEFAULT GETDATE(),
    checksum VARBINARY(64) NOT NULL,
    FOREIGN KEY (locationId) REFERENCES locations(locationId),
    FOREIGN KEY (companyId) REFERENCES companies(companyId)
);

CREATE TABLE  wasteCollectorsXcontacts (
    wasteCollectorId  INT NOT NULL,
    contactId INT NOT NULL,
    FOREIGN KEY (wasteCollectorId) REFERENCES wasteCollectors(wasteCollectorId),
    FOREIGN KEY (contactId) REFERENCES contacts(contactId)
);

CREATE TABLE treatmentMethods (
    methodId INT NOT NULL PRIMARY KEY IDENTITY,
    name VARCHAR(255) NOT NULL,
    description VARCHAR(255),
    active BIT NOT NULL DEFAULT 1
);

CREATE TABLE wasteTypes (
    wasteTypeId INT NOT NULL PRIMARY KEY IDENTITY,
    name VARCHAR(255) NOT NULL,
    description VARCHAR(255)
);

CREATE TABLE wasteTypesXtreatmentMethods (
    wasteTypeTreatmentMethodId INT NOT NULL PRIMARY KEY IDENTITY,
    wasteTypeId INT NOT NULL,
    methodId INT NOT NULL,
    pollutionLevel INT NOT NULL,
    FOREIGN KEY (wasteTypeId) REFERENCES wasteTypes(wasteTypeId),
    FOREIGN KEY (methodId) REFERENCES treatmentMethods(methodId)
);

CREATE TABLE countryTreatmentCost (
    countryTreatmentCostId INT NOT NULL PRIMARY KEY IDENTITY,
    treatmentMethodId INT NOT NULL,
    countryId INT NOT NULL,
    cost DECIMAL(10, 2),
    active BIT NOT NULL DEFAULT 1,
    createAt DATE NOT NULL DEFAULT GETDATE(),
    updateAt DATE NOT NULL DEFAULT GETDATE(),
    checksum VARBINARY(64) NOT NULL,
    FOREIGN KEY (treatmentMethodId) REFERENCES treatmentMethods(methodId),
    FOREIGN KEY (countryId) REFERENCES countries(countryId)
);

CREATE TABLE recycledProduct (
    recycledProductId INT NOT NULL PRIMARY KEY IDENTITY,
    wasteTypeTreatmentMethodId INT NOT NULL,
    name VARCHAR(255) NOT NULL,
    price DECIMAL(10, 2),       -- Can be null in case of donations
    createAt DATE NOT NULL DEFAULT GETDATE(),
    updateAt DATE NOT NULL DEFAULT GETDATE(),
    checksum VARBINARY(64) NOT NULL,
    FOREIGN KEY (wasteTypeTreatmentMethodId) REFERENCES wasteTypesXtreatmentMethods(wasteTypeTreatmentMethodId)
);

CREATE TABLE materials (
    materialId INT NOT NULL PRIMARY KEY IDENTITY,
    name VARCHAR(255) NOT NULL,
    description VARCHAR(255)
);

CREATE TABLE recycledProductXmaterials (
    recycledProductXmaterialId INT NOT NULL PRIMARY KEY IDENTITY,
    recycledProductId INT NOT NULL,
    materialId INT NOT NULL,
    treatmentXcountriesPriceLogsId INT NOT NULL,
    quantity INT NOT NULL,                      -- In kilos
    active BIT NOT NULL DEFAULT 1,
    FOREIGN KEY (recycledProductId) REFERENCES recycledProduct(recycledProductId),
    FOREIGN KEY (materialId) REFERENCES materials(materialId)
);

CREATE TABLE producerXmaterialPricesLogs (
    logId INT NOT NULL PRIMARY KEY IDENTITY,
    recycledProductXmaterialId INT NOT NULL,
    producerId INT NOT NULL,
    productionPrice DECIMAL(10, 2) NOT NULL,
    producerComision DECIMAL(3, 2) NOT NULL,
    createAt DATE NOT NULL DEFAULT GETDATE(),
    updateAt DATE NOT NULL DEFAULT GETDATE(),
    checksum VARBINARY(64) NOT NULL,
    FOREIGN KEY (recycledProductXmaterialId) REFERENCES recycledProductXmaterials(recycledProductXmaterialId),
    FOREIGN KEY (producerId) REFERENCES producers(producerId)
);

CREATE TABLE recycledProductSale (
    recycledProductSaleId INT NOT NULL PRIMARY KEY IDENTITY,
    recycledProductId INT NOT NULL,
    producerId INT NOT NULL,
    saleDate DATE NOT NULL,
    sellerContact INT NOT NULL,
    buyerContact INT NOT NULL,
    createAt DATE NOT NULL DEFAULT GETDATE(),
    updateAt DATE NOT NULL DEFAULT GETDATE(),
    checksum VARBINARY(64) NOT NULL,
    FOREIGN KEY (sellerContact) REFERENCES contacts(contactId),
    FOREIGN KEY (buyerContact) REFERENCES contacts(contactId),
    FOREIGN KEY (recycledProductId) REFERENCES recycledProduct(recycledProductId),
    FOREIGN KEY (producerId) REFERENCES producers(producerId)
);

CREATE TABLE trainingTypes (
    trainingTypeId INT NOT NULL PRIMARY KEY IDENTITY,
    name VARCHAR(255) NOT NULL,
    wasteTypeTreatmentMethodId INT NOT NULL,
    description VARCHAR(255),               --Other things to consider
    FOREIGN KEY (wasteTypeTreatmentMethodId) REFERENCES wasteTypesXtreatmentMethods(wasteTypeTreatmentMethodId)
);

CREATE TABLE trainingLogs (
    trainingId INT NOT NULL PRIMARY KEY IDENTITY,
    startTime DATETIME NOT NULL,
    endTime DATETIME NOT NULL,
    trainingTypeId INT NOT NULL,
    FOREIGN KEY (trainingTypeId) REFERENCES trainingTypes(trainingTypeId)
);

CREATE TABLE trainingAttendances (
    attendanceId INT NOT NULL PRIMARY KEY IDENTITY,
    trainingId INT NOT NULL,
    wasteCollectorId INT, 
    FOREIGN KEY (trainingId) REFERENCES trainingLogs(trainingId),
    FOREIGN KEY (wasteCollectorId) REFERENCES wasteCollectors(wasteCollectorId),
);

CREATE TABLE certificates (
    certificateId INT NOT NULL PRIMARY KEY IDENTITY,
    certificateTypeId INT NOT NULL,
    attendanceId INT NOT NULL,
    expiration DATE NOT NULL,
    certificateStatus BIT NOT NULL,
    additionalInfo VARCHAR(255),
    wasteCollectorId INT, 
    FOREIGN KEY (wasteCollectorId) REFERENCES wasteCollectors(wasteCollectorId),
    FOREIGN KEY (certificateTypeId) REFERENCES wasteTypesXtreatmentMethods(wasteTypeTreatmentMethodId),
    FOREIGN KEY (attendanceId) REFERENCES trainingLogs(trainingId)
);

CREATE TABLE containers (
    containerId INT NOT NULL PRIMARY KEY IDENTITY,
    manufacturerInfo VARCHAR(255) NOT NULL,
    isInUse BIT NOT NULL DEFAULT 0,
    maxWeight DECIMAL(10, 2),
    currentWeight DECIMAL(10, 2),
    active BIT NOT NULL DEFAULT 1
);

CREATE TABLE containersXwasteTypes (
    containerId INT NOT NULL,
    wasteTypeId INT NOT NULL,
    FOREIGN KEY (containerId) REFERENCES containers(containerId),
    FOREIGN KEY (wasteTypeId) REFERENCES wasteTypes(wasteTypeId)
);

CREATE TABLE pickupSchedules (
    pickupScheduleId INT NOT NULL PRIMARY KEY IDENTITY,
    startTime TIME NOT NULL,
    endTime TIME NOT NULL,
    producerId INT NOT NULL, -- De cual productor es el desecho
    siteId INT NOT NULL, -- Hacia que sitio de tratamiento va
    frequency INT NOT NULL, -- daily 1, weekly 2, monthly 3
    pickupDay INT NOT NULL, -- Sunday 1, Monday 2, Tuesday 3, Wednesday 4, Thursday 5, Friday 6, Saturday 7
    wasteTypeId INT NOT NULL,
    createAt DATE NOT NULL DEFAULT GETDATE(),
    updateAt DATE NOT NULL DEFAULT GETDATE(),
    checksum VARBINARY(64) NOT NULL,
    FOREIGN KEY (siteId) REFERENCES wasteTreatmentSites(siteId),
    FOREIGN KEY (producerId) REFERENCES producers(producerId),
    FOREIGN KEY (wasteTypeId) REFERENCES wasteTypes(wasteTypeId),
);

CREATE TABLE carriers ( -- Tabla con el registro de los transportistas y donde pertenecen
    carrierId INT NOT NULL PRIMARY KEY,
    siteId INT,
    wasteCollectorId INT, 
    producerId INT,
    FOREIGN KEY (producerId) REFERENCES producers(producerId),
    FOREIGN KEY (siteId) REFERENCES wasteTreatmentSites(siteId),
    FOREIGN KEY (wasteCollectorId) REFERENCES wasteCollectors(wasteCollectorId),
);

CREATE TABLE carriersXcontacts (
    carrierId INT NOT NULL,
    contactId INT NOT NULL,
    FOREIGN KEY (carrierId) REFERENCES carriers(carrierId),
    FOREIGN KEY (contactId) REFERENCES contacts(contactId)
);

CREATE TABLE vehicleTypes (
    typeId INT NOT NULL PRIMARY KEY,
    typeName VARCHAR(255) NOT NULL
);

CREATE TABLE brands (
    brandId INT NOT NULL PRIMARY KEY,
    brandName VARCHAR(255) NOT NULL
);

CREATE TABLE models (
    modelId INT NOT NULL PRIMARY KEY,
    modelName VARCHAR(255) NOT NULL,    
    typeId INT NOT NULL REFERENCES vehicleTypes(typeId),
    brandId INT NOT NULL REFERENCES brands(brandId)
);

CREATE TABLE fleet (
    fleetId INT NOT NULL PRIMARY KEY IDENTITY,
    modelId INT NOT NULL FOREIGN KEY REFERENCES models(modelId),
    color VARCHAR(7) NOT NULL,
    active BIT NOT NULL DEFAULT 1
);

CREATE TABLE fleetXwasteTypes (
    fleetId INT NOT NULL,
    wasteTypeId INT NOT NULL,
    FOREIGN KEY (fleetId) REFERENCES fleet(fleetId),
    FOREIGN KEY (wasteTypeId) REFERENCES wasteTypes(wasteTypeId)
);

CREATE TABLE containerLogs ( -- Trasabilidad de los contenedores
    logId INT PRIMARY KEY IDENTITY,
    logDate DATE NOT NULL,
    pickupScheduleId INT NOT NULL,
    containerId INT NOT NULL,
    countryTreatmentCost INT NOT NULL,
    carrierId INT NOT NULL,
    fleetId INT, -- Puede ser null al pertenecer a otra empresa
    weight DECIMAL(10, 2) NOT NULL,
    operationType INT NOT NULL, -- 1: pickup, 2: delivery, 3: transfer, 4: cleaning, 5: maintenance, 6: repair
    FOREIGN KEY (fleetId) REFERENCES fleet(fleetId),
    FOREIGN KEY (countryTreatmentCost) REFERENCES countries(countryId),
    FOREIGN KEY (carrierId) REFERENCES carriers(carrierId),
    FOREIGN KEY (pickupScheduleId) REFERENCES pickupSchedules(pickupScheduleId),
    FOREIGN KEY (containerId) REFERENCES containers(containerId) 
);

CREATE TABLE currencies (                  
    currencyId INT NOT NULL PRIMARY KEY IDENTITY,
    code varchar(3) NOT NULL,
    name varchar(50) NOT NULL,
    symbol varchar(5) NOT NULL,
    defaultCurrency BIT NOT NULL DEFAULT 0
);

CREATE TABLE currencyRates (              
    currencyRateId INT NOT NULL PRIMARY KEY IDENTITY,
    currencyFrom INT NOT NULL,
    currencyTo INT NOT NULL,
    rate decimal(10, 4) NOT NULL,
    createAt DATE NOT NULL DEFAULT GETDATE(),
    updateAt DATE NOT NULL DEFAULT GETDATE(),
    checksum VARBINARY(64) NOT NULL,
    FOREIGN KEY (currencyTo) REFERENCES currencies(currencyId)
);

CREATE TABLE treatmentMethodsXcountries (
    treatmentMethodXcountriesId INT NOT NULL PRIMARY KEY IDENTITY,
    countryId INT NOT NULL,
    treatmentMethodId INT NOT NULL,
    FOREIGN KEY (countryId) REFERENCES countries(countryId),
    FOREIGN KEY (treatmentMethodId) REFERENCES wasteTypesXtreatmentMethods(wasteTypeTreatmentMethodId)    
);

CREATE TABLE treatmentXcountriesPriceLogs (
    logId INT NOT NULL PRIMARY KEY IDENTITY,
    treatmentMethodXcountriesId INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    createAt DATE NOT NULL DEFAULT GETDATE(),
    updateAt DATE NOT NULL DEFAULT GETDATE(),
    checksum VARBINARY(64) NOT NULL,
    active BIT NOT NULL DEFAULT 1,
    FOREIGN KEY (treatmentMethodXcountriesId) REFERENCES treatmentMethodsXcountries(treatmentMethodXcountriesId)
)

CREATE TABLE containersStockLogs (
    logId INT NOT NULL PRIMARY KEY IDENTITY,
    wasteCollectorId INT NOT NULL,
    wasteTypeId INT NOT NULL,
    conteinerSize INT NOT NULL, -- small 1, medium 2, large 3
    action INT NOT NULL, -- request 1, return 2
    amount INT NOT NULL,
    pastAmount INT NOT NULL,
    createAt DATE NOT NULL DEFAULT GETDATE(),
    updateAt DATE NOT NULL DEFAULT GETDATE(),
    checksum VARBINARY(64) NOT NULL,
    FOREIGN KEY (wasteCollectorId) REFERENCES wasteCollectors(wasteCollectorId),
    FOREIGN KEY (wasteTypeId) REFERENCES wasteTypes(wasteTypeId)
);

CREATE TABLE contractTypes (        -- TO DO
    contractTypeId INT NOT NULL PRIMARY KEY IDENTITY,
    contractTypeName VARCHAR(255) NOT NULL
);

CREATE TABLE contracts (            -- TO DO
    contractId INT NOT NULL PRIMARY KEY IDENTITY,
    contractTypeId INT NOT NULL,
    wasteCollectorId INT,
    producerId INT NOT NULL,
    countryId INT NOT NULL,
    startDate DATE NOT NULL,
    endDate DATE NOT NULL,
    contractCreator INT NOT NULL,
    contractSigner INT NOT NULL,
    active BIT NOT NULL DEFAULT 1,
    createAt DATE NOT NULL DEFAULT GETDATE(),
    updateAt DATE NOT NULL DEFAULT GETDATE(),
    checksum VARBINARY(64) NOT NULL,
    FOREIGN KEY (contractTypeId) REFERENCES contractTypes(contractTypeId),
    FOREIGN KEY (wasteCollectorId) REFERENCES wasteCollectors(wasteCollectorId),
    FOREIGN KEY (producerId) REFERENCES producers(producerId),
    FOREIGN KEY (contractCreator) REFERENCES contacts(contactId),
    FOREIGN KEY (contractSigner) REFERENCES contacts(contactId)
);

CREATE TABLE contractsXtretmentPriceLogs ( -- TO DO
    contractId INT NOT NULL,
    treatmentXcountriesPriceLogs INT NOT NULL,
    specialPrice INT,
    pickupScheduleId INT NOT NULL,    
    createAt DATE NOT NULL DEFAULT GETDATE(),
    updateAt DATE NOT NULL DEFAULT GETDATE(),
    checksum VARBINARY(64) NOT NULL,
    FOREIGN KEY (contractId) REFERENCES contracts(contractId),
    FOREIGN KEY (treatmentXcountriesPriceLogs) REFERENCES treatmentXcountriesPriceLogs(logId),
    FOREIGN KEY (pickupScheduleId) REFERENCES pickupSchedules(pickupScheduleId)
);

CREATE TABLE eventTypes (
    eventTypeId INT NOT NULL PRIMARY KEY IDENTITY,
    eventTypeName VARCHAR(50) NOT NULL,
    eventTypeDescription VARCHAR(255) NOT NULL
);

CREATE TABLE eventSources (
    eventSourceId INT NOT NULL PRIMARY KEY IDENTITY,
    eventSourceName VARCHAR(50) NOT NULL
);

CREATE TABLE eventStatus (
    eventStatusId INT NOT NULL PRIMARY KEY IDENTITY,
    eventStatusName VARCHAR(50) NOT NULL,
    eventStatusDescription VARCHAR(255) NOT NULL
);

CREATE TABLE eventLogs (
    eventId INT NOT NULL PRIMARY KEY IDENTITY,
    date DATE NOT NULL,
    time TIME NOT NULL,
    eventTypeId INT NOT NULL,
    eventSourceId INT NOT NULL,
    eventStatusId INT NOT NULL,
    logMessage VARCHAR(255) NOT NULL,
    logDetails VARCHAR(255) NOT NULL,
    FOREIGN KEY (eventTypeId) REFERENCES eventTypes(eventTypeId),
    FOREIGN KEY (eventSourceId) REFERENCES eventSources(eventSourceId),
    FOREIGN KEY (eventStatusId) REFERENCES eventStatus(eventStatusId)
);

CREATE TABLE invoices (                  -- Tema Deudas
    invoiceId INT NOT NULL PRIMARY KEY IDENTITY,
    number VARCHAR(50) NOT NULL,    -- Numero de factura, se puede manejar para esa empresa en particular
    postdate DATE NOT NULL,
    posttime TIME NOT NULL,
    duedate DATE NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    status VARCHAR(50) NOT NULL,
    sellerContact INT NOT NULL,
    buyerContact INT NOT NULL,
    companyId INT NOT NULL,
    details VARCHAR(255) NOT NULL,
    createAt DATE NOT NULL DEFAULT GETDATE(),
    updateAt DATE NOT NULL DEFAULT GETDATE(),
    checksum VARBINARY(64) NOT NULL,
    FOREIGN KEY (companyId) REFERENCES companies(companyId),
    FOREIGN KEY (sellerContact) REFERENCES contacts(contactId),
    FOREIGN KEY (buyerContact) REFERENCES contacts(contactId)
);

CREATE TABLE transactions(                      -- Tema Transacciones
    transactionId INT NOT NULL PRIMARY KEY IDENTITY,
    transactionDate DATE NOT NULL,
    transactionTime TIME NOT NULL,
    transactionType INT NOT NULL, -- 1: Debit, 2: Credit, 3: Transfer, 4:cash
    acountNumber VARCHAR(50), -- If transactionType is 3
    acountIban VARCHAR(50), -- If transactionType is 1 or 2
    currencyRateId INT NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    details VARCHAR(255) NOT NULL,
    createAt DATE NOT NULL DEFAULT GETDATE(),
    updateAt DATE NOT NULL DEFAULT GETDATE(),
    checksum VARBINARY(64) NOT NULL,
    FOREIGN KEY (currencyRateId) REFERENCES currencyRates(currencyRateId)
);

CREATE TABLE payments (                         -- Tema Pagos
    paymentId INT NOT NULL PRIMARY KEY IDENTITY,
    invoiceId INT NOT NULL,
    paymentDate DATE NOT NULL,
    paymentTime TIME NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    details VARCHAR(255) NOT NULL,
    transactionId INT NOT NULL,
    createAt DATE NOT NULL DEFAULT GETDATE(),
    updateAt DATE NOT NULL DEFAULT GETDATE(),
    checksum VARBINARY(64) NOT NULL,
    FOREIGN KEY (invoiceId) REFERENCES invoices(invoiceId),
    FOREIGN KEY (transactionId) REFERENCES transactions(transactionId)
);

CREATE TABLE languages (                 --Idiomas    
    languageId INT NOT NULL PRIMARY KEY IDENTITY,
    code VARCHAR(2) NOT NULL,
    name VARCHAR(50) NOT NULL
);

CREATE TABLE textObjectTypes (          --Objetos que tienen un atributo texto          
    textObjectTypeId INT NOT NULL PRIMARY KEY IDENTITY,
    textObjectTypeName VARCHAR(50) NOT NULL
);

CREATE TABLE translations (              --Traducciones para los objetos que tienen un atributo texto
    translationId INT NOT NULL PRIMARY KEY IDENTITY,
    transactionFrom INT NOT NULL,
    transactionTo INT NOT NULL,
    textObjectTypeId INT NOT NULL,
    translationKey VARCHAR(255) NOT NULL,
    translationValue VARCHAR(255) NOT NULL,
    FOREIGN KEY (transactionFrom) REFERENCES languages(languageId),
    FOREIGN KEY (transactionTo) REFERENCES languages(languageId),
    FOREIGN KEY (textObjectTypeId) REFERENCES textObjectTypes(textObjectTypeId)
);