FROM python:3.11-slim

# system deps
RUN apt-get update && apt-get install -y build-essential libpq-dev telnet && rm -rf /var/lib/apt/lists/*

# copy dependency files first for cache
COPY requirements*.txt /tmp/
RUN pip install --no-cache-dir -r /tmp/requirements.txt

# copy source
COPY . /app
WORKDIR /app

# expose Evennia ports
EXPOSE 4000 4001 4002

CMD ["evennia", "start", "--log"]
