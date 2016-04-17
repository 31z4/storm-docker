FROM java:8-jre-alpine
MAINTAINER Elisey Zanko <elisey.zanko@gmail.com>

# Install required packages
RUN apk add --no-cache \
    bash=4.3.42-r3 \
    gnupg=2.1.10-r0 \
    python=2.7.11-r3

ENV GPG_KEY 8DE03962E80B8FFD
ENV DISTRO_NAME apache-storm-0.9.6

# Download Apache Storm, verify its PGP signature and untar
RUN set -ex \
    && wget -q "http://www-eu.apache.org/dist/storm/$DISTRO_NAME/$DISTRO_NAME.tar.gz" \
    && wget -q "http://www.us.apache.org/dist/storm/$DISTRO_NAME/$DISTRO_NAME.tar.gz.asc" \
    && export GNUPGHOME="$(mktemp -d)" \
    && gpg --keyserver pgpkeys.mit.edu --recv-key "$GPG_KEY" \
    && gpg --verify "$DISTRO_NAME.tar.gz.asc" "$DISTRO_NAME.tar.gz" \
    && tar -xzf "$DISTRO_NAME.tar.gz" \
    && rm -rf "$GNUPGHOME" "$DISTRO_NAME.tar.gz" "$DISTRO_NAME.tar.gz.asc"

WORKDIR $DISTRO_NAME
ENTRYPOINT ["bin/storm"]
