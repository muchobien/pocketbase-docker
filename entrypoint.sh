#!/bin/sh
set -e

# Function to create superuser
create_superuser() {
    # Initialize the database
    /usr/local/bin/pocketbase --dir=/pb_data migrate

    # Attempt to create superuser
    if /usr/local/bin/pocketbase --dir=/pb_data superuser create "$PB_ADMIN_EMAIL" "$PB_ADMIN_PASSWORD"; then
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
exec /usr/local/bin/pocketbase serve --http=0.0.0.0:8090 --dir=/pb_data --publicDir=/pb_public --hooksDir=/pb_hooks
