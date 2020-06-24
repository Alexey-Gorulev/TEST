FROM python:3.9.0a6-alpine

RUN python3 -m pip install Django

COPY ./SimpleSite /app

WORKDIR /app

EXPOSE 80

CMD ["python3", "manage.py", "runserver", "0.0.0.0:80"]
