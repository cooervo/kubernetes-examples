from flask import Flask, jsonify
from google.cloud import bigquery

app = Flask(__name__)

# Replace with your BigQuery project and dataset information
project_id = 'winter-field-401115'
dataset_id = 'example_dataset'

@app.route("/")
def hello_world():
    return "<p>Hello World :) from flask</p>"

@app.route("/users")
def get_users():
    try:
        print(1)
        client = bigquery.Client(project=project_id)
        print(2)
        query = f'SELECT * FROM `{project_id}.{dataset_id}.User`'
        print(3)
        query_job = client.query(query)
        print(4)
        results = query_job.result()
        print(5)
        users = [dict(row) for row in results]
        print(6)
        return jsonify(users)

    except Exception as e:
        print(e)
        return f"An error occurred: {str(e)}"