import pyodbc
from faker import Faker
import random
import datetime
from googletrans import Translator
faker = Faker()
translator = Translator()


server = 'localhost'
database = 'caso3'
username = 'sa'
password = 'Sven1234'
cnxn = pyodbc.connect('DRIVER={SQL Server};SERVER='+server+';DATABASE='+database+';UID='+username+';PWD='+ password)

cursor = cnxn.cursor()
fake = Faker()
'''
# === countries === #
num_countries = 200
countries = [(fake.country(), fake.country_code(representation="alpha-2"), fake.random_int(min=1, max=999)) for _ in range(num_countries)]
for country in countries:
    cursor.execute("INSERT INTO countries (name, nameCode, phoneCode) VALUES (?, ?, ?)", country)

# === states === #
num_states = 5000
cursor.execute("SELECT countryId FROM countries")
country_ids = [row[0] for row in cursor.fetchall()]
states = [(fake.state(), random.choice(country_ids)) for _ in range(num_states)]
for state in states:
    cursor.execute("INSERT INTO states (name, countryId) VALUES (?, ?)", state)

# === cities === #
num_cities = 20000
cursor.execute("SELECT stateId FROM states")
state_ids = [row[0] for row in cursor.fetchall()]
cities = [(fake.city(), random.choice(state_ids)) for _ in range(num_cities)]
for city in cities:
    cursor.execute("INSERT INTO cities (name, stateId) VALUES (?, ?)", city)

# === locations === #
num_locations = 100000
cursor.execute("SELECT cityId FROM cities")
city_ids = [row[0] for row in cursor.fetchall()]
locations = [(fake.latitude(), fake.longitude(), fake.random_int(min=10000, max=99999), random.choice(city_ids)) for _ in range(num_locations)]
for location in locations:
    cursor.execute("INSERT INTO locations (latitude, longitude, zipcode, cityId) VALUES (?, ?, ?, ?)", location)

# === regionAreas === #
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

# === regions === #
num_regions = 80000
regions = []
for i in range(num_regions):
    region_area_id = random.choice(range(1, num_region_areas+1))
    name = fake.word() + ' Region'
    regions.append((name, region_area_id))
for region in regions:
    cursor.execute("INSERT INTO regions (name, regionAreaId) VALUES (?, ?)", region)
'''
# === contacts === #
num_contacts = 5000
for i in range(100):
    name = fake.first_name()
    surname1 = fake.last_name()
    surname2 = fake.last_name()
    email = fake.email()
    phone = fake.numerify(text='##########')
    notes = fake.text()
    contactType = fake.random_element(elements=('Customer',    'Supplier',    'Partner',    'Competitor',    'Investor',    'Employee',    'Former employee',    'Sales contact',    'Marketing contact',    'Public relations contact',    'Human resources contact',    'Customer service contact',    'Technical support contact',    'Supplier contact',    'Logistics contact', 'Driver', 'Buyer', 'Seller'))
    active = fake.boolean()
    createAt = fake.date_this_decade(before_today=True, after_today=False)
    today = datetime.date.today()
    updateAt = fake.date_between_dates(date_start=createAt, date_end=today)
    createAt_str = createAt.strftime('%Y-%m-%d')
    updateAt_str = updateAt.strftime('%Y-%m-%d')
    cursor.execute("""
        INSERT INTO contacts (name, surname1, surname2, email, phone, notes, contactType, active, createAt, updateAt)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    """, (name, surname1, surname2, email, phone, notes, contactType, active, createAt_str, updateAt_str))
lang_data = [('en', 'English'), ('es', 'Spanish'), ('fr', 'French')]
cursor.executemany("INSERT INTO languages (code, name) VALUES (?, ?)", lang_data)

# === textObjectTypes === #
cursor.execute("INSERT INTO textObjectTypes (textObjectTypeName) VALUES ('label')", )

# === translations === #
languages = [2, 3] # transactionFrom and transactionTo can be between 1 and 3
num_translations = 10 # number of translations to insert
languages_code = ['en','es','fr']
query = "INSERT INTO translations (transactionFrom, transactionTo, textObjectTypeId, translationKey, translationValue) VALUES (?, ?, ?, ?, ?)"
for i in range(num_translations):
    transaction_from = 1
    lang_choice = random.choice(languages)
    transaction_to = lang_choice
    text_object_type_id = 1 # textObjectTypeId is always 1
    text = fake.text()  
    translation_key = text  # create a random key for each translation
    translation_value = translator.translate(text, src='en', dest=languages_code[lang_choice - 1]).text # create a random value for each translation
    params = (transaction_from, transaction_to, text_object_type_id, translation_key, translation_value)
    cursor.execute(query, params)

print("ok")
cnxn.commit()
cnxn.close()



















