# TO DO:
## DEBATE
- [ ] El capacity de un fleet es algo más que un tamaño, si no también sobre que tipo de desechos es capaz de jalar

    * Aquí el problema es que el fleet no es que maneja el tipo de desechos que es capaz de transportar pues es un camión
 lo único que carga es uno o varios containers que son los capacitados para cargar distintos tipos de desechos y son
 los que tienen la información pertinente de su capacidad máxima, tipo de desechos etc.

    ```sql
    -- Tabla para la trasaabilidad de los contenedores
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

    -- Tabla para la fleet
    CREATE TABLE fleet (
        fleetId INT NOT NULL PRIMARY KEY IDENTITY,
        modelId INT NOT NULL FOREIGN KEY REFERENCES models(modelId),
        color VARCHAR(7) NOT NULL,
        smallContainers INT,
        mediumContainers INT,
        largeContainers INT
    );

    -- Tabla de contenedores, pueden manejar distintos tipos de desechos en la tabla containersXwasteTypes
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
    ```

- [ ] Mal diseñado el patron de contactinfo, incluso me genera dem desperdicio el modelo que usaron,[x] y separen el name
    * Aquí no entendimos cual es la correción el contacts se maneja de manera que hay varias tablas por ejemplo:
 producerXcontacts tal y como usted había indicado en clase y ya separamos el nombre como indicó.

        [Imagen con el modelo visto en clase](blob:https://estudianteccr-my.sharepoint.com/84ad2a44-1bb1-4f87-a224-05017294d7a4)

        ```sql
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

        CREATE TABLE  wasteCollectorsXcontacts (
            wasteCollectorId  INT NOT NULL,
            contactId INT NOT NULL,
            FOREIGN KEY (wasteCollectorId) REFERENCES wasteCollectors(wasteCollectorId),
            FOREIGN KEY (contactId) REFERENCES contacts(contactId)
        );

        CREATE TABLE carriersXcontacts (
            carrierId INT NOT NULL,
            contactId INT NOT NULL,
            FOREIGN KEY (carrierId) REFERENCES carriers(carrierId),
            FOREIGN KEY (contactId) REFERENCES contacts(contactId)
        );
        ```

- [ ] No se ven los precios de los métodos ni como estos se modelan para el contrato para los lugares
    * Si está.
        ```sql
        CREATE TABLE wasteTreatmentCostsXcountries (
            wasteTreatmentCostId INT NOT NULL PRIMARY KEY IDENTITY,
            wasteTypeTreatmentMethodId INT NOT NULL,
            countryId INT NOT NULL,
            cost DECIMAL(10, 2),
            FOREIGN KEY (countryId) REFERENCES countries(countryId)
            FOREIGN KEY (wasteTypeTreatmentMethodId) REFERENCES wasteTypesXtreatmentMethods(wasteTypeTreatmentMethodId)
        );
        ```

- [ ] Wastetreatmentlog no me muestra bien lo que está pasando con los involucrados 
    * Esta tabla cuenta con el container logs que tiene la fecha, el horario estipulado por contrato, 
de donde viene el desecho, hacia donde va, a que empresa pertenece quien lo lleva, que fleet lo lleva,
el costo que tiene manejar ese tipo de desecho con determinado método en determinada ubicación 
no sabemos que es lo que faltaría.
        ```sql
        CREATE TABLE wasteTreatmentLogs (
            logId INT PRIMARY KEY IDENTITY,
            costId INT NOT NULL,
            containerLogId INT NOT NULL, -- Includes dates, wasteType and the producer.
            FOREIGN KEY (costId) REFERENCES wasteTreatmentCosts(wasteTreatmentCostId),
            FOREIGN KEY (containerLogId) REFERENCES containerLogs(logId)
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
        ```
- [ ] No puedo ver que será frecuency pero si es texto estamos mal, veo poca info para poder modelar una recurrencia.
    * En esta parte modificamos el frequency la idea es que en el contrato se estipule una frecuencia y los dias
    en los que se va a recoger x tipo de desecho cambiamos los strings por un int que indique la info.
    ```sql
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
    ```
- [ ] Trainings no se si es el catalogo o el registro de cuando se hizo un training a alguien
    * Se tiene un registro de trainings con la fecha en la que se realizaron y cuanto duraron etc,
    la idea es controlar cuales wasteCollectors fueron a los training mediante training attendances
    y que los que van y pasan tienen certificados los cuales tienen expiración así nos quitamos de 
    encima tener que controlar cuales empleados están capacitados eso va a ser problema de la empresa
    como tal y simplemente ellos renuevan el certificado.
    ```sql
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
    ```
## DONE
- [x] Quitemos fleetxwastetreatmentsites, solo nos ata y no hay control previo de eso
- [x] Unificar zipcodes y locations, eso es lo mismo que la tabla addresses del patrón de addreses
- [x] Countries no está asociado a estates para el patrón y nos faltan las zonas
- [x] No amarren un country a una moneda ni a un idioma
- [x] Quitemos esa tabla de systemcurrency
- [x] Ocupamos un default y un enddate en currencyrates, 
## TO FIX
- [ ] Currencyrates debería ser el PK de varios FKS en pagos y transacciones e invoices
- [ ] En invoices no se involucren con el cambio, solo documéntenlo, es decir lo asocian y si quieren lo copian, pero no conviertan
- [ ] Contracts muy pobre, hay mezcla entre la definición de contrato, la planificación de los mismos y la ejecución, tiene muy poco de las cosas que tienen que quedar resueltas en el contrato, ver las preguntas en el documento , es imposible lograr todo lo que está ahí
- [ ] El sponsorship muy pobre, hacerlo segun el modelo
- [ ] No se puede mepear productos a lotes de productos y lotes de recursos usados para poder llegar a los contratos y repartir
- [ ] No tengo claro invoicing, pago y transacciones
- [ ] No es multiidioma 

