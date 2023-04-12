CREATE TABLE states (
    stateId INT PRIMARY KEY IDENTITY,
    name VARCHAR(50) NOT NULL
);

CREATE TABLE cities (
    cityId INT NOT NULL PRIMARY KEY IDENTITY,
    name VARCHAR(50) NOT NULL,
    stateId INT FOREIGN KEY REFERENCES states(stateId)
);

CREATE TABLE zipcodes (
    zipcodeId INT PRIMARY KEY IDENTITY,
    zipode VARCHAR(10) NOT NULL,
    cityId INT FOREIGN KEY REFERENCES cities(cityId)
);

CREATE TABLE locations (
    locationId INT NOT NULL PRIMARY KEY IDENTITY,
    latitude DECIMAL(9, 6) NOT NULL,
    longitude DECIMAL(9, 6) NOT NULL,
    zipcodeId INT FOREIGN KEY REFERENCES zipcodes(zipcodeId)
);

CREATE TABLE contactTypes (
    contactTypeId INT NOT NULL PRIMARY KEY IDENTITY,
    typeName VARCHAR(255) NOT NULL
);

CREATE TABLE contactsInfo (
    contactId INT NOT NULL PRIMARY KEY IDENTITY,
    name VARCHAR(255) NOT NULL,
    position VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    address VARCHAR(255) NOT NULL,
    notes VARCHAR(255),
    contactTypeId INT,
    FOREIGN KEY (contactTypeId) REFERENCES contactTypes(contactTypeId)
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
    isLocal BIT NOT NULL DEFAULT 1
);

CREATE TABLE producers (
    producerId INT NOT NULL PRIMARY KEY IDENTITY,
    name VARCHAR(255) NOT NULL,
    locationId INT NOT NULL,
    companyId INT,
    FOREIGN KEY (locationId) REFERENCES locations(locationId),
    FOREIGN KEY (companyId) REFERENCES companies(companyId)
);

CREATE TABLE producerXcontacts (
    producerId INT NOT NULL,
    contactId INT NOT NULL,
    FOREIGN KEY (producerId) REFERENCES producers(producerId),
    FOREIGN KEY (contactId) REFERENCES contactsInfo(contactId)
);

CREATE TABLE wasteCollectors (
    wasteCollectorId INT NOT NULL PRIMARY KEY IDENTITY,
    name VARCHAR(255) NOT NULL,
    locationId INT NOT NULL,
    companyId INT,
    FOREIGN KEY (locationId) REFERENCES locations(locationId),
    FOREIGN KEY (companyId) REFERENCES companies(companyId)
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
    FOREIGN KEY (wasteTypeId) REFERENCES wasteType(wasteTypeId),
    FOREIGN KEY (methodId) REFERENCES treatmentMethod(methodId)
);

CREATE TABLE wasteTreatmentCosts (
    costId INT NOT NULL PRIMARY KEY IDENTITY,
    wasteTypeTreatmentMethodId INT NOT NULL,
    cost DECIMAL(10, 2),
    FOREIGN KEY (wasteTypeTreatmentMethodId) REFERENCES wasteTypesXtreatmentMethods(wasteTypeTreatmentMethodId)
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
    active BIT NOT NULL DEFAULT 1,
    maxWeight DECIMAL(10, 2),
    weight DECIMAL(10, 2),
    currentWeight DECIMAL(10, 2)
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
    producerId INT NOT NULL,
    frequency VARCHAR(15)
	CHECK (frequency IN('daily', 'weekly', 'monthly')) NOT NULL,
    pickupDay VARCHAR(15)
	CHECK (pickupDay IN('Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday')) NOT NULL,
    wasteTypeId INT NOT NULL,
    FOREIGN KEY (producerId) REFERENCES producers(producerId),
    FOREIGN KEY (wasteTypeId) REFERENCES wasteTypes(wasteTypeId),
);

CREATE TABLE containerLogs (
    logId INT PRIMARY KEY IDENTITY,
    logDate DATE NOT NULL,
    pickupScheduleId INT NOT NULL,
    containerId INT NOT NULL,
    FOREIGN KEY (pickupScheduleId) REFERENCES pickupSchedules(pickupScheduleId),
    FOREIGN KEY (containerId) REFERENCES containers(containerId) 
);

CREATE TABLE wasteTreatmentSites (
    siteId INT PRIMARY KEY IDENTITY,
    name VARCHAR(255) NOT NULL,
    locationId INT NOT NULL,
    FOREIGN KEY (locationId) REFERENCES locations(locationId),
);

CREATE TABLE treatmentSitesXcontacts (
    siteId INT NOT NULL,
    contactId INT NOT NULL,
    FOREIGN KEY (siteId) REFERENCES wasteTreatmentSites(siteId),
    FOREIGN KEY (contactId) REFERENCES contactsInfo(contactId)
);

CREATE TABLE wasteTreatmentLogs (
    logId INT PRIMARY KEY IDENTITY,
    costId INT NOT NULL,
    containerLogId INT NOT NULL, -- Includes dates, wasteType and the producer.
    siteId INT NOT NULL,
    carrierType VARCHAR(15)
	CHECK (carrier IN('treatment site', 'producer', 'waste collector')) NOT NULL,
    wasteCollectorId INT, 
    fleetId INT,
    -- If the carrierType is:
    -- treatment site = siteId
    -- producer = producerId
    -- waste collector = wasteCollectorId and have a fleetId
    FOREIGN KEY (fleetId) REFERENCES fleet(fleetId),
    FOREIGN KEY (wasteCollectorId) REFERENCES wasteCollectors(wasteCollectorId),
    FOREIGN KEY (siteId) REFERENCES wasteTreatmentSites(siteId),
    FOREIGN KEY (costId) REFERENCES wasteTreatmentCosts(costId),
    FOREIGN KEY (containerLogId) REFERENCES containerLogs(logId)
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
    capacity INT NOT NULL,
    color VARCHAR(7) NOT NULL
);

CREATE TABLE fleetXwasteTreatmentSites (
    fleetId INT NOT NULL,
    siteId INT NOT NULL,
    isAvailable BIT NOT NULL DEFAULT 1,
    FOREIGN KEY (fleetId) REFERENCES fleet(fleetId),
    FOREIGN KEY (siteId) REFERENCES wasteTreatmentSites(siteId)
);

CREATE TABLE currencies (                  
    currencyId INT NOT NULL PRIMARY KEY IDENTITY,
    code varchar(3) NOT NULL,
    name varchar(50) NOT NULL,
    symbol varchar(5) NOT NULL
);

CREATE TABLE systemCurrency (              
    currencyId INT NOT NULL PRIMARY KEY,
    FOREIGN KEY (currencyId) REFERENCES currencies(currencyId)
);

CREATE TABLE currencyRates (              
    currencyRateId INT NOT NULL PRIMARY KEY IDENTITY,
    currencyFrom INT NOT NULL,
    currencyTo INT NOT NULL,
    rate decimal(10, 4) NOT NULL,
    date date NOT NULL,
    FOREIGN KEY (currencyFrom) REFERENCES systemCurrency(currencyId),
    FOREIGN KEY (currencyTo) REFERENCES currencies(currencyId)
);

CREATE TABLE languages (                   
    languageId INT NOT NULL PRIMARY KEY IDENTITY,
    code VARCHAR(2) NOT NULL,
    name VARCHAR(50) NOT NULL
);

CREATE TABLE countries (                     
    code VARCHAR(2) NOT NULL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    currency VARCHAR(3) NOT NULL,
    language VARCHAR(2) NOT NULL,
    FOREIGN KEY (currency) REFERENCES currencies(code)
    FOREIGN KEY (language) REFERENCES languages(code)
);

