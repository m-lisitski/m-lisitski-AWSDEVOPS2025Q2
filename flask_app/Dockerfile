FROM python:3.12-slim  

WORKDIR /app  

COPY . /app  

RUN pip install -r requirements.txt  

ENV FLASK_APP=main.py

EXPOSE 8080

CMD ["python", "main.py"]