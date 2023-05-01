INSERT INTO countries (name, nameCode, phoneCode)
VALUES
    ('Argentina', 'AR', 54),
    ('Australia', 'AU', 61),
    ('Brazil', 'BR', 55),
    ('Canada', 'CA', 1),
    ('China', 'CN', 86),
    ('France', 'FR', 33),
    ('Germany', 'DE', 49),
    ('India', 'IN', 91),
    ('Italy', 'IT', 39),
    ('Japan', 'JP', 81),
    ('Mexico', 'MX', 52),
    ('Netherlands', 'NL', 31),
    ('New Zealand', 'NZ', 64),
    ('Norway', 'NO', 47),
    ('Pakistan', 'PK', 92),
    ('Peru', 'PE', 51),
    ('Philippines', 'PH', 63),
    ('Russia', 'RU', 7),
    ('South Africa', 'ZA', 27),
    ('South Korea', 'KR', 82),
    ('Spain', 'ES', 34),
    ('Sweden', 'SE', 46),
    ('Switzerland', 'CH', 41),
    ('Thailand', 'TH', 66),
    ('Turkey', 'TR', 90),
    ('Ukraine', 'UA', 380),
    ('United Arab Emirates', 'AE', 971),
    ('United Kingdom', 'GB', 44),
    ('United States', 'US', 1),
    ('Venezuela', 'VE', 58),
    ('Vietnam', 'VN', 84),
    ('Algeria', 'DZ', 213),
    ('Egypt', 'EG', 20),
    ('Iran', 'IR', 98),
    ('Iraq', 'IQ', 964),
    ('Morocco', 'MA', 212),
    ('Saudi Arabia', 'SA', 966),
    ('Syria', 'SY', 963),
    ('Tunisia', 'TN', 216);
INSERT INTO states (name, countryId)
VALUES
    ('Buenos Aires', 1),
    ('Córdoba', 1),
    ('Santa Fe', 1),
    ('New South Wales', 2),
    ('Queensland', 2),
    ('Victoria', 2),
    ('São Paulo', 3),
    ('Rio de Janeiro', 3),
    ('Minas Gerais', 3),
    ('Alberta', 4),
    ('British Columbia', 4),
    ('Ontario', 4),
    ('Beijing', 5),
    ('Shanghai', 5),
    ('Guangdong', 5),
    ('Île-de-France', 6),
    ('Provence-Alpes-Côte d''Azur', 6),
    ('Hauts-de-France', 6),
    ('Bavaria', 7),
    ('North Rhine-Westphalia', 7),
    ('Baden-Württemberg', 7),
    ('Maharashtra', 8),
    ('Uttar Pradesh', 8),
    ('Bihar', 8),
    ('Lazio', 9),
    ('Lombardy', 9),
    ('Veneto', 9),
    ('Tokyo', 10),
    ('Osaka', 10),
    ('Kanagawa', 10),
    ('Jalisco', 11),
    ('Mexico City', 11),
    ('Nuevo León', 11),
    ('North Holland', 12),
    ('South Holland', 12),
    ('Utrecht', 12),
    ('Auckland', 13),
    ('Canterbury', 13),
    ('Wellington', 13);
INSERT INTO cities (name, stateId)
VALUES
    ('Buenos Aires', 1),
    ('La Plata', 1),
    ('Córdoba', 2),
    ('Rosario', 3),
    ('Santa Fe', 4),
    ('Sydney', 5),
    ('Newcastle', 5),
    ('Brisbane', 6),
    ('Gold Coast', 6),
    ('Melbourne', 7),
    ('Geelong', 7),
    ('São Paulo', 8),
    ('Campinas', 8),
    ('Rio de Janeiro', 9),
    ('Niterói', 9),
    ('Belo Horizonte', 10),
    ('Uberlândia', 10),
    ('Edmonton', 11),
    ('Calgary', 11),
    ('Vancouver', 12),
    ('Victoria', 12),
    ('Beijing', 13),
    ('Shanghai', 14),
    ('Guangzhou', 15),
    ('Paris', 16),
    ('Marseille', 16),
    ('Lille', 17),
    ('Munich', 18),
    ('Berlin', 18),
    ('Stuttgart', 19),
    ('Mumbai', 20),
    ('Pune', 20),
    ('Kanpur', 21),
    ('Patna', 22),
    ('Rome', 23),
    ('Milan', 24),
    ('Venice', 25),
    ('Tokyo', 26),
    ('Yokohama', 27),
    ('Osaka', 28),
    ('Kobe', 28),
    ('Guadalajara', 29),
    ('Mexico City', 30),
    ('Monterrey', 31),
    ('Amsterdam', 32),
    ('Rotterdam', 33),
    ('Utrecht', 34),
    ('Auckland', 35),
    ('Christchurch', 36),
    ('Wellington', 37);
INSERT INTO locations (latitude, longitude, zipcode, cityId)
VALUES
    (-34.603722, -58.381592, 1000, 1),
    (-34.931389, -57.948333, 1900, 2),
    (-31.420083, -64.188776, 5000, 3),
    (-32.951111, -60.666389, 2000, 4),
    (-31.618333, -60.690833, 3000, 5),
    (-33.868820, 151.209296, 2000, 6),
    (-32.916667, 151.750000, 2300, 7),
    (-27.468889, 153.023056, 4000, 8),
    (-28.016667, 153.400000, 4217, 9),
    (-37.813611, 144.963056, 3000, 10),
    (-38.150002, 144.350006, 3216, 11),
    (-23.550520, -46.633308, 0100000, 12),
    (-22.907104, -47.063240, 1308852, 13),
    (-22.911013, -43.209372, 2000000, 14),
    (-22.900211, -43.104998, 2400000, 15),
    (53.480759, -2.242631, 67, 16),
    (43.296482, 5.369780, 13001, 17),
    (48.135125, 11.581981, 80331, 18),
    (52.520008, 13.404954, 10115, 19),
    (48.776012, 9.173932, 70173, 20),
    (19.076090, 72.877426, 400001, 21),
    (18.520430, 73.856743, 411001, 22),
    (26.449923, 80.331871, 208001, 23),
    (45.464204, 9.189982, 20121, 24),
    (45.437190, 12.334590, 30100, 25),
    (35.680399, 139.769017, 16023, 26),
    (35.450192, 139.631838, 220012, 27),
    (34.693738, 135.502165, 53001, 28),
    (34.689506, 135.195738, 6510087, 29),
    (20.659698, -103.349609, 44100, 30),
    (19.427025, -99.127571, 06000, 31),
    (25.032969, 121.565418, 106, 32),
    (51.922692, 4.479179, 3011, 33),
    (52.090737, 5.121420, 1212, 34),
    (-36.848460, 174.763332, 1010, 35),
    (-43.531080, 170.132217, 7643, 36),
	(-36.853170, 174.763110, 1010, 37),
	(-41.292549, 174.773160, 6011, 38),
	(35.709026, 139.731992, 150-0011, 39),
	(35.710136, 139.810304, 183-0022, 40);

INSERT INTO regionAreas (name, cityId, stateId, countryId)
VALUES
  ('Region 1', 1, 1, 1),
  ('Region 2', 2, 2, 2),
  ('Region 3', NULL, 3, 3),
  ('Region 4', 4, NULL, 4),
  ('Region 5', 5, 5, NULL),
  ('Region 6', NULL, NULL, 6),
  ('Region 7', 7, NULL, NULL),
  ('Region 8', NULL, 8, NULL),
  ('Region 9', 9, NULL, NULL),
  ('Region 10', NULL, NULL, 10),
  ('Region 11', 11, 11, 11),
  ('Region 12', NULL, NULL, 12),
  ('Region 13', 13, 13, NULL),
  ('Region 14', NULL, 14, 14),
  ('Region 15', 15, NULL, 15),
  ('Region 16', NULL, 16, 16),
  ('Region 17', 17, 17, NULL),
  ('Region 18', NULL, 18, 18),
  ('Region 19', 19, NULL, 19),
  ('Region 20', NULL, NULL, 20),
  ('Region 21', 21, 21, 21),
  ('Region 22', NULL, NULL, 22),
  ('Region 23', 23, 23, NULL),
  ('Region 24', NULL, 24, 24),
  ('Region 25', 25, NULL, 25),
  ('Region 26', NULL, 26, NULL),
  ('Region 27', 27, NULL, NULL),
  ('Region 28', NULL, 28, NULL),
  ('Region 29', NULL, NULL, 29),
  ('Region 30', 30, 30, 30),
  ('Region 31', NULL, NULL, 31),
  ('Region 32', 32, NULL, 32),
  ('Region 33', NULL, 33, 33),
  ('Region 34', 34, NULL, NULL),
  ('Region 35', NULL, 35, NULL),
  ('Region 36', NULL, NULL, 36),
  ('Region 37', 37, 37, NULL),
  ('Region 38', NULL, 38, NULL),
  ('Region 39', NULL, NULL, 39),
  ('Region 40', 40, NULL, NULL);

INSERT INTO regions (name, regionAreaId)
VALUES ('Zona Este', 1),
    ('Zona Oeste', 2),
    ('Zona Norte', 3),
    ('Zona Sur', 4),
    ('Centro', 5),
    ('Zona Industrial', 6),
    ('Zona Comercial', 7),
    ('Zona Residencial', 8),
    ('Barrio Centro', 9),
    ('Barrio Norte', 10),
    ('Barrio Sur', 11),
    ('Barrio Oeste', 12),
    ('Colonia Centro', 13),
    ('Colonia Norte', 14),
    ('Colonia Sur', 15),
    ('Colonia Oeste', 16),
    ('Sector Este', 17),
    ('Sector Oeste', 18),
    ('Sector Norte', 19),
    ('Sector Sur', 20),
    ('Área Industrial', 21),
    ('Área Comercial', 22),
    ('Área Residencial', 23),
    ('Barrio Empresarial', 24),
    ('Barrio Universitario', 25),
    ('Barrio Artístico', 26),
    ('Colonia Empresarial', 27),
    ('Colonia Universitaria', 28),
    ('Colonia Artística', 29),
    ('Sector Empresarial', 30),
    ('Sector Universitario', 31),
    ('Sector Artístico', 32),
    ('Zona Histórica', 33),
    ('Zona Turística', 34),
    ('Zona Residencial Exclusiva', 35),
    ('Barrio Histórico', 36),
    ('Barrio Turístico', 37),
    ('Barrio Residencial Exclusivo', 38),
    ('Colonia Histórica', 39),
    ('Colonia Turística', 40);

INSERT INTO companyCategories (name, description)
VALUES 
    ('Automotive', 'Companies that produce waste during automotive manufacturing and servicing.'),
    ('Chemical', 'Companies that produce waste during chemical manufacturing and processing.'),
    ('Technology', 'Companies that produce waste during technology manufacturing and servicing.'),
    ('Agriculture', 'Companies that produce waste during agricultural processes.'),
    ('Retail', 'Companies that produce waste during retail operations.'),
    ('Transportation', 'Companies that produce waste during transportation operations.'),
    ('Healthcare', 'Companies that produce waste during healthcare operations.'),
    ('Education', 'Companies that produce waste during education operations.'),
    ('Energy', 'Companies that produce waste during energy production and distribution.'),
    ('Entertainment', 'Companies that produce waste during entertainment operations.'),
    ('Finance', 'Companies that produce waste during financial operations.'),
    ('Food and Beverage', 'Companies that produce waste during food and beverage manufacturing and processing.'),
    ('Hospitality', 'Companies that produce waste during hospitality operations.'),
    ('Mining', 'Companies that produce waste during mining operations.'),
    ('Textile', 'Companies that produce waste during textile manufacturing and processing.'),
    ('Telecommunications', 'Companies that produce waste during telecommunications operations.'),
    ('Utilities', 'Companies that produce waste during utility operations.'),
    ('Waste Management', 'Companies that specialize in the collection, transportation, and disposal of waste.'),
    ('Recycling', 'Companies that specialize in the processing and reuse of waste materials.'),
    ('Municipal', 'Municipal waste producers.');


INSERT INTO companies (companyName, companyCategoryId, isLocal, carbonFootprint, active, createAt, updateAt, checksum)
VALUES 
    ('Ford', 1, 0, 456.78, 1, '2022-03-01', '2022-03-01', 0x345678),
    ('Chevron', 10, 0, 123.45, 1, '2022-03-01', '2022-03-01', 0x456789),
    ('Apple', 3, 0, 234.56, 1, '2022-03-01', '2022-03-01', 0x567890),
    ('Monsanto', 4, 1, 567.89, 1, '2022-03-01', '2022-03-01', 0x678901),
    ('Walmart', 5, 0, 789.01, 1, '2022-03-01', '2022-03-01', 0x789012),
    ('FedEx', 6, 0, 901.23, 1, '2022-03-01', '2022-03-01', 0x890123),
    ('Kaiser Permanente', 7, 1, 345.67, 1, '2022-03-01', '2022-03-01', 0x901234),
    ('Harvard University', 8, 1, 1234.56, 1, '2022-03-01', '2022-03-01', 0x012345),
    ('Exelon', 9, 0, 2345.67, 1, '2022-03-01', '2022-03-01', 0x234567),
    ('JPMorgan Chase', 12, 0, 7890.12, 1, '2022-03-01', '2022-03-01', 0x345678),
    ('Nestle', 13, 0, 9012.34, 1, '2022-03-01', '2022-03-01', 0x456789),
    ('Rio Tinto', 14, 0, 123.45, 1, '2022-03-01', '2022-03-01', 0x567890),
    ('Levi Strauss', 15, 1, 234.56, 1, '2022-03-01', '2022-03-01', 0x678901),
    ('Verizon', 16, 0, 345.67, 1, '2022-03-01', '2022-03-01', 0x789012),
    ('Duke Energy', 17, 0, 456.78, 1, '2022-03-01', '2022-03-01', 0x890123),
    ('Waste Management Inc.', 18, 1, 567.89, 1, '2022-03-01', '2022-03-01', 0x901234),
    ('Recology', 19, 1, 789.01, 1, '2022-03-01', '2022-03-01', 0x012345),
    ('City of San Francisco', 20, 1, 1234.56, 1, '2022-03-01', '2022-03-01', 0x234567),
    ('Coca-Cola', 11, 0, 2345.67, 1, '2022-03-01', '2022-03-01', 0x345678),
    ('McDonalds', 4, 0, 1234.56, 1, '2022-03-01', '2022-03-01', 0x456789),
    ('Burger King', 4, 0, 2345.67, 1, '2022-03-01', '2022-03-01', 0x567890),
    ('KFC', 4, 0, 3456.78, 1, '2022-03-01', '2022-03-01', 0x678901),
    ('Subway', 4, 0, 4567.89, 1, '2022-03-01', '2022-03-01', 0x789012),
    ('Taco Bell', 4, 0, 5678.90, 1, '2022-03-01', '2022-03-01', 0x890123),
    ('Pizza Hut', 4, 0, 6789.01, 1, '2022-03-01', '2022-03-01', 0x901234),
    ('Dominos', 4, 0, 7890.12, 1, '2022-03-01', '2022-03-01', 0x012345),
    ('Starbucks', 6, 0, 9012.34, 1, '2022-03-01', '2022-03-01', 0x234567),
    ('Dunkin', 6, 0, 12345.67, 1, '2022-03-01', '2022-03-01', 0x345678),
    ('Chipotle', 7, 0, 23456.78, 1, '2022-03-01', '2022-03-01', 0x456789);


    INSERT INTO wasteTypes (name, description) VALUES 
    ('Organic Waste', 'Waste that comes from plants or animals'),
    ('Inorganic Waste', 'Waste that does not decompose'),
    ('Recyclable Waste', 'Waste that can be processed and reused'),
    ('Hazardous Waste', 'Waste that is dangerous to human health or the environment'),
    ('E-waste', 'Waste that comes from electronic devices'),
    ('Construction Waste', 'Waste that comes from construction sites'),
    ('Medical Waste', 'Waste that comes from hospitals or healthcare facilities'),
    ('Radioactive Waste', 'Waste that contains radioactive materials'),
    ('Biomedical Waste', 'Waste that comes from medical research or veterinary practices'),
    ('Food Waste', 'Waste that comes from food production or consumption'),
    ('Plastic Waste', 'Waste that comes from plastic products');

    INSERT INTO wasteCollectors (name, locationId, companyId) VALUES 
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

INSERT INTO containers (manufacturerInfo, isInUse, maxWeight, active) 
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