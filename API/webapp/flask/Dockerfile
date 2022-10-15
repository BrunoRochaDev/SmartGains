# Use the Python3.7.2 image
FROM python:3.7.2-stretch

# Set the working directory to /app
WORKDIR /webapp

# Copy the current directory contents into the container at /challenge
ADD . /webapp

# Install the dependencies
RUN pip3 install -r requirements.txt

# run the command to start uWSGI
CMD ["uwsgi", "app.ini"]