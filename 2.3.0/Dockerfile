FROM openjdk:11-jre-slim

ENV STORM_CONF_DIR=/conf \
    STORM_DATA_DIR=/data \
    STORM_LOG_DIR=/logs

# Add a user with an explicit UID/GID and create necessary directories
RUN set -eux; \
    groupadd -r storm --gid=1000; \
    useradd -r -g storm --uid=1000 storm; \
    mkdir -p "$STORM_CONF_DIR" "$STORM_DATA_DIR" "$STORM_LOG_DIR"; \
    chown -R storm:storm "$STORM_CONF_DIR" "$STORM_DATA_DIR" "$STORM_LOG_DIR"``

# Install required packages
RUN set -eux; \
    apt-get update; \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install -y --no-install-recommends \
        bash \
        ca-certificates \
        dirmngr \
        gosu \
        gnupg \
        python \
        procps \
        netcat \
        curl \
        openssh-server \
        jq \
        wget; \
    rm -rf /var/lib/apt/lists/*; \
# Verify that gosu binary works
    gosu nobody true

# Install BOSH Cli
RUN bosh_ver=$(curl -s https://api.github.com/repos/cloudfoundry/bosh-cli/releases/latest | jq -r '.tag_name' | tr -d "v" ) && \
       wget https://github.com/cloudfoundry/bosh-cli/releases/download/v${bosh_ver}/bosh-cli-${bosh_ver}-linux-amd64 \
       -O /usr/local/bin/bosh && chmod a+x /usr/local/bin/bosh

ARG GPG_KEY=5167DE337E7370373499FC1DA4A672F11B5050C8
ARG DISTRO_NAME=apache-storm-2.3.0

# Download Apache Storm, verify its PGP signature, untar and clean up
RUN set -eux; \
    ddist() { \
        local f="$1"; shift; \
        local distFile="$1"; shift; \
        local success=; \
        local distUrl=; \
        for distUrl in \
            'https://www.apache.org/dyn/closer.cgi?action=download&filename=' \
            https://www-us.apache.org/dist/ \
            https://www.apache.org/dist/ \
            https://archive.apache.org/dist/ \
        ; do \
            if wget -q -O "$f" "$distUrl$distFile" && [ -s "$f" ]; then \
                success=1; \
                break; \
            fi; \
        done; \
        [ -n "$success" ]; \
    }; \
    ddist "$DISTRO_NAME.tar.gz" "storm/$DISTRO_NAME/$DISTRO_NAME.tar.gz"; \
    ddist "$DISTRO_NAME.tar.gz.asc" "storm/$DISTRO_NAME/$DISTRO_NAME.tar.gz.asc"; \
    export GNUPGHOME="$(mktemp -d)"; \
    gpg --keyserver keyserver.ubuntu.com --recv-key "$GPG_KEY" || \
    gpg --keyserver ha.pool.sks-keyservers.net --recv-key "$GPG_KEY" || \
    gpg --keyserver pgp.mit.edu --recv-keys "$GPG_KEY" || \
    gpg --keyserver keyserver.pgp.com --recv-keys "$GPG_KEY"; \
    gpg --batch --verify "$DISTRO_NAME.tar.gz.asc" "$DISTRO_NAME.tar.gz"; \
    tar -xzf "$DISTRO_NAME.tar.gz"; \
    rm -rf "$GNUPGHOME" "$DISTRO_NAME.tar.gz" "$DISTRO_NAME.tar.gz.asc"; \
    chown -R storm:storm "$DISTRO_NAME"

WORKDIR $DISTRO_NAME

ENV PATH $PATH:/$DISTRO_NAME/bin:/usr/local/bin

COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]