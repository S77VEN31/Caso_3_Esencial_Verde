import pyodbc
from faker import Faker
import random
import datetime
import time
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

# === FILL VARIABLES === #
countries_dict = {'out': 'countries inserted', 'num': 200 }
states_dict = {'out': 'states inserted', 'num': 500 }
cities_dict = {'out': 'cities inserted', 'num': 2000 }
locations_dict = {'out': 'locations inserted', 'num': 5000 }
regionAreasAndRegions_dict = {'out': 'region areas and regions inserted', 'num1': 2000,'num2': 4000 }
contacts_dict = {'out': 'contacts inserted', 'num': 20000, 'data': ('Carrier','Customer', 'Supplier', 'Partner', 'Competitor', 'Investor', 'Employee', 'Former employee', 'Sales contact', 'Marketing contact', 'Public relations contact', 'Human resources contact', 'Customer service contact', 'Technical support contact', 'Supplier contact', 'Logistics contact', 'Driver', 'Buyer', 'Seller') }
languages_dict = {'out': 'languages inserted', 'data': [('en', 'English'), ('es', 'Spanish'), ('fr', 'French')] }
textObjectTypes_dict = {'out': 'text object types inserted'}
translations_dict = {'out': 'translations inserted', 'num': 20, 'data': {'lang': [2, 3], 'langCode': ['en','es','fr']} }
companyCategories_dict = {'out': 'company categories inserted', 'data': [
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
    ] }
companies_dict = {'out': 'companies inserted', 'num': 3000 }
invoices_dict = {'out': 'invoices inserted', 'num': 1000 }
currencies_dict = {'out': 'currencies inserted', 'data': [
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
    ] }
currencyRates_dict = {'out': 'currency rates inserted', 'num': 1000 }
transactions_dict = {'out': 'transactions inserted', 'num': 5000 }
payments_dict = {'out': 'payments inserted', 'num': 5000 }
brands_dict = {'out': 'brands inserted', 'num': 30 }
models_dict = {'out': 'models inserted', 'num': 50 }
fleets_dict = {'out': 'fleets inserted', 'num': 200 }
containers_dict = {'out': 'containers inserted', 'num': 40000 }


# === countries === #
def countries (props): 
    num_countries = props['num']
    countries = [(fake.country(), fake.country_code(representation="alpha-2"), fake.random_int(min=1, max=999)) for _ in range(num_countries)]
    for country in countries:
        cursor.execute("INSERT INTO countries (name, nameCode, phoneCode) VALUES (?, ?, ?)", country)
    print(props['out'])
    cnxn.commit()

# === states === #
def states (props):
    num_states = props['num']
    states = [(fake.state(), random.choice(country_ids)) for _ in range(num_states)]
    for state in states:
        cursor.execute("INSERT INTO states (name, countryId) VALUES (?, ?)", state)
    print(props['out'])
    cnxn.commit()

# === cities === #
def cities (props):
    num_cities = props['num']
    cities = [(fake.city(), random.choice(state_ids)) for _ in range(num_cities)]
    for city in cities:
        cursor.execute("INSERT INTO cities (name, stateId) VALUES (?, ?)", city)
    print(props['out'])
    cnxn.commit()

# === locations === #
def locations (props):
    num_locations = props['num']
    locations = [(fake.latitude(), fake.longitude(), fake.random_int(min=10000, max=99999), random.choice(city_ids)) for _ in range(num_locations)]
    for location in locations:
        cursor.execute("INSERT INTO locations (latitude, longitude, zipcode, cityId) VALUES (?, ?, ?, ?)", location)
    print(props['out'])
    cnxn.commit()

# === regionAreas and regions === #
def regionAreasAndRegions (props):
    # === regionAreas === #
    num_region_areas = props['num1']
    region_areas = []
    for _ in range(num_region_areas):
        city_id = random.choice(city_ids)
        state_id = random.choice(state_ids)
        country_id = random.choice(country_ids)
        name = fake.city() + ' ' + fake.word()
        region_areas.append((name, city_id, state_id, country_id))
    for region_area in region_areas:
        cursor.execute("INSERT INTO regionAreas (name, cityId, stateId, countryId) VALUES (?, ?, ?, ?)", region_area)
    cnxn.commit()

    cursor.execute("SELECT regionAreasId FROM regionAreas")
    regionArea_ids = [row[0] for row in cursor.fetchall()]
    # === regions === #
    num_regions = props['num2']
    regions = []
    for _ in range(num_regions):
        region_area_id = random.choice(regionArea_ids)
        name = fake.word() + ' Region'
        regions.append((name, region_area_id))
    for region in regions:
        cursor.execute("INSERT INTO regions (name, regionAreaId) VALUES (?, ?)", region)
    print(props['out'])
    cnxn.commit()

# === contacts === #
def contacts (props):
    num_contacts = props['num']
    for _ in range(num_contacts):
        name = fake.first_name()
        surname1 = fake.last_name()
        surname2 = fake.last_name()
        email = fake.email()
        phone = fake.numerify(text='##########')
        notes = fake.text()
        contactType = fake.random_element(elements=props['data'])
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
    print(props['out'])
    cnxn.commit()

# === languages === #
def languages (props):
    lang_data = props['data']
    cursor.executemany("INSERT INTO languages (code, name) VALUES (?, ?)", lang_data)
    print(props['out'])
    cnxn.commit()

# === textObjectTypes === #
def textObjectTypes (props):
    cursor.execute("INSERT INTO textObjectTypes (textObjectTypeName) VALUES ('label')", )
    print(props['out'])
    cnxn.commit()

# === translations === #
def translations (props):
    num_translations = props['num']
    languages = props['data']['lang']
    languages_code = props['data']['langCode']
    query = "INSERT INTO translations (transactionFrom, transactionTo, textObjectTypeId, translationKey, translationValue) VALUES (?, ?, ?, ?, ?)"
    for _ in range(num_translations):
        transaction_from = 1
        lang_choice = random.choice(languages)
        transaction_to = lang_choice
        text_object_type_id = 1 
        text = fake.text()  
        translation_key = text  
        translation_value = translator.translate(text, src='en', dest=languages_code[lang_choice - 1]).text 
        params = (transaction_from, transaction_to, text_object_type_id, translation_key, translation_value)
        cursor.execute(query, params)
    print(props['out'])
    cnxn.commit()

# === companyCategories === #
def companyCategories (props):
    company_categories = props['data']
    for category in company_categories:
        cursor.execute("INSERT INTO companyCategories (name, description) VALUES (?, ?)", category)
    print(props['out'])
    cnxn.commit()

# === companies === #
def companies (props):
    num_companies = props['num']
    for _ in range(num_companies):
        company_name = fake.company()
        company_category = random.choice(companyCategory_ids)
        is_local = random.choice([0, 1])
        carbon_footprint = round(random.uniform(1, 10000), 2)
        active = random.choice([0, 1])
        create_at = fake.date_between(start_date='-3y', end_date='today')
        update_at = fake.date_between(start_date=create_at, end_date='today')
        checksum = fake.binary(length=64)
        cursor.execute(f"INSERT INTO companies (companyName, companyCategoryId, isLocal, carbonFootprint, active, createAt, updateAt, checksum) "
                    f"VALUES ('{company_name}', {company_category}, {is_local}, {carbon_footprint}, {active}, '{create_at}', '{update_at}', 0x{checksum.hex()})")
    print(props['out'])
    cnxn.commit()

# === invoices === #
def invoices (props):
    num_invoices = props['num']
    for _ in range(num_invoices):
        postdate = fake.date_between(start_date='-3y', end_date='today')
        posttime = fake.time()
        duedate = fake.date_between(start_date=postdate, end_date='+6m')
        amount = round(random.uniform(10, 1000), 2)
        status = random.choice([1, 2, 3])
        seller_contact = random.choice(seller)
        buyer_contact = random.choice(buyer)
        company_id = random.choice(company)
        details = fake.text()
        checksum = fake.binary(length=64)
        cursor.execute(f"INSERT INTO invoices (postdate, posttime, duedate, amount, status, sellerContact, buyerContact, companyId, details, CHECKSUM) "
                    f"VALUES ('{postdate}', '{posttime}', '{duedate}', {amount}, {status}, {seller_contact}, {buyer_contact}, {company_id}, '{details}', 0x{checksum.hex()})")
    print(props['out'])
    cnxn.commit()

# === currencies === #
def currencies (props):
    exchanges = props['data']
    for exchange in exchanges:
        code = exchange['code']
        name = exchange['name']
        symbol = exchange['symbol']
        default_currency = exchange['defaultCurrency']
        cursor.execute(f"INSERT INTO currencies (code, name, symbol, defaultCurrency) "
                    f"VALUES ('{code}', '{name}', '{symbol}', {default_currency})")
    print(props['out'])
    cnxn.commit()

# === currencyRates === #
def currencyRates (props):
    num_currencyRates = props['num']
    for _ in range(num_currencyRates):
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
    print(props['out'])
    cnxn.commit()

# === transactions === #
def transactions (props):
    num_transactions = props['num']
    for _ in range(num_transactions):
        transaction_date = fake.date_between(start_date='-3y', end_date='today')
        transaction_time = fake.time()
        transaction_type = random.choice([1, 2, 3, 4])
        account_number = fake.pystr(max_chars=50) if transaction_type == 3 else None
        account_iban = fake.iban() if transaction_type in [1, 2] else None
        currency_rate_id = random.choice(currencyRate_ids)
        amount = round(random.uniform(1, 100000), 2)
        details = fake.text(max_nb_chars=255)
        create_at = fake.date_between(start_date='-3y', end_date='today')
        update_at = fake.date_between(start_date=create_at, end_date='today')
        checksum = fake.binary(length=64)
        cursor.execute(f"INSERT INTO transactions (transactionDate, transactionTime, transactionType, acountNumber, acountIban, currencyRateId, amount, details, createAt, updateAt, checksum) "
                    f"VALUES ('{transaction_date}', '{transaction_time}', {transaction_type}, '{account_number}', '{account_iban}', {currency_rate_id}, {amount}, '{details}', '{create_at}', '{update_at}', 0x{checksum.hex()})")
    print(props['out'])
    cnxn.commit()

# === payments === #
def payments (props):
    num_payments = props['num']
    for _ in range(num_payments):
        invoiceId = random.choice(invoice)
        transactionId = random.choice(transaction)
        paymentDate = fake.date()
        paymentTime = fake.time()
        amount = round(random.uniform(10, 100), 2)
        details = fake.sentence()
        checksum = fake.binary(length=64)
        query = f"INSERT INTO payments (invoiceId, paymentDate, paymentTime, amount, details, transactionId, CHECKSUM) VALUES ({invoiceId}, '{paymentDate}', '{paymentTime}', {amount}, '{details}', {transactionId}, 0x{checksum.hex()})"
        cursor.execute(query)
    print(props['out'])
    cnxn.commit()

# === brands === #
def brands(props):
    num_brands = props['num']
    brands_data = [(i+1, fake.company()) for i in range(num_brands)]
    cursor.executemany("INSERT INTO brands (brandId, brandName) VALUES (?, ?)", brands_data)
    print(props['out'])
    cnxn.commit()

# === models === #
def models(props):
    num_models = props['num']
    models_data = [(i+1, fake.word(), fake.random_int(min=1, max=10), fake.random_int(min=1, max=30)) for i in range(num_models)]
    cursor.executemany("INSERT INTO models (modelId, modelName, typeId, brandId) VALUES (?, ?, ?, ?)", models_data)
    print(props['out'])
    cnxn.commit()

# === fleets === #
def fleets(props):
    num_fleet = props['num']
    fleet_data = [(fake.random_int(min=1, max=50), fake.hex_color(), fake.random_int(min=0, max=1)) for _ in range(num_fleet)]
    cursor.executemany("INSERT INTO fleet (modelId, color, active) VALUES (?, ?, ?)", fleet_data)
    print(props['out'])
    cnxn.commit()

# === containers === #
def containers(props):
    containers_data = []
    num_containers = props['num']
    for _ in range(num_containers):
        manufacturer_info = fake.company()
        max_weight = round(random.uniform(1, 1000), 2)
        containers_data.append((manufacturer_info, fake.random_int(min=0, max=1), max_weight, 1))
    cursor.executemany("INSERT INTO containers (manufacturerInfo, isInUse, maxWeight, active) VALUES (?, ?, ?, ?)", containers_data)
    print(props['out'])
    cnxn.commit()











countries(countries_dict)
cursor.execute("SELECT countryId FROM countries")
country_ids = [row[0] for row in cursor.fetchall()]
states (states_dict)
cursor.execute("SELECT stateId FROM states")
state_ids = [row[0] for row in cursor.fetchall()]
cities (cities_dict)
cursor.execute("SELECT cityId FROM cities")
city_ids = [row[0] for row in cursor.fetchall()]
locations (locations_dict)
regionAreasAndRegions (regionAreasAndRegions_dict)
contacts (contacts_dict)
cursor.execute("SELECT contactId FROM contacts")
seller = [row[0] for row in cursor.fetchall()]
cursor.execute("SELECT contactId FROM contacts")
buyer = [row[0] for row in cursor.fetchall()]
languages (languages_dict)
textObjectTypes (textObjectTypes_dict)
#translations (translations_dict)
companyCategories (companyCategories_dict)
cursor.execute("SELECT companyCategoryId FROM companyCategories")
companyCategory_ids = [row[0] for row in cursor.fetchall()]
companies(companies_dict)
cursor.execute("SELECT companyId FROM companies")
company = [row[0] for row in cursor.fetchall()]
invoices(invoices_dict)
cursor.execute("SELECT invoiceId FROM invoices")
invoice = [row[0] for row in cursor.fetchall()]
currencies(currencies_dict)
cursor.execute("SELECT currencyId FROM currencies")
currency_ids = [row[0] for row in cursor.fetchall()]
currencyRates (currencyRates_dict)
cursor.execute("SELECT currencyRateId FROM currencyRates")
currencyRate_ids = [row[0] for row in cursor.fetchall()]
transactions(transactions_dict)
cursor.execute("SELECT transactionId FROM transactions")
transaction = [row[0] for row in cursor.fetchall()]
payments(payments_dict)
brands(brands_dict)
models(models_dict)
fleets(fleets_dict)

containers(containers_dict)

for i in range(containers_dict['num']):
    try:
        # Select a random container and waste type
        cursor.execute("SELECT TOP 1 containerId, manufacturerInfo FROM containers ORDER BY NEWID()")
        container_id, manufacturer_info = cursor.fetchone()
        cursor.execute("SELECT TOP 1 wasteTypeId, name FROM wasteTypes ORDER BY NEWID()")
        waste_type_id, waste_type_name = cursor.fetchone()

        # Insert the container and waste type into the containersXwasteTypes table
        query = f"INSERT INTO containersXwasteTypes (containerId, wasteTypeId) VALUES ({container_id}, {waste_type_id})"
        cursor.execute(query)
        cnxn.commit()
    except Exception as e:
        print(f"An error occurred on iteration {i+1}: {e}")
        continue

cnxn.close()
