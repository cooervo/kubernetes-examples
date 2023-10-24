FROM mambaorg/micromamba:1-focal-cuda-11.7.1

# Set a working directory
WORKDIR /app

COPY environment.yml .

# Create a conda environment based on the environment.yml file
RUN micromamba env create --file environment.yml

EXPOSE 5001

COPY app.py .

# Activate the Conda environment and run flask server
CMD /opt/conda/envs/env-app/bin/flask run --host=0.0.0.0 --port=5001

# TODO these packages are pending installation
# RUN micromamba install ffmpeg
# RUN micromamba install x264
# RUN micromamba install openh264
# TODO libgfortran never worked in linux