#!/usr/bin/env sh

groupadd -g $USER_GID user
useradd -d /home/user -g user -u $USER_UID user

mkdir -p /var/lib/chproxy
chown user:user /var/lib/chproxy

gosu user /usr/local/bin/chproxy -config=/etc/chproxy.yml &
child=$!

trap "kill $child" INT TERM
wait "$child"
trap - INT TERM
wait "$child"
