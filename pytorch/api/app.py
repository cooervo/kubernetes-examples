print(1)
from flask import Flask

print(2)
app = Flask(__name__)

@app.route("/")
def hello_world():
    print(3)
    return "<p>Hello, World!</p>"

print(4)