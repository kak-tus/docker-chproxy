FROM alpine:3.7 AS build

ENV \
  CHPROXY_VERSION=1.12.0 \
  CHPROXY_SHA256=2671744cb6058fd9c8dd2b050dda29d85e8d5a5b25fc34cf9a6a54cf4917efde

RUN \
  apk add --no-cache \
    curl \
  \
  && cd /usr/local/bin \
  && curl -L "https://github.com/Vertamedia/chproxy/releases/download/$CHPROXY_VERSION/chproxy-linux-amd64-$CHPROXY_VERSION.tar.gz" -o "chproxy-linux-amd64-$CHPROXY_VERSION.tar.gz" \
  && echo -n "$CHPROXY_SHA256  chproxy-linux-amd64-$CHPROXY_VERSION.tar.gz" | sha256sum -c - \
  && tar -xvzf "chproxy-linux-amd64-$CHPROXY_VERSION.tar.gz" \
  && chmod +x chproxy-linux-amd64

FROM alpine:3.7

RUN \
  apk add --no-cache \
    su-exec

ENV \
  USER_UID=1000 \
  USER_GID=1000

COPY --from=build /usr/local/bin/chproxy-linux-amd64 /usr/local/bin/chproxy
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

CMD ["/usr/local/bin/entrypoint.sh"]
