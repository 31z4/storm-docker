FROM java:8-jre-alpine
MAINTAINER Elisey Zanko <elisey.zanko@gmail.com>

# Install required packages
RUN apk add --no-cache \
    bash \
    python

ENV STORM_USER storm
ENV STORM_USER_DIR /home/storm
ENV STORM_LOCAL_DIR /data
ENV STORM_LOG_DIR /logs

# Add user and make dirs
RUN set -x \
    && adduser -D "$STORM_USER" -h "$STORM_USER_DIR"\
    && mkdir -p "$STORM_LOCAL_DIR" "$STORM_LOG_DIR" \
    && chown -R "$STORM_USER:$STORM_USER" "$STORM_LOCAL_DIR" "$STORM_LOG_DIR"

ENV GPG_KEY ACEFE18DD2322E1E84587A148DE03962E80B8FFD
ENV DISTRO_NAME apache-storm-0.10.1
ENV PATH $PATH:/$DISTRO_NAME/bin

# Download Apache Storm, verify its PGP signature, untar and clean up
RUN set -x \
    && apk add --no-cache --virtual .build-deps \
        gnupg \
    && wget -q "http://www-eu.apache.org/dist/storm/$DISTRO_NAME/$DISTRO_NAME.tar.gz" \
    && wget -q "http://www.us.apache.org/dist/storm/$DISTRO_NAME/$DISTRO_NAME.tar.gz.asc" \
    && export GNUPGHOME="$(mktemp -d)" \
    && gpg --keyserver ha.pool.sks-keyservers.net --recv-key "$GPG_KEY" \
    && gpg --batch --verify "$DISTRO_NAME.tar.gz.asc" "$DISTRO_NAME.tar.gz" \
    && tar -xzf "$DISTRO_NAME.tar.gz" \
    && chown -R "$STORM_USER:$STORM_USER" "$DISTRO_NAME" \
    && rm -r "$GNUPGHOME" "$DISTRO_NAME.tar.gz" "$DISTRO_NAME.tar.gz.asc" \
    && apk del .build-deps

WORKDIR $DISTRO_NAME
USER storm
