#!/usr/bin/env sh

addgroup -g $USER_GID user
adduser -h /home/user -G user -D -u $USER_UID user

mkdir -p /var/lib/chproxy
chown user:user /var/lib/chproxy

su-exec user /usr/local/bin/chproxy -config=/etc/chproxy.yml &
child=$!

trap "kill $child" INT TERM
wait "$child"
trap - INT TERM
wait "$child"
