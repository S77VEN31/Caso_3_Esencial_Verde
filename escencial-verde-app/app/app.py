from flask import Flask, render_template, request
from models import db


app = Flask(__name__)
app.config['SESSION_TYPE'] = 'filesystem'


@app.route("/")
def index():
    return render_template("index.html")


@app.route("/about")
def about():
    return render_template("about.html")


@app.route("/contact")
def contact():
    return render_template("contact.html")

@app.route("/containers", methods=['GET','POST'])
def containers():
    operations = ["Pickup", "Delivery"]
    ranProducer = db.get_random_logIn()
    wasteTypes = db.get_wasteTypes()
    companies = db.get_companies()
    producers = db.get_producers()
    compXprod = db.get_companies_producers(companies, producers)
    carrier = db.get_random_carrier()
    fleet = db.get_random_fleet()
    location = db.get_random_logIn()

    if request.method == 'POST':
        input_value = request.form.get('input-value')
        with open("error.json", "w") as f:
                f.write(input_value + "\n")
    return render_template(
        "containers.html",
        ranProducer=ranProducer,
        wasteTypes=wasteTypes,
        operations=operations,
        companies=companies,
        producers=producers,
        compXprod=compXprod,
        carrier=carrier,
        fleet=fleet,
        location=location
    )


if __name__ == "__main__":
    app.run(debug=True)
