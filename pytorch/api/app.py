from flask import Flask, jsonify
from google.cloud import bigquery

app = Flask(__name__)

# Replace with your BigQuery project and dataset information
project_id = 'winter-field-401115'
dataset_id = 'example_dataset'

@app.route("/")
def hello_world():
    return "<p>Hello :) from flask !</p>"

@app.route("/users")
def get_users():
    try:
        client = bigquery.Client(project=project_id)
        query = f'SELECT * FROM `{project_id}.{dataset_id}.User`'
        query_job = client.query(query)
        results = query_job.result()
        users = [dict(row) for row in results]
        return jsonify(users)

    except Exception as e:
        print(e)
        return f"An error occurred: {str(e)}"