from flask import Flask, render_template
from models import db
app = Flask(__name__)




@app.route('/')
def index():
    
    return render_template('index.html')

@app.route('/about')
def about():
    data = db.get_top_100_data()
    return render_template('about.html', data=data)

@app.route('/contact')
def contact():
    return render_template('contact.html')

@app.route('/containers')
def containers():
    return render_template('containers.html')

if __name__ == '__main__':
    app.run(debug=True)



