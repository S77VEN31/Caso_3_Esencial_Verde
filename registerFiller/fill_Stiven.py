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

# === contacts === #
num_contacts = 5000
for i in range(num_contacts):
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
    checksum = fake.binary(length=64)
    cursor.execute("""
        INSERT INTO contacts (name, surname1, surname2, email, phone, notes, contactType, active, createAt, updateAt, CHECKSUM)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    """, (name, surname1, surname2, email, phone, notes, contactType, active, createAt_str, updateAt_str, checksum))

# === languages === #
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

# === companyCategories === #
company_categories = [
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
    ('Municipal', 'Municipal waste producers.')
]
for category in company_categories:
    cursor.execute("INSERT INTO companyCategories (name, description) VALUES (?, ?)", category)

# === companies === #
for i in range(500):
    company_name = fake.company()
    company_category = random.choice([row[0] for row in cursor.execute("SELECT companyCategoryId FROM companyCategories")])
    is_local = random.choice([0, 1])
    carbon_footprint = round(random.uniform(1, 10000), 2)
    active = random.choice([0, 1])
    create_at = fake.date_between(start_date='-3y', end_date='today')
    update_at = fake.date_between(start_date=create_at, end_date='today')
    checksum = fake.binary(length=64)
    cursor.execute(f"INSERT INTO companies (companyName, companyCategoryId, isLocal, carbonFootprint, active, createAt, updateAt, checksum) "
                   f"VALUES ('{company_name}', {company_category}, {is_local}, {carbon_footprint}, {active}, '{create_at}', '{update_at}', 0x{checksum.hex()})")

# === invoices === #
for i in range(100):
    postdate = fake.date_between(start_date='-3y', end_date='today')
    posttime = fake.time()
    duedate = fake.date_between(start_date=postdate, end_date='+6m')
    amount = round(random.uniform(10, 1000), 2)
    status = random.choice([1, 2, 3])
    
    cursor.execute("SELECT contactId FROM contacts")
    seller = [row[0] for row in cursor.fetchall()]
    
    cursor.execute("SELECT contactId FROM contacts")
    buyer = [row[0] for row in cursor.fetchall()]
    
    cursor.execute("SELECT companyId FROM companies")
    company = [row[0] for row in cursor.fetchall()]
    
    seller_contact = random.choice(seller)
    buyer_contact = random.choice(buyer)
    company_id = random.choice(company)
    details = fake.text()
    checksum = fake.binary(length=64)
    
    cursor.execute(f"INSERT INTO invoices (postdate, posttime, duedate, amount, status, sellerContact, buyerContact, companyId, details, CHECKSUM) "
                   f"VALUES ('{postdate}', '{posttime}', '{duedate}', {amount}, {status}, {seller_contact}, {buyer_contact}, {company_id}, '{details}', 0x{checksum.hex()})")

# === currencies === #
exchanges = [
    {
        'code': 'USD',
        'name': 'US Dollar',
        'symbol': '$',
        'defaultCurrency': 1
    },
    {
        'code': 'EUR',
        'name': 'Euro',
        'symbol': '€',
        'defaultCurrency': 0
    },
    {
        'code': 'JPY',
        'name': 'Japanese Yen',
        'symbol': '¥',
        'defaultCurrency': 0
    }
]
for exchange in exchanges:
    code = exchange['code']
    name = exchange['name']
    symbol = exchange['symbol']
    default_currency = exchange['defaultCurrency']
    cursor.execute(f"INSERT INTO currencies (code, name, symbol, defaultCurrency) "
                   f"VALUES ('{code}', '{name}', '{symbol}', {default_currency})")
    
# === currencyRates === #
cursor.execute("SELECT currencyId FROM currencies")
currency_ids = [row[0] for row in cursor.fetchall()]
for i in range(500):
    currency_from = random.choice(currency_ids)
    currency_to = random.choice(currency_ids)
    while currency_to == currency_from:
        currency_to = random.choice(currency_ids)
    rate = round(random.uniform(0.01, 100), 4)
    create_at = fake.date_between(start_date='-3y', end_date='today')
    update_at = fake.date_between(start_date=create_at, end_date='today')
    checksum = fake.binary(length=64)
    cursor.execute(f"INSERT INTO currencyRates (currencyFrom, currencyTo, rate, createAt, updateAt, checksum) "
                   f"VALUES ({currency_from}, {currency_to}, {rate}, '{create_at}', '{update_at}', 0x{checksum.hex()})")

# === transactions === #
for i in range(500):
    transaction_date = fake.date_between(start_date='-3y', end_date='today')
    transaction_time = fake.time()
    transaction_type = random.choice([1, 2, 3, 4])
    account_number = fake.pystr(max_chars=50) if transaction_type == 3 else None
    account_iban = fake.iban() if transaction_type in [1, 2] else None
    currency_rate_id = random.randint(1, 100) # assuming currencyRates table already has data
    amount = round(random.uniform(1, 100000), 2)
    details = fake.text(max_nb_chars=255)
    create_at = fake.date_between(start_date='-3y', end_date='today')
    update_at = fake.date_between(start_date=create_at, end_date='today')
    checksum = fake.binary(length=64)
    
    # Execute the INSERT statement
    cursor.execute(f"INSERT INTO transactions (transactionDate, transactionTime, transactionType, acountNumber, acountIban, currencyRateId, amount, details, createAt, updateAt, checksum) "
                   f"VALUES ('{transaction_date}', '{transaction_time}', {transaction_type}, '{account_number}', '{account_iban}', {currency_rate_id}, {amount}, '{details}', '{create_at}', '{update_at}', 0x{checksum.hex()})")

# === payments === #
for i in range(3000):
    cursor.execute("SELECT invoiceId FROM invoices")
    invoice = [row[0] for row in cursor.fetchall()]
    invoiceId = random.choice(invoice)
    cursor.execute("SELECT transactionId FROM transactions")
    transaction = [row[0] for row in cursor.fetchall()]
    transactionId = random.choice(transaction)
    paymentDate = fake.date()
    paymentTime = fake.time()
    amount = round(random.uniform(10, 100), 2)
    details = fake.sentence()
    checksum = fake.binary(length=64)
    query = f"INSERT INTO payments (invoiceId, paymentDate, paymentTime, amount, details, transactionId, CHECKSUM) VALUES ({invoiceId}, '{paymentDate}', '{paymentTime}', {amount}, '{details}', {transactionId}, 0x{checksum.hex()})"
    cursor.execute(query)
    
print("ok")
cnxn.commit()
cnxn.close()



















