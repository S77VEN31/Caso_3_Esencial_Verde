INSERT INTO wasteTypes (name, description) VALUES 
    ('Biodegradable', 'Waste materials that can be broken down by natural processes.'),
    ('Non-biodegradable', 'Waste materials that cannot be broken down by natural processes.'),
    ('Oil', 'Waste materials that are produced from petroleum refining or oil spills.'),
    ('Chemicals', 'Waste materials that are hazardous due to their chemical composition.'),
    ('Electronic', 'Waste materials that are generated from electronic devices and appliances.'),
    ('Medical', 'Waste materials that are generated from medical facilities and procedures.'),
    ('Construction', 'Waste materials that are generated from construction and demolition projects.'),
    ('Food', 'Waste materials that are generated from food production and consumption.'),
    ('Plastic', 'Waste materials that are made of synthetic or semi-synthetic organic polymers.'),
    ('Metal', 'Waste materials that are composed of metallic elements or alloys.'),
    ('Glass', 'Waste materials that are made of silica-based materials and can be recycled into new glass products.');

INSERT INTO treatmentMethods (name, description) VALUES 
    ('Incineration', 'A method that involves the burning of waste materials to convert them into ash and gases, and reduce their volume.'),
    ('Landfill', 'A method that involves burying waste materials in the ground in designated areas called landfills, where they can decompose over time.'),
    ('Recycling', 'A method that involves converting waste materials into new products by processing and reusing them in the manufacturing of new goods.'),
    ('Composting', 'A method that involves the natural decomposition of organic waste materials, such as food and plant matter, into a nutrient-rich soil amendment.'),
    ('Chemical Treatment', 'A method that involves the use of chemical processes to treat hazardous waste materials and neutralize their harmful properties.'),
    ('Bioremediation', 'A method that involves the use of microorganisms to break down and remove contaminants from soil and water.'),
    ('Pyrolysis', 'A method that involves heating waste materials in the absence of oxygen to produce a fuel source and reduce the volume of the waste.'),
    ('Mechanical Biological Treatment', 'A method that involves a combination of mechanical and biological processes to treat mixed waste materials and recover recyclable materials.'),
    ('Inertization', 'A method that involves the treatment of hazardous waste materials to reduce their toxicity and render them chemically stable and safe for disposal.'),
    ('Land Application', 'A method that involves the application of treated waste materials to land for beneficial use, such as fertilizer or soil amendment.');

INSERT INTO containers (manufacturerInfo, maxWeight, currentWeight) VALUES 
    ('Acme Containers Inc., Model 123', 5000.00, 0),
    ('GreenBins Co., EcoBox 5000', 5000.00, 0),
    ('WasteMaster Inc., MaxiCan 5000', 5000.00, 0),
    ('DumpsterDepot, HeavyDuty 5000', 5000.00, 0);

INSERT INTO containersXwasteTypes (containerId, wasteTypeId) VALUES 
    (1, 2),
    (2, 1),
    (2, 9),
    (3, 2),
    (3, 10),
    (4, 1),
    (4, 3),
    (4, 5);

SELECT c.containerId, c.manufacturerInfo, wt.name, tm.name
FROM containers c
JOIN containersXwasteTypes cwt ON c.containerId = cwt.containerId
JOIN wasteTypes wt ON cwt.wasteTypeId = wt.wasteTypeId
JOIN treatmentMethods tm ON wt.wasteTypeId = tm.methodId
WHERE c.active = 1
