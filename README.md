# Dockerized Apache Storm

[Apache Storm](http://storm.apache.org/) is a free and open source distributed realtime computation system.

## Setting up a Storm Cluster

1. Start Zookeeper

        $ docker run -d --name zookeeper jplock/zookeeper:3.4.8

2. Start Nimbus

        $ docker run -d --name nimbus --net container:zookeeper 31z4/storm:1.0.0 nimbus

3. Start Supervisor

        $ docker run -d --name supervisor --net container:nimbus 31z4/storm::1.0.0 supervisor

## Running Topologies

    $ docker run -it --net container:nimbus -v $(pwd)/storm-starter-topologies-1.0.0.jar:/topology.jar storm jar /topology.jar storm.starter.WordCountTopology topology
