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
    

    def validate_jsons(self, data):
        currentIndex = 0
        
        cursor = self.cnxn.cursor()
        data = json.loads(data)
        
        if data == []:
                    return ('1', currentIndex)
        # Convert the list of dictionaries into a list of tuples
        data = [
            (d['carrier'], d['plate'], d['location'], d['company'], d['producer'].replace(" ", "", 1), d['wasteType'], d['operationType'], int(d['quantity']) if d['quantity'].isdigit() else 0)
            for d in data
        ]

        try:
            for row in data:
                currentIndex = currentIndex + 1
                cursor.execute('{CALL InsertContainersData(?,?,?,?,?,?,?,?)}', row)
                self.cnxn.commit()
            cursor.close()
            return ('-1', currentIndex)
        except pyodbc.Error as e:
            if len(e.args) > 1:
                message = e.args[1]
                # [Microsoft sql ] [ error code ... ] - message
                # Extract the error message
                start_index = message.rfind(']') + 1
                end_index = message.find('-', start_index)
                message = message[start_index:end_index].strip()
            else:
                message = str(e)
            errorStr = f"An error has occurred in the row { currentIndex } : {message}"
            with open("error.log", "a") as f:
                f.write(f"{errorStr}\n")
            cursor.close()
            return (errorStr, currentIndex)
        
   

db = Database()
