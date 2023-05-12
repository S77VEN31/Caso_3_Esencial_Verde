from flask import Flask, render_template, request
from models import db
from flask import jsonify

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

@app.route("/containers")
def containers():
    operations = ["Pickup", "Delivery"]
    ranProducer = db.get_random_logIn()
    wasteTypes = db.get_wasteTypes()
    companies = db.get_companies()
    producers = db.get_producers()
    compXprod = db.get_companies_producers(companies, producers)
    return render_template(
        "containers.html",
        ranProducer=ranProducer,
        wasteTypes=wasteTypes,
        operations=operations,
        companies=companies,
        producers=producers,
        compXprod  = compXprod 
    )


if __name__ == "__main__":
    app.run(debug=True)
