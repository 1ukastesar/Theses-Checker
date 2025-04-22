#!/bin/bash

# Generate a Django secret key
SECRET_KEY=$(python3 -c "import secrets; import string; print(''.join(secrets.choice(string.ascii_letters + string.digits) for _ in range(50)))")

# Write to ../web/.env

cat > /app/src/web/.env <<EOF
SECRET_KEY=$SECRET_KEY
DEBUG=True
ALLOWED_HOSTS=127.0.0.1, .localhost, 0.0.0.0
OPERATING_SYSTEM=Linux
STATIC_URL=static/
EOF

echo ".env file created at ../web/.env"
cat ../web/.env
echo "starting server"
python src/web/manage.py runserver 0.0.0.0:8000
