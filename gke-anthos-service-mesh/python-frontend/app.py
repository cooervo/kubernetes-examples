from flask import Flask, jsonify
from google.cloud import bigquery
import requests

app = Flask(__name__)

print("===> Starting Flask app")

# a simple endpoint to check flask endpoint works
@app.route("/")
def hello_world():
    return "<p>Hello :) from flask !</p>"

# endpoint to check intra-cluster communication works (pod to pod)
@app.route("/ping-node", methods=["GET"])
def query_nodejs():
    try:
        response = requests.get(f"http://backend-api:3000")
        if response.status_code == 200:
            return f"Response from backend api node: ${response.text} served through frontend flask app"
        else:
            return f"Failed to query Node.js: {response.status_code}", 500
    except requests.exceptions.RequestException as e:
        return f"Failed to connect to Node.js: {str(e)}", 500
    
# endpoint to check egress requests out of the cluster work
jsonplaceholder_url = 'https://jsonplaceholder.typicode.com/todos/1'
@app.route("/json", methods=["GET"])
def query_jsonplaceholder():
    try:
        response = requests.get(jsonplaceholder_url)
        if response.status_code == 200:
            return response.text
        else:
            return f"Failed to query JSONPlaceholder: {response.status_code}", 500
    except requests.exceptions.RequestException as e:
        return f"Failed to connect to JSONPlaceholder: {str(e)}", 500