import pyodbc

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

db = Database()
