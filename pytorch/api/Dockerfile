# Use the official Miniconda base image
FROM continuumio/miniconda3:22.11.1

# Set a working directory
WORKDIR /app


# Copy your Conda environment.yml file into the container
COPY environment.yml .

run echo 1

# Create a Conda environment based on the environment.yml file
RUN conda env create --file environment.yml
# TODO libgfortran never worked in linux

# Activate the Conda environment
RUN echo 'conda activate env-app'
SHELL ["conda", "run", "-n", "env-app", "/bin/bash", "-c"]
RUN conda info --envs
# conda activate env-app
# Copy your Flask app into the container
COPY app.py .

# Expose the port your Flask app will run on (change to the port your app uses)
EXPOSE 5001

RUN ls -li

RUN echo 'conda install flask'
RUN conda install flask

RUN echo 'conda list'
RUN conda list

RUN echo 'CMD run flask'
# CMD ["python", "-m", "flask", "run"]
CMD ["/bin/bash", "-c", "source activate env-app && flask run --host=0.0.0.0"]
