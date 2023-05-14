import pyodbc
import json
class Database:
    def __init__(self):
        self.server = 'localhost'
        self.database = 'caso3'
        self.username = 'sa'
        self.password = 'Sven1234'
        self.cnxn = pyodbc.connect('DRIVER={SQL Server};SERVER='+self.server+';DATABASE='+self.database+';UID='+self.username+';PWD='+ self.password)

    def get_top_100_data(self):
        cursor = self.cnxn.cursor()
        cursor.execute("SELECT TOP 10 * FROM countries")
        data = cursor.fetchall()
        cursor.close()
        return data
    
    def get_random_logIn(self):
        cursor = self.cnxn.cursor()
        cursor.execute('''SELECT TOP 1
                                r.name AS region_name,
                                ra.name AS region_area_name,
                                c.name AS city_name,
                                s.name AS state_name,
                                co.name AS country_name
                            FROM
                                regions r
                                INNER JOIN regionAreas ra ON r.regionAreaId = ra.regionAreasId
                                LEFT JOIN cities c ON ra.cityId = c.cityId
                                LEFT JOIN states s ON ra.stateId = s.stateId
                                LEFT JOIN countries co ON ra.countryId = co.countryId
                            ORDER BY NEWID();''')
        data = cursor.fetchall()
        cursor.close()
        return data  
    
    def get_random_carrier(self):
        cursor = self.cnxn.cursor()
        cursor.execute("SELECT TOP 1 name, surname1, surname2 FROM contacts WHERE contactType = 'Carrier' ORDER BY NEWID()")
        data = cursor.fetchall()
        cursor.close()
        return data  

    def get_random_fleet(self):
        cursor = self.cnxn.cursor()
        cursor.execute("SELECT TOP 1 fleetId, color FROM fleet WHERE active = 1 ORDER BY NEWID()")
        data = cursor.fetchall()
        cursor.close()
        return data 
    
    def get_wasteTypes(self):
        cursor = self.cnxn.cursor()
        cursor.execute("SELECT * FROM dbo.wasteTypes")
        data = cursor.fetchall()
        cursor.close()
        return data 
    
    def get_companies(self):
        cursor = self.cnxn.cursor()
        cursor.execute("SELECT TOP 10 * FROM companies")
        data = cursor.fetchall()
        cursor.close()
        return data 
    
    def get_producers(self):
        cursor = self.cnxn.cursor()
        cursor.execute("SELECT producerId, name, companyId FROM dbo.producers")
        data = cursor.fetchall()
        cursor.close()
        return data
    def get_companies_producers(self, companies, producers):
        companies_producers = []
        for company in companies:
            for producer in producers:
                if company[0] == producer[2]:
                    companies_producers.append([company, producer])
        return companies_producers
    
    import json

    def validate_jsons(self, data):
        '''
        with open("error.json", "w") as f:
                f.write(data + "\n")
        data = json.loads(data)
        data = [(d['carrier'], d['plate'], d['location'], d['company'], d['producer'], d['wasteType'], d['operationType'], d['quantity']) for d in data]
        '''
        data = ('Carrier C', 'Plate C', 'Location C', 'Company C', 'Producer C', 'Waste Type C', 'Operation Type C', '30')
        cursor = self.cnxn.cursor()
        cursor.execute(
            """
            IF OBJECT_ID('tempdb..#tempContainersData') IS NOT NULL
                DROP TABLE #tempContainersData;
            """
        )
        cursor.execute(
            """
            CREATE TABLE #tempContainersData (
                carrier VARCHAR(500),
                plate VARCHAR(500),
                location VARCHAR(500),
                company VARCHAR(500),
                producer VARCHAR(500),
                wasteType VARCHAR(500),
                operationType VARCHAR(500),
                quantity VARCHAR(500)
            )
            """
        )
        cursor.execute("INSERT INTO #tempContainersData VALUES (?, ?, ?, ?, ?, ?, ?, ?)", data)

        

        
        self.cnxn.commit()
        cursor.execute("SELECT * FROM #tempContainersData")
        test = cursor.fetchall()
        with open("xd.txt", "w") as f:
                f.write(str(test) + "\n")


db = Database()
