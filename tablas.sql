-- Tablas Base del proyecto --

--TO DO:
    -- Posibles Tablas por Agregar: colletionPoints
    -- Arreglar las columnas de wasteTraceability
    -- Columna tipo BIT para saber si una empresa es nacional o externa

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
    latitude DECIMAL(9,6) NOT NULL,
    longitude DECIMAL(9,6) NOT NULL,
    zipcodeId INT FOREIGN KEY REFERENCES zipcodes(zipcodeId)
);

CREATE TABLE producers (
    producerId INT NOT NULL PRIMARY KEY IDENTITY,
    name VARCHAR(255) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    email VARCHAR(255) NOT NULL,
    locationId INT NOT NULL,
    FOREIGN KEY (locationId) REFERENCES locations(locationId)
);

CREATE TABLE producerCategories (
    producerCategoryId INT NOT NULL PRIMARY KEY IDENTITY,
    name VARCHAR(255) NOT NULL
);

CREATE TABLE producersXproducerCategories (
    producerId INT NOT NULL,
    producerCategoryId INT NOT NULL,
    PRIMARY KEY (producerId, producerCategoryId),
    FOREIGN KEY (producerId) REFERENCES producers (producerId),
    FOREIGN KEY (producerCategoryId) REFERENCES producerCategories (producerCategoryId)
);
CREATE TABLE wasteTypes (
    wasteTypeId INT NOT NULL PRIMARY KEY IDENTITY,
    name VARCHAR(255) NOT NULL
);

CREATE TABLE wastesXwasteTypes (
    producerId INT NOT NULL,
    wasteTypeId INT NOT NULL,
    date DATE NOT NULL,
    amount FLOAT NOT NULL,
    PRIMARY KEY (producerId, wasteTypeId),
    FOREIGN KEY (producerId) REFERENCES producers (producerId),
    FOREIGN KEY (wasteTypeId) REFERENCES wasteTypes (wasteTypeId)
);

CREATE TABLE members (
    memberId INT NOT NULL PRIMARY KEY IDENTITY,
    name VARCHAR(255) NOT NULL,
    locationId INT NOT NULL,
    phone VARCHAR(20) NOT NULL,
    mail VARCHAR(255) NOT NULL,
    entryDate DATE NOT NULL,
    FOREIGN KEY (locationId) REFERENCES locations(locationId)
);

CREATE TABLE companies (
    companyId INT NOT NULL PRIMARY KEY IDENTITY,
    name VARCHAR(255) NOT NULL,
    locationId INT NOT NULL,
    phone VARCHAR(20) NOT NULL,
    mail VARCHAR(255) NOT NULL,
    entryDate DATE NOT NULL,
    FOREIGN KEY (locationId) REFERENCES locations(locationId)
);

CREATE TABLE projects (
    projectId INT NOT NULL PRIMARY KEY IDENTITY,
    name VARCHAR(255) NOT NULL,
    startDate DATE NOT NULL,
    finishDate DATE NOT NULL,
    description VARCHAR(1000) NOT NULL,
    budget FLOAT NOT NULL,
    state VARCHAR(255) NOT NULL
);

CREATE TABLE wastes (
    wasteId INT NOT NULL PRIMARY KEY IDENTITY,
    name VARCHAR(255) NOT NULL,
    class VARCHAR(255) NOT NULL,
    amount FLOAT NOT NULL,
    preventiveMeasures VARCHAR(1000) NOT NULL
);

CREATE TABLE relationships (
    relationshipsId INT NOT NULL PRIMARY KEY IDENTITY,
    name VARCHAR(255) NOT NULL,
    description VARCHAR(1000) NOT NULL,
    entryDate DATE NOT NULL,
    bans VARCHAR(1000) NOT NULL
);

CREATE TABLE services (
    serviceId INT NOT NULL PRIMARY KEY IDENTITY,
    name VARCHAR(255) NOT NULL,
    description VARCHAR(1000) NOT NULL
);

-- Tablas según el primer enunciado --

CREATE TABLE collectionCycles (
  collectionCycleId INT PRIMARY KEY IDENTITY,
  producerId INT NOT NULL,
  frequency VARCHAR(50) NOT NULL,
  days VARCHAR(50) NOT NULL,
  time VARCHAR(50) NOT NULL,
  FOREIGN KEY (producerId) REFERENCES producers(producerId)
);

CREATE TABLE collectionRoutes (
  collectionRouteId INT NOT NULL PRIMARY KEY IDENTITY,
  producerId INT NOT NULL,
  wasteTypeId INT NOT NULL,
  distance DECIMAL(10,2) NOT NULL,
  collectionPoints VARCHAR(255) NOT NULL,
  estimatedTime VARCHAR(50) NOT NULL,
  FOREIGN KEY (producerId) REFERENCES producers(producerId),
  FOREIGN KEY (wasteTypeId) REFERENCES wasteTypes(wasteTypeId)
);

-- Tablas según el segundo enunciado --
CREATE TABLE trainings (
    trainingId INT NOT NULL PRIMARY KEY IDENTITY,
    name VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    duration VARCHAR(255) NOT NULL,
    materialsUsed TEXT NOT NULL
);
CREATE TABLE certifications (
    certificationId INT NOT NULL PRIMARY KEY IDENTITY,
    name VARCHAR(255) NOT NULL,
    requirements TEXT NOT NULL,
    duration VARCHAR(255) NOT NULL
);
CREATE TABLE producerAssignments (
    producerAssignmentId INT NOT NULL PRIMARY KEY IDENTITY,
    producerId INT NOT NULL,
    companyId INT NOT NULL,
    frequency VARCHAR(255) NOT NULL,
    FOREIGN KEY (producerId) REFERENCES producers(producerId),
    FOREIGN KEY (companyId) REFERENCES companies(companyId)
);
CREATE TABLE wasteCollectionCompanyEvaluations (
    evaluationId INT PRIMARY KEY IDENTITY,
    companyId INT NOT NULL,
    evaluationCriteria TEXT NOT NULL,
    evaluationFrequency VARCHAR(255) NOT NULL,
    evaluationResults TEXT NOT NULL,
    FOREIGN KEY (companyId) REFERENCES companies(companyId)
);

-- Tablas según el tercer enunciado --

CREATE TABLE fleet (
    fleetId INT NOT NULL PRIMARY KEY IDENTITY,
    vehicleType VARCHAR(255) NOT NULL,
    brand VARCHAR(255) NOT NULL,
    model VARCHAR(255) NOT NULL,
    plateNumber VARCHAR(20) NOT NULL,
    capacity INT NOT NULL
);

CREATE TABLE collectionContracts (
    collectionContractId INT PRIMARY KEY IDENTITY,
    collectionCompany VARCHAR(255) NOT NULL,
    contractStartDate DATE NOT NULL,
    contractDuration VARCHAR(255) NOT NULL
);

CREATE TABLE producerRecords (
    producerRecordId INT NOT NULL PRIMARY KEY IDENTITY,
    producerName VARCHAR(255) NOT NULL,
    producerLocation VARCHAR(255) NOT NULL,
    wasteType VARCHAR(255) NOT NULL,
    deliveryFrequency VARCHAR(255) NOT NULL
);

-- Tablas según el cuarto enunciado --

CREATE TABLE containers (
    containerId INT NOT NULL PRIMARY KEY IDENTITY,
    sizeCapacity DECIMAL(10,2) NOT NULL,
    emptyWeight DECIMAL(10,2) NOT NULL,
    manufacturerInfo VARCHAR(255) NOT NULL
);

CREATE TABLE containersXwasteTypes (
    containerId INT NOT NULL,
    wasteTypeId INT NOT NULL,
    FOREIGN KEY (containerId) REFERENCES containers(containerId),
    FOREIGN KEY (wasteTypeId) REFERENCES wasteTypes(wasteTypeId)
);





-- Tablas según el quinto enunciado --

CREATE TABLE wasteTraceability (
    containerId INT NOT NULL PRIMARY KEY IDENTITY,
    wasteProducerName VARCHAR(255) NOT NULL,
    collectionDateTime DATETIME NOT NULL,
    disposalLocation VARCHAR(255) NOT NULL,
    wasteType VARCHAR(255) NOT NULL,
    emptyContainerWeight DECIMAL(10,2) NOT NULL,
    wasteWeight DECIMAL(10,2) NOT NULL,
    trackingNumber INT UNIQUE
);

-- Tablas según el sexto enunciado --

CREATE TABLE containerInventoryControl (
  containerInventoryControlId  INT NOT NULL PRIMARY KEY IDENTITY,
  containerId INT NOT NULL,
  capacity FLOAT NOT NULL,
  currentQuantity INT NOT NULL,
  entryDate DATE NOT NULL,
  exitDate DATE NOT NULL,
  exitReason VARCHAR(100) NOT NULL,
  containerStatus VARCHAR(50) NOT NULL,
  FOREIGN KEY (containerId) REFERENCES containers(containerId)
);

CREATE TABLE containerTracking (
  containerTrackingId INT NOT NULL PRIMARY KEY IDENTITY,
  containerId INT NOT NULL,
  location VARCHAR(100) NOT NULL,
  deliveryDateTime DATETIME NOT NULL,
  collectionDateTime DATETIME NOT NULL,
  cleaningStatus VARCHAR(50) NOT NULL,
  notes VARCHAR(200) NOT NULL,
  FOREIGN KEY (containerId) REFERENCES containers(containerId)
);

-- Tablas según el septimo enunciado --

CREATE TABLE tratableWaste (
  tratableWasteId INT NOT NULL PRIMARY KEY IDENTITY,
  wasteTypeId INT NOT NULL,
  wasteVolume FLOAT NOT NULL,
  synthesisProcess VARCHAR(255) NOT NULL,
  processCost FLOAT NOT NULL,
  FOREIGN KEY (wasteTypeId) REFERENCES wasteTypes(wasteTypeId)
);

CREATE TABLE recyclableWaste (
  recyclableWasteId INT NOT NULL PRIMARY KEY IDENTITY,
  wasteTypeId INT NOT NULL,
  wasteVolume FLOAT NOT NULL,
  conversionProcess VARCHAR(255) NOT NULL,
  conversionCost FLOAT NOT NULL,
  newProduct VARCHAR(255) NOT NULL,
  profit FLOAT NOT NULL,
  FOREIGN KEY (wasteTypeId) REFERENCES wasteTypes(wasteTypeId)
);

-- Tablas según el octavo enunciado --

CREATE TABLE signedContracts (
    signedContractId INT NOT NULL PRIMARY KEY IDENTITY,
    actorName VARCHAR(50) NOT NULL,
    actorType VARCHAR(50) NOT NULL,
    profitPercentage DECIMAL(5,2) NOT NULL,
    wasteTypeId INT NOT NULL,
    collectionQuantity VARCHAR(50) NOT NULL,
    collectionPeriodicity VARCHAR(50) NOT NULL,
    contractStartDate DATE NOT NULL,
    contractEndDate DATE NOT NULL,
    otherAgreedConditions VARCHAR(500) NOT NULL,
    FOREIGN KEY (wasteTypeId) REFERENCES wasteTypes(wasteTypeId)
);

-- Tablas según el noveno enunciado --

CREATE TABLE platformConfig (
  platformConfigId INT  NOT NULL PRIMARY KEY IDENTITY,
  language VARCHAR(50) NOT NULL,
  currency VARCHAR(50) NOT NULL,
  country VARCHAR(50) NOT NULL,
  settings VARCHAR(50) NOT NULL,
);

-- Tablas según el décimo enunciado --
CREATE TABLE sponsorCompanies (
    sponsorCompanyId INT NOT NULL PRIMARY KEY IDENTITY,
    companyId INT NOT NULL,
    country VARCHAR(255) NOT NULL,
    currency VARCHAR(10) NOT NULL,
    maxAmount DECIMAL(10,2) NOT NULL,
    startDate DATE NOT NULL,
    endDate DATE NOT NULL,
    FOREIGN KEY (companyId) REFERENCES companies(companyId)
);