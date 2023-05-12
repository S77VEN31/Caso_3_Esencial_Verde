from flask import Flask, render_template
from models import db
app = Flask(__name__)


@app.route('/')
def index():
    return render_template('index.html')

@app.route('/about')
def about():
    return render_template('about.html')

@app.route('/contact')
def contact():
    return render_template('contact.html')

@app.route('/containers')
def containers():
    operations = ["Pickup", "Delivery", "Transfer", "Cleaning", "Maintenance", "Repair"]
    ranProducer = db.get_random_logIn()
    wasteTypes = db.get_wasteTypes()
    return render_template('containers.html', ranProducer=ranProducer, wasteTypes=wasteTypes, operations = operations)


if __name__ == '__main__':
    app.run(debug=True)



