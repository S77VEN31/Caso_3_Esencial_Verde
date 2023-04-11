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
    PRIMARY KEY (producerId, contactId),
    FOREIGN KEY (producerId) REFERENCES producers(producerId),
    FOREIGN KEY (contactId) REFERENCES contactsInfo(contactId)
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

CREATE TABLE containers (
    containerId INT NOT NULL PRIMARY KEY IDENTITY,
    manufacturerInfo VARCHAR(255) NOT NULL,
    wasteTypeId INT,
    isInUse BIT NOT NULL DEFAULT 0, 
    maxCapacity DECIMAL(10, 2) 
    FOREIGN KEY (wasteTypeId) REFERENCES wasteTypes(wasteTypeId) -- Clave foránea al tipo de desecho
);

CREATE TABLE wasteTypesXtreatmentMethods (
    wasteTypeId INT NOT NULL,
    methodId INT NOT NULL,
    PRIMARY KEY (wasteTypeId, treatmentId),
    FOREIGN KEY (wasteTypeId) REFERENCES wasteType(wasteTypeId),
    FOREIGN KEY (methodId) REFERENCES treatmentMethod(methodId)
);

CREATE TABLE producersXwasteTypesXcontainers (
    producerId INT NOT NULL,
    wasteTypeId INT NOT NULL,
    containerId INT NOT NULL, 
    PRIMARY KEY (producerId, wasteTypeId),
    FOREIGN KEY (producerId) REFERENCES producers(producerId),
    FOREIGN KEY (wasteTypeId) REFERENCES wasteTypes(wasteTypeId),
    FOREIGN KEY (containerId) REFERENCES containers(containerId) 
);



















CREATE TABLE vehicle_type (
    typeId INT NOT NULL PRIMARY KEY,
    typeName VARCHAR(255) NOT NULL
);

CREATE TABLE brand (
    brandId INT NOT NULL PRIMARY KEY,
    brandName VARCHAR(255) NOT NULL
);

CREATE TABLE model (
    modelId INT NOT NULL PRIMARY KEY,
    modelName VARCHAR(255) NOT NULL,
    typeId INT NOT NULL REFERENCES vehicle_type(typeId),
    brandId INT NOT NULL REFERENCES brand(brandId)
);

CREATE TABLE fleet (
    fleetId INT NOT NULL PRIMARY KEY IDENTITY,
    modelId INT NOT NULL FOREIGN KEY REFERENCES model(modelId),
    plateNumber VARCHAR(20) NOT NULL,
    capacity INT NOT NULL,
    color VARCHAR(7) NOT NULL
);