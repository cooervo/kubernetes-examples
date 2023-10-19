# Use the official Miniconda base image
FROM continuumio/miniconda3:22.11.1

# Set a working directory
WORKDIR /app


# Copy your Conda environment.yml file into the container
COPY environment.yml .

# Create a Conda environment based on the environment.yml file
RUN conda env create --file environment.yml
RUN python -V
RUN pip -V
RUN pip install libgfortran=3.0.0

# Activate the Conda environment
SHELL ["conda", "run", "-n", "env-app", "/bin/bash", "-c"]

# Copy your Flask app into the container
COPY app.py .

# Expose the port your Flask app will run on (change to the port your app uses)
EXPOSE 5000

# Command to run your Flask app
CMD ["python", "app.py"]
