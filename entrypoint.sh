#!/usr/bin/env sh
set -e

# Default host and port (can be overridden with PB_HOST and PB_PORT environment variables)
HOST=${PB_HOST:-0.0.0.0}
PORT=${PB_PORT:-8090}

# Default serve command arguments
DEFAULT_SERVE_ARGS="serve --http=${HOST}:${PORT} --dir=/pb_data --publicDir=/pb_public --hooksDir=/pb_hooks"

# If no arguments passed, use default serve command
if [ $# -eq 0 ]; then
    exec /usr/local/bin/pocketbase $DEFAULT_SERVE_ARGS
fi

# Handle global flags that should go to main pocketbase command
case "$1" in
    --help|-h|--version|-v)
        exec /usr/local/bin/pocketbase "$@"
        ;;
esac

# If first argument starts with '-', treat as serve arguments
if [ "${1#-}" != "$1" ]; then
    exec /usr/local/bin/pocketbase $DEFAULT_SERVE_ARGS "$@"
fi

# Otherwise, pass all arguments directly to pocketbase
exec /usr/local/bin/pocketbase "$@"
