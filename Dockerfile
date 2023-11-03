# Stage 1: Build the application image
FROM python:3.10 as builder

# Set the working directory
WORKDIR /app

# Copy your application code to the image
COPY . .

# Build your application (replace with your build commands)
RUN pip install --upgrade pip
RUN pip install -r requirements.txt --default-timeout=100 future --progress-bar off

# Stage 2: Clone the repository
FROM alpine:latest as cloner

# Set the working directory
WORKDIR /app

# Install Git
RUN apk --no-cache add git

# Clone the Git repository (replace with your Git repository URL)
RUN git lfs install
RUN git clone https://huggingface.co/MBZUAI/LaMini-T5-738M

# Stage 3: Create the final image for storing the repository in a volume
FROM alpine:latest

# Set the working directory
WORKDIR /app

# Copy the cloned repository from the cloner stage
COPY --from=cloner /app /app

# Create a volume to store the repository data
VOLUME /app/data

# Expose the port that Streamlit will run on
EXPOSE 8501

# Command to run your Streamlit application
CMD ["streamlit", "run", "chatbot_app.py"]