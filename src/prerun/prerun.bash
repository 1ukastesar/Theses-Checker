#!/bin/bash

# Generate a Django secret key
SECRET_KEY=$(python3 -c "import secrets; import string; print(''.join(secrets.choice(string.ascii_letters + string.digits) for _ in range(50)))")

# set default if unset
ALLOWED_HOSTS="${ALLOWED_HOSTS:-127.0.0.1, .localhost}"
CSRF_TRUSTED_ORIGINS="${CSRF_TRUSTED_ORIGINS:-http://127.0.0.1, https://*.localhost}"
PORT="${PORT:-8000}"

# Write to ../web/.env

cat > /app/src/web/.env <<EOF
SECRET_KEY=$SECRET_KEY
DEBUG=True
ALLOWED_HOSTS=$ALLOWED_HOSTS
CSRF_TRUSTED_ORIGINS=$CSRF_TRUSTED_ORIGINS
OPERATING_SYSTEM=Linux
STATIC_URL=static/
EOF

CRON_LINE="*/5 * * * * cd /app/src/web/ && bash periodicDeleteFiles.sh >> /var/log/cron.log 2>&1"
echo "$CRON_LINE" > /etc/cron.d/periodic-delete
# Set the correct permissions
chmod 0644 /etc/cron.d/periodic-delete

# Register the cron job
crontab /etc/cron.d/periodic-delete

echo ".env file created at ../web/.env"
cat ../web/.env
echo "starting cron"
service cron start
echo "starting server"
python src/web/manage.py runserver 0.0.0.0:$PORT
