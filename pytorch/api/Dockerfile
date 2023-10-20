# Use the official Miniconda base image
FROM continuumio/miniconda3:22.11.1

# Set a working directory
WORKDIR /app

COPY environment.yml .

# Create a conda environment based on the environment.yml file
RUN conda env create --file environment.yml

# TODO libgfortran never worked in linux

EXPOSE 5001

COPY app.py .

# Activate the Conda environment and run flask server
CMD ["/bin/bash", "-c", "source activate env-app && flask run --host=0.0.0.0 --port=5001"]
