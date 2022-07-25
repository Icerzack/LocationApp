FROM python:3 
COPY . .

RUN pip3 install -r requirements.txt
RUN apt update
RUN apt-get install -y postgresql
CMD ["service", "postgresql", "start"]

#pg_ctlcluster 13 main start

# runs python3 aserver.py
CMD ["python3", "aserver.py"]