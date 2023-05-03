CREATE TABLE countries (   
    countryId INT NOT NULL PRIMARY KEY IDENTITY,                  
    code VARCHAR(3) NOT NULL,
    name VARCHAR(50) NOT NULL
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
    geoLocation POINT NOT NULL,
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
    FOREIGN KEY (regionAreaId) REFERENCES regionAreas(regionAreaId)
);

CREATE TABLE contactTypes (
    contactTypeId INT NOT NULL PRIMARY KEY IDENTITY,
    typeName VARCHAR(255) NOT NULL
);

CREATE TABLE contacts (
    contactId INT NOT NULL PRIMARY KEY IDENTITY,
    name VARCHAR(255) NOT NULL,
    surname1 VARCHAR(255) NOT NULL,
    surname2 VARCHAR(255),
    position VARCHAR(255),
    password VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    notes VARCHAR(255),
    postDate DATE NOT NULL,
    contactTypeId INT NOT NULL,
    active BIT NOT NULL DEFAULT 1,
    FOREIGN KEY (contactTypeId) REFERENCES contactTypes(contactTypeId),
    FOREIGN KEY (address) REFERENCES locations(locationId)
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
    FOREIGN KEY (companyCategoryId) REFERENCES companyCategories(companyCategoryId)
);

CREATE TABLE sponsors (
    sponsorId INT NOT NULL PRIMARY KEY IDENTITY,
    companyId INT NOT NULL,
    percentage DECIMAL(3, 2) NOT NULL,
    reason VARCHAR(255) NOT NULL,
    FOREIGN KEY (companyId) REFERENCES companies(companyId)
)

CREATE TABLE sponsored (
    sponsoredId INT NOT NULL PRIMARY KEY IDENTITY,
    companyId INT NOT NULL,
    reason VARCHAR(255) NOT NULL,
    FOREIGN KEY (companyId) REFERENCES companies(companyId)
)

CREATE TABLE sponsorsXsponsored (
    sponsorId INT NOT NULL,
    sponsoredId INT NOT NULL,
    FOREIGN KEY (sponsorId) REFERENCES sponsors(sponsorId),
    FOREIGN KEY (sponsoredId) REFERENCES sponsored(sponsoredId)
);

CREATE TABLE producers (
    producerId INT NOT NULL PRIMARY KEY IDENTITY,
    name VARCHAR(255) NOT NULL,
    locationId INT NOT NULL,
    companyId INT,
    FOREIGN KEY (locationId) REFERENCES locations(locationId),
    FOREIGN KEY (companyId) REFERENCES companies(companyId)
);

CREATE TABLE wasteTreatmentSites (
    siteId INT PRIMARY KEY IDENTITY,
    name VARCHAR(255) NOT NULL,
    locationId INT NOT NULL,
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
    description VARCHAR(255)
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

CREATE TABLE wasteTreatmentCostsXcountries (
    wasteTreatmentCostId INT NOT NULL PRIMARY KEY IDENTITY,
    wasteTypeTreatmentMethodId INT NOT NULL,
    countryId INT NOT NULL,
    cost DECIMAL(10, 2),
    FOREIGN KEY (countryId) REFERENCES countries(countryId)
    FOREIGN KEY (wasteTypeTreatmentMethodId) REFERENCES wasteTypesXtreatmentMethods(wasteTypeTreatmentMethodId)
);

CREATE TABLE recyclableWaste (
    recyclableWasteId INT NOT NULL PRIMARY KEY IDENTITY,
    wasteTypeTreatmentMethodId INT NOT NULL,
    price DECIMAL(10, 2), 
    FOREIGN KEY (wasteTypeTreatmentMethodId) REFERENCES wasteTypesXtreatmentMethods(wasteTypeTreatmentMethodId)
);

CREATE TABLE recyclableWasteSale (
    recyclableWasteSaleId INT NOT NULL PRIMARY KEY IDENTITY,
    recyclableWasteId INT NOT NULL,
    wasteCollectorId INT NOT NULL,
    saleDate DATE NOT NULL,
    sellerContact INT NOT NULL,
    buyerContact INT NOT NULL,
    FOREIGN KEY (sellerContact) REFERENCES contacts(contactId),
    FOREIGN KEY (buyerContact) REFERENCES contacts(contactId),
    FOREIGN KEY (recyclableWasteId) REFERENCES recyclableWaste(recyclableWasteId),
    FOREIGN KEY (wasteCollectorId) REFERENCES wasteCollectors(wasteCollectorId)
);

CREATE TABLE trainings (
    trainingId INT NOT NULL PRIMARY KEY IDENTITY,
    date DATE NOT NULL,
    startTime TIME NOT NULL,
    endTime TIME NOT NULL,
    description VARCHAR(255) NOT NULL,
    trainingTypeId INT NOT NULL, 
    FOREIGN KEY (trainingTypeId) REFERENCES wasteTypesXtreatmentMethods(wasteTypeTreatmentMethodId)
);

CREATE TABLE trainingAttendances (
    attendanceId INT NOT NULL PRIMARY KEY IDENTITY,
    trainingId INT NOT NULL,
    wasteCollectorId INT, 
    FOREIGN KEY (trainingId) REFERENCES trainings(trainingId),
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
    FOREIGN KEY (attendanceId) REFERENCES trainings(trainingId)
);

CREATE TABLE containers (
    containerId INT NOT NULL PRIMARY KEY IDENTITY,
    manufacturerInfo VARCHAR(255) NOT NULL,
    isInUse BIT NOT NULL DEFAULT 0,
    maxWeight DECIMAL(10, 2),
    weight DECIMAL(10, 2),
    size INT NOT NULL, -- small 1, medium 2, large 3
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

CREATE TABLE containerLogs ( -- Trasabilidad de los contenedores
    logId INT PRIMARY KEY IDENTITY,
    logDate DATE NOT NULL,
    pickupScheduleId INT NOT NULL,
    containerId INT NOT NULL,
    carrierId INT NOT NULL,
    fleetId INT, -- Puede ser null al pertenecer a otra empresa
    FOREIGN KEY (fleetId) REFERENCES fleet(fleetId),
    FOREIGN KEY (carrierId) REFERENCES carriers(carrierId),
    FOREIGN KEY (pickupScheduleId) REFERENCES pickupSchedules(pickupScheduleId),
    FOREIGN KEY (containerId) REFERENCES containers(containerId) 
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
    smallContainers INT,
    mediumContainers INT,
    largeContainers INT
);

CREATE TABLE wasteTreatmentLogs (
    logId INT PRIMARY KEY IDENTITY,
    costId INT NOT NULL,
    containerLogId INT NOT NULL, -- Includes dates, wasteType and the producer.
    FOREIGN KEY (costId) REFERENCES wasteTreatmentCosts(wasteTreatmentCostId),
    FOREIGN KEY (containerLogId) REFERENCES containerLogs(logId)
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
    startDate date NOT NULL,
    endDate date,
    FOREIGN KEY (currencyTo) REFERENCES currencies(currencyId)
);

CREATE TABLE languages (                   
    languageId INT NOT NULL PRIMARY KEY IDENTITY,
    code VARCHAR(2) NOT NULL,
    name VARCHAR(50) NOT NULL
);

CREATE TABLE treatmentMethodsXcountries (
    countryId INT NOT NULL,
    treatmentMethodId INT NOT NULL,
    FOREIGN KEY (countryId) REFERENCES countries(countryId),
    FOREIGN KEY (treatmentMethodId) REFERENCES wasteTypesXtreatmentMethods(wasteTypeTreatmentMethodId)    
);

CREATE TABLE containersStockLogs (
    logId INT NOT NULL PRIMARY KEY IDENTITY,
    wasteCollectorId INT NOT NULL,
    wasteTypeId INT NOT NULL,
conteinerSize INT NOT NULL, -- small 1, medium 2, large 3
    action INT NOT NULL, -- request 1, return 2
    amount INT NOT NULL,
    pastAmount INT NOT NULL,
    lastUpdate DATE NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (wasteCollectorId) REFERENCES wasteCollectors(wasteCollectorId),
    FOREIGN KEY (wasteTypeId) REFERENCES wasteTypes(wasteTypeId)
);

CREATE TABLE contractTypes (
    contractTypeId INT NOT NULL PRIMARY KEY IDENTITY,
    contractTypeName VARCHAR(255) NOT NULL
);

CREATE TABLE contracts (
    contractId INT NOT NULL PRIMARY KEY IDENTITY,
    contractTypeId INT NOT NULL,
    wasteCollectorId INT NOT NULL,
    producerId INT NOT NULL,
    wasteTypeId INT NOT NULL,
    startDate DATE NOT NULL,
    endDate DATE NOT NULL,
    deliveryContact INT NOT NULL,
    receiverContact INT NOT NULL,
    isSigned BIT NOT NULL DEFAULT 0,
    FOREIGN KEY (contractTypeId) REFERENCES contractTypes(contractTypeId),
    FOREIGN KEY (wasteCollectorId) REFERENCES wasteCollectors(wasteCollectorId),
    FOREIGN KEY (producerId) REFERENCES producers(producerId),
    FOREIGN KEY (wasteTypeId) REFERENCES wasteTypes(wasteTypeId),
    FOREIGN KEY (deliveryContact) REFERENCES contacts(contactId),
    FOREIGN KEY (receiverContact) REFERENCES contacts(contactId)
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

CREATE TABLE serviceInvoices (
    invoiceId INT NOT NULL PRIMARY KEY IDENTITY,
    number VARCHAR(50) NOT NULL,
    date DATE NOT NULL,
    time TIME NOT NULL,
    dueDate DATE NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    invoiceCurrency INT NOT NULL,
    amountChange DECIMAL(10, 2) NOT NULL,
    buyerCurrency INT NOT NULL,
    status VARCHAR(50) NOT NULL,
    sellerContact INT NOT NULL,
    buyerContact INT NOT NULL,
    details VARCHAR(255) NOT NULL,
    FOREIGN KEY (invoiceCurrency) REFERENCES currencies(currencyId),
    FOREIGN KEY (buyerCurrency) REFERENCES currencies(currencyId),
    FOREIGN KEY (sellerContact) REFERENCES contacts(contactId),
    FOREIGN KEY (buyerContact) REFERENCES contacts(contactId)
);