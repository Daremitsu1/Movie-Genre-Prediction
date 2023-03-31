# Set base image to R
FROM r-base:4.1.0

# Install required packages in R
RUN R -e "install.packages(c('tidyverse', 'caret', 'randomForest', 'e1071'))"

# Copy R script to container
COPY movie_genre_predictor.R /app/

# Set working directory
WORKDIR /app

# Set entrypoint to Rscript for running the R script
ENTRYPOINT ["Rscript", "movie_genre_predictor.R"]

# Set base image to Python
FROM python:3.9

# Copy requirements file to container
COPY requirements.txt /app/

# Install required packages in Python
RUN pip install -r /app/requirements.txt

# Copy Python script and model to container
COPY movie_genre_predictor.py /app/
COPY movie_genre_model.RData /app/

# Set working directory
WORKDIR /app

# Expose port for Streamlit app
EXPOSE 8501

# Set entrypoint to Streamlit command for running the Python script as a Streamlit app
ENTRYPOINT ["streamlit", "run", "--server.port", "8501", "movie_genre_predictor.py"]
