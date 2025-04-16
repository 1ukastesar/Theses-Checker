FROM python:3.10

WORKDIR /app

ADD requirements_web.txt .
RUN pip install -r requirements_web.txt

# Possibly redundant, make sure at least one copy is there
# either by this COPY, or bind mounted repo from host
COPY . .
VOLUME /app
EXPOSE 8000

ENTRYPOINT ["python", "src/web/manage.py", "runserver", "0.0.0.0:8000"]
