import pyodbc

class Database:
    def __init__(self):
        self.server = 'JPABLIX'
        self.database = 'caso3'
        self.username = 'sa'
        self.password = 'Pablito09'
        self.cnxn = pyodbc.connect('DRIVER={SQL Server};SERVER='+self.server+';DATABASE='+self.database+';UID='+self.username+';PWD='+ self.password)

    def get_top_100_data(self):
        cursor = self.cnxn.cursor()
        cursor.execute("SELECT TOP 10 * FROM countries")
        data = cursor.fetchall()
        cursor.close()
        return data
    
    def get_random_logIn(self):
        cursor = self.cnxn.cursor()
        cursor.execute("SELECT TOP 1 p.*, l.cityId, c.name FROM dbo.producers p INNER JOIN dbo.locations l ON p.locationId = l.locationId INNER JOIN dbo.cities c ON l.cityId = c.cityId ORDER BY NEWID()")
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
        cursor.execute("SELECT * FROM dbo.companies")
        data = cursor.fetchall()
        cursor.close()
        return data 
    
    def get_producers(self):
        cursor = self.cnxn.cursor()
        cursor.execute("SELECT * FROM dbo.producers")
        data = cursor.fetchall()
        cursor.close()
        return data
    
    def get_producersBasedOnCompany(self, companyId, producers):
        data = []
        for producer in producers:
            if producer[3] == companyId:
                data.append(producer)
        return data

db = Database()
