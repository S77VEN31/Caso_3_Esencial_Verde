CREATE TABLE producers (
    producerId INT NOT NULL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    email VARCHAR(255) NOT NULL,
    locationId INT NOT NULL,
    FOREIGN KEY (locationId) REFERENCES locations(locationId)
);

CREATE TABLE states (
    stateId INT PRIMARY KEY,
    name VARCHAR(50)
);

CREATE TABLE cities (
    cityId INT PRIMARY KEY,
    name VARCHAR(50),
    stateId INT FOREIGN KEY REFERENCES states(stateId)
);

CREATE TABLE zipcodes (
    zipcodeId INT PRIMARY KEY,
    zipode VARCHAR(10),
    cityId INT FOREIGN KEY REFERENCES cities(cityId)
);

CREATE TABLE locations (
    locationId INT PRIMARY KEY,
    Latitude DECIMAL(9, 6),
    Longitude DECIMAL(9, 6),
    zipcodeId INT FOREIGN KEY REFERENCES zipcodes(zipcodeId)
);

CREATE TABLE producerCategories (
    producerCategoriesId INT NOT NULL PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

CREATE TABLE producersXproducerCategories (
    producerId INT NOT NULL,
    CategoriaId INT NOT NULL,
    PRIMARY KEY (producerId, CategoriaId),
    FOREIGN KEY (producerId) REFERENCES Productores (Id),
    FOREIGN KEY (CategoriaId) REFERENCES CategoriasDeProductores (Id)
);

CREATE TABLE WastesTypes (
    Id INT NOT NULL PRIMARY KEY,
    Nombre VARCHAR(255) NOT NULL
);

CREATE TABLE GeneracionDeResiduos (
    producerId INT NOT NULL,
    TipoDeResiduoId INT NOT NULL,
    Periodo DATE NOT NULL,
    Cantidad FLOAT NOT NULL,
    PRIMARY KEY (producerId, TipoDeResiduoId, Periodo),
    FOREIGN KEY (producerId) REFERENCES Productores (Id),
    FOREIGN KEY (TipoDeResiduoId) REFERENCES TiposDeResiduos (Id)
);

CREATE TABLE Miembros (
    Id INT NOT NULL PRIMARY KEY,
    Nombre VARCHAR(255) NOT NULL,
    Direccion VARCHAR(255) NOT NULL,
    Telefono VARCHAR(20) NOT NULL,
    CorreoElectronico VARCHAR(255) NOT NULL,
    FechaAfiliacion DATE NOT NULL
);

CREATE TABLE EmpresasAfiliadas (
    Id INT NOT NULL PRIMARY KEY,
    Nombre VARCHAR(255) NOT NULL,
    Direccion VARCHAR(255) NOT NULL,
    Telefono VARCHAR(20) NOT NULL,
    CorreoElectronico VARCHAR(255) NOT NULL,
    FechaAfiliacion DATE NOT NULL
);

CREATE TABLE Proyectos (
    Id INT NOT NULL PRIMARY KEY,
    Nombre VARCHAR(255) NOT NULL,
    FechaInicio DATE NOT NULL,
    FechaFinalizacion DATE NOT NULL,
    Descripcion VARCHAR(1000) NOT NULL,
    Presupuesto FLOAT NOT NULL,
    Estado VARCHAR(255) NOT NULL
);

CREATE TABLE Wastes (
    wasteId INT NOT NULL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    class VARCHAR(255) NOT NULL,
    amount FLOAT NOT NULL,
    preventiveMeasures VARCHAR(1000) NOT NULL
);

CREATE TABLE regultaionsLaws (
    Id INT NOT NULL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description VARCHAR(1000) NOT NULL,
    entryDate DATE NOT NULL,
    sanctions VARCHAR(1000) NOT NULL
);

CREATE TABLE services (
    serviceId INT NOT NULL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description VARCHAR(1000) NOT NULL
);



