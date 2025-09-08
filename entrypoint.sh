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

    # Attempt to create superuser and capture output and exit code
    output=$($POCKETBASE_BIN --dir="$PB_DATA_DIR" superuser create "$PB_ADMIN_EMAIL" "$PB_ADMIN_PASSWORD" 2>&1)
    exit_code=$?

    # Check exit code first for success
    if [ $exit_code -eq 0 ]; then
        echo "Successfully created default admin user"
        return 0
    # Fallback: Check if user already exists by looking for the unique constraint error
    elif echo "$output" | grep -q "email: Value must be unique"; then
        echo "Admin user $PB_ADMIN_EMAIL already exists, skipping creation"
        return 0
    else
        echo "Failed to create admin user: $output"
        return 1
    fi
}

# Create superuser if environment variables are set
if [ -n "$PB_ADMIN_EMAIL" ] && [ -n "$PB_ADMIN_PASSWORD" ]; then
    echo "Attempting to create default admin user: $PB_ADMIN_EMAIL"
    create_superuser
fi

# Start PocketBase server
exec /usr/local/bin/pocketbase serve --http=0.0.0.0:8090 --dir="$PB_DATA_DIR" --publicDir="$PB_PUBLIC_DIR" --hooksDir="$PB_HOOKS_DIR" "$@"
