#!/bin/bash
set -e

# if command starts with an option, prepend radicale
if [ "${1:0:1}" = '-' ]; then
	set -- radicale "$@"
fi

echo "-> Chowning radicale files"
chown -R radicale:radicale /data/config /data/db /home/radicale
echo "-> Starting server"
exec sudo -u radicale "$@"
