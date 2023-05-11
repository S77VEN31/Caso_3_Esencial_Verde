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
        cursor.execute("SELECT TOP 100 * FROM countries")
        data = cursor.fetchall()
        cursor.close()
        return data

db = Database()
