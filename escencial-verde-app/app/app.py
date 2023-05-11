from flask import Flask, render_template
from models import db
app = Flask(__name__)




@app.route('/')
def index():
    data = db.get_top_100_data()
    return render_template('index.html', data=data)

@app.route('/about')
def about():
    return render_template('about.html')

@app.route('/contact')
def contact():
    return render_template('contact.html')

if __name__ == '__main__':
    app.run(debug=True)



