#!/bin/sh
set -e

PB_DATA_DIR="/pb_data"
PB_PUBLIC_DIR="/pb_public"
PB_HOOKS_DIR="/pb_hooks"
POCKETBASE_BIN="/usr/local/bin/pocketbase"

# Function to create superuser
create_superuser() {
    # Initialize the database
    $POCKETBASE_BIN --dir="$PB_DATA_DIR" migrate

    # Attempt to create superuser
    if $POCKETBASE_BIN --dir="$PB_DATA_DIR" superuser create "$PB_ADMIN_EMAIL" "$PB_ADMIN_PASSWORD"; then
        echo "Successfully created default admin user"
    else
        echo "Failed to create admin user. Check if user already exists or if there are any other errors in the container logs."
    fi
}

# Create superuser if environment variables are set
if [ -n "$PB_ADMIN_EMAIL" ] && [ -n "$PB_ADMIN_PASSWORD" ]; then
    echo "Attempting to create default admin user: $PB_ADMIN_EMAIL"
    create_superuser
fi

# Start PocketBase server
exec /usr/local/bin/pocketbase serve --http=0.0.0.0:8090 --dir=$PB_DATA_DIR --publicDir=$PB_PUBLIC_DIR --hooksDir=$PB_HOOKS_DIR
