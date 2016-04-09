# Dockerized Apache Storm

[Apache Storm](http://storm.apache.org/) is a free and open source distributed realtime computation system.

## Setting up a Storm Cluster

1. Start Zookeeper

    $ docker run -d --name zookeeper mesoscloud/zookeeper

2. Start Nimbus

    $ docker run -d --name nimbus --net container:zookeeper storm nimbus

3. Start Supervisor

    $ docker run -d --name supervisor --net container:nimbus storm supervisor

## Running Topologies

    $ docker run -it --net container:nimbus -v $(pwd)/storm-starter-topologies-0.10.0.jar:/topology.jar storm jar /topology.jar storm.starter.WordCountTopology topology
