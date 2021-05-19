#!/bin/sh
set -e

fix_owner() {
	mkdir -p "$1"
  chown -R $USER_ID $1
}

# fix writable folders with the right owner
for i in $(env | grep chown_ | sed 's/^.*=//')
do
  fix_owner "$i"
done


# note that we need to have su-exec available in our container
exec su-exec $USER_ID "$@"
