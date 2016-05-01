FROM java:8-jre-alpine
MAINTAINER Elisey Zanko <elisey.zanko@gmail.com>

# Install required packages
RUN apk add --no-cache \
    bash=4.3.42-r3 \
    gnupg=2.1.10-r0 \
    python=2.7.11-r3

ENV STORM_USER storm
ENV STORM_USER_DIR /home/storm
ENV STORM_LOCAL_DIR /data
ENV STORM_LOG_DIR /logs

# Add user and make dirs
RUN set -ex \
    && adduser -D "$STORM_USER" -h "$STORM_USER_DIR"\
    && mkdir -p "$STORM_LOCAL_DIR" "$STORM_LOG_DIR" \
    && chown -R "$STORM_USER:$STORM_USER" "$STORM_LOCAL_DIR" "$STORM_LOG_DIR"

ENV GPG_KEY 8DE03962E80B8FFD
ENV DISTRO_NAME apache-storm-1.0.0

USER storm

# Download Apache Storm, verify its PGP signature and untar
RUN set -ex \
    && cd "$STORM_USER_DIR" \
    && wget -q "http://www-eu.apache.org/dist/storm/$DISTRO_NAME/$DISTRO_NAME.tar.gz" \
    && wget -q "http://www.us.apache.org/dist/storm/$DISTRO_NAME/$DISTRO_NAME.tar.gz.asc" \
    && export GNUPGHOME="$(mktemp -d)" \
    && gpg --keyserver ha.pool.sks-keyservers.net --recv-key "$GPG_KEY" \
    && gpg --verify "$DISTRO_NAME.tar.gz.asc" "$DISTRO_NAME.tar.gz" \
    && tar -xzf "$DISTRO_NAME.tar.gz" \
    && rm -rf "$GNUPGHOME" "$DISTRO_NAME.tar.gz" "$DISTRO_NAME.tar.gz.asc"

WORKDIR $STORM_USER_DIR/$DISTRO_NAME
ENTRYPOINT ["bin/storm"]
