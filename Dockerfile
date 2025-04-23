FROM python:3.10

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

RUN apt-get update && apt-get install -y cron

WORKDIR /app

RUN pip install --upgrade pip

ADD requirements_web.txt .
RUN pip install -r requirements_web.txt

COPY src src

EXPOSE 8000
CMD ["/app/src/prerun/prerun.bash"]