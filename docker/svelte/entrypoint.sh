#!/bin/sh
set -e

fix_directory_permission() {

	mkdir -p "$1"
    chown -R $USER_ID $1
}

fix_directory_permission ${YARN_CACHE_FOLDER}
fix_directory_permission /tmp
fix_directory_permission /app/.svelte-kit
fix_directory_permission /static-svelte

# note that we need to have su-exec available in our container
exec su-exec $USER_ID "$@"
