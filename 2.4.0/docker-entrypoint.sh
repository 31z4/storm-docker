#!/bin/bash

set -e

# Allow the container to be started with `--user`
if [ "$1" = 'storm' -a "$(id -u)" = '0' ]; then
    chown -R storm:storm "$STORM_CONF_DIR" "$STORM_DATA_DIR" "$STORM_LOG_DIR"
    exec gosu storm "$0" "$@"
fi

# Generate the config only if it doesn't exist
CONFIG="$STORM_CONF_DIR/storm.yaml"
if [ ! -f "$CONFIG" ]; then
    cat << EOF > "$CONFIG"
storm.zookeeper.servers: [zookeeper]
nimbus.seeds: [nimbus]
storm.log.dir: "$STORM_LOG_DIR"
storm.local.dir: "$STORM_DATA_DIR"
# This is a workaround to make storm workers run in jdk-11 and above.
# It should be removed once the fix is included into the storm distribution.
# See more details at https://github.com/apache/storm/pull/3503 and https://github.com/31z4/storm-docker/issues/39
worker.childopts: "-Xmx%HEAP-MEM%m -XX:+IgnoreUnrecognizedVMOptions -XX:+PrintGCDetails -Xloggc:artifacts/gc.log -XX:+PrintGCDateStamps -XX:+PrintGCTimeStamps -XX:+UseGCLogFileRotation -XX:NumberOfGCLogFiles=10 -XX:GCLogFileSize=1M -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=artifacts/heapdump"
EOF
fi

exec "$@"
