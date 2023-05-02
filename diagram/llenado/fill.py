import pyodbc
from faker import Faker
import random
server = 'localhost'
database = 'caso3'
username = 'sa'
password = 'Sven1234'
cnxn = pyodbc.connect('DRIVER={SQL Server};SERVER='+server+';DATABASE='+database+';UID='+username+';PWD='+ password)

#COUNTRIES
num_countries = 200

fake = Faker()
countries = [(fake.country(), fake.country_code(representation="alpha-2"), fake.random_int(min=1, max=999)) for _ in range(num_countries)]

cursor = cnxn.cursor()
for country in countries:
    cursor.execute("INSERT INTO countries (name, nameCode, phoneCode) VALUES (?, ?, ?)", country)
cnxn.commit()

#STATES
fake = Faker()
num_states = 5000

cursor.execute("SELECT countryId FROM countries")
country_ids = [row[0] for row in cursor.fetchall()]

states = [(fake.state(), random.choice(country_ids)) for _ in range(num_states)]

for state in states:
    cursor.execute("INSERT INTO states (name, countryId) VALUES (?, ?)", state)

#CITIES
fake = Faker()
num_cities = 20000

cursor.execute("SELECT stateId FROM states")
state_ids = [row[0] for row in cursor.fetchall()]

cities = [(fake.city(), random.choice(state_ids)) for _ in range(num_cities)]

for city in cities:
    cursor.execute("INSERT INTO cities (name, stateId) VALUES (?, ?)", city)

#LOCATIONS
fake = Faker()
num_locations = 100000

cursor.execute("SELECT cityId FROM cities")
city_ids = [row[0] for row in cursor.fetchall()]

locations = [(fake.latitude(), fake.longitude(), fake.random_int(min=10000, max=99999), random.choice(city_ids)) for _ in range(num_locations)]

for location in locations:
    cursor.execute("INSERT INTO locations (latitude, longitude, zipcode, cityId) VALUES (?, ?, ?, ?)", location)
 


num_region_areas = 20000
region_areas = []
for i in range(num_region_areas):
    city_id = random.choice(city_ids)
    state_id = random.choice(state_ids)
    country_id = random.choice(country_ids)
    name = fake.city() + ' ' + fake.word()
    region_areas.append((name, city_id, state_id, country_id))

for region_area in region_areas:
    cursor.execute("INSERT INTO regionAreas (name, cityId, stateId, countryId) VALUES (?, ?, ?, ?)", region_area)

cnxn.commit()

# Insert regions
num_regions = 80000
regions = []
for i in range(num_regions):
    region_area_id = random.choice(range(1, num_region_areas+1))
    name = fake.word() + ' Region'
    regions.append((name, region_area_id))

for region in regions:
    cursor.execute("INSERT INTO regions (name, regionAreaId) VALUES (?, ?)", region)
print("ok")
cnxn.commit()
cnxn.close()



















