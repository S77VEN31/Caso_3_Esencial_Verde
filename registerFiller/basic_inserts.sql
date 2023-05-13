INSERT INTO
  producers (name, locationId, companyId, balance)
VALUES
  ('Productor 1', 1, 2, 1000.50),
  ('Productor 2', 2, 3, 5000.00),
  ('Productor 3', 3, 1, 0),
  ('Productor 4', 4, 4, 250.75),
  ('Productor 5', 5, 5, 0),
  ('Productor 6', 6, 6, 10000.00),
  ('Productor 7', 7, 7, 0),
  ('Productor 8', 8, 8, 750.25),
  ('Productor 9', 9, 9, 0),
  ('Productor 10', 10, 10, 500.50),
  ('Productor 11', 1, 3, 0),
  ('Productor 12', 2, 1, 2000.00),
  ('Productor 13', 3, 4, 150.75),
  ('Productor 14', 4, 2, 0),
  ('Productor 15', 5, 5, 3000.00),
  ('Productor 16', 6, 6, 0),
  ('Productor 17', 7, 8, 800.25),
  ('Productor 18', 8, 10, 0),
  ('Productor 19', 9, 7, 1000.50),
  ('Productor 20', 10, 9, 5000.00);

INSERT INTO
  wasteTypes (name, description)
VALUES
  (
    'Organic Waste',
    'Waste that comes from plants or animals'
  ),
  (
    'Inorganic Waste',
    'Waste that does not decompose'
  ),
  (
    'Recyclable Waste',
    'Waste that can be processed and reused'
  ),
  (
    'Hazardous Waste',
    'Waste that is dangerous to human health or the environment'
  ),
  (
    'E-waste',
    'Waste that comes from electronic devices'
  ),
  (
    'Construction Waste',
    'Waste that comes from construction sites'
  ),
  (
    'Medical Waste',
    'Waste that comes from hospitals or healthcare facilities'
  ),
  (
    'Radioactive Waste',
    'Waste that contains radioactive materials'
  ),
  (
    'Biomedical Waste',
    'Waste that comes from medical research or veterinary practices'
  ),
  (
    'Food Waste',
    'Waste that comes from food production or consumption'
  ),
  (
    'Plastic Waste',
    'Waste that comes from plastic products'
  );

INSERT INTO
  wasteCollectors (name, locationId, companyId)
VALUES
  ('Waste Management', 1, 16),
  ('Republic Services', 2, 16),
  ('Waste Connections', 3, 16),
  ('Waste Industries', 4, 16),
  ('Advanced Disposal Services', 5, 16),
  ('Veolia Environmental Services', 6, 17),
  ('Clean Harbors', 7, 17),
  ('Stericycle', 8, 17),
  ('Waste Pro', 9, 17),
  ('Covanta Energy', 10, NULL),
  ('Rumpke Consolidated Companies', 11, NULL),
  ('Casella Waste Systems', 12, NULL),
  ('GFL Environmental', 13, NULL),
  ('New Jersey Resources', 14, NULL),
  ('Wheelabrator', 15, NULL),
  ('Waste Connections of Canada', 16, NULL),
  ('Waste Industries of Canada', 17, NULL),
  ('Green For Life Environmental', 18, NULL),
  ('Progressive Waste Solutions', 19, NULL),
  ('Waste Management of Canada', 20, NULL);

INSERT INTO
  containers (manufacturerInfo, isInUse, maxWeight, active)
VALUES
  ('Acme Inc.', 1, 500.00, 1),
  ('XYZ Corporation', 0, 750.50, 1),
  ('Global Containers Ltd.', 0, 1000.00, 1),
  ('Container Co.', 1, 250.00, 1),
  ('Green Shipping', 1, 1000.00, 1),
  ('Transportation Tech', 0, 500.75, 1),
  ('Secure Storage', 1, 800.00, 1),
  ('Box Builders', 0, 1000.00, 1),
  ('Cargo Containers Inc.', 1, 400.00, 1),
  ('Oceanic Logistics', 0, 900.50, 1),
  ('Allied Containers', 1, 600.00, 1),
  ('Express Shipping', 0, 1200.00, 1),
  ('Intermodal Solutions', 1, 350.25, 1),
  ('Swift Cargo', 1, 800.00, 1),
  ('New Horizons', 0, 650.00, 1),
  ('Transglobal Shipping', 1, 700.50, 1),
  ('Inland Containers', 0, 500.00, 1),
  ('Best Container Co.', 1, 900.00, 1),
  ('Pacific Transport', 1, 1000.00, 1),
  ('Worldwide Express', 0, 800.75, 1),
  ('Mega Freight', 1, 550.00, 1),
  ('Cargo Kings', 0, 1200.00, 1),
  ('Northern Shipping', 1, 450.25, 1),
  ('South Sea Containers', 1, 850.00, 1),
  ('Eagle Logistics', 0, 600.00, 1),
  ('Speedy Cargo', 1, 700.50, 1),
  ('United Transport', 0, 950.00, 1),
  ('Blue Ocean Shipping', 1, 1100.00, 1),
  ('Freightways Inc.', 1, 400.75, 1);

INSERT INTO
  vehicleTypes (typeId, typeName)
VALUES
  (1, 'Sedan'),
  (2, 'SUV'),
  (3, 'Truck'),
  (4, 'Van'),
  (5, 'Coupe'),
  (6, 'Convertible'),
  (7, 'Hatchback'),
  (8, 'Wagon'),
  (9, 'Sports Car'),
  (10, 'Crossover');