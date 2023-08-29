# syntax=docker/dockerfile:1

FROM python:3.10

WORKDIR /python-app/app

ENV FLASK_APP=app
ENV FLASK_DEBUG=false


COPY requirements.txt requirements.txt
COPY docker-start.sh docker-start.sh
RUN pip3 install -r requirements.txt

COPY app . 

# CMD [ "python3", "-m", "flask", "run", "--host=0.0.0.0" ]
CMD ./docker-start.sh 
