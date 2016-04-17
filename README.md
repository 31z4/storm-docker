# Supported tags and respective `Dockerfile` links

* `0.9.6` [(0.9.6/Dockerfile)](https://github.com/31z4/storm-docker/blob/master/0.9.6/Dockerfile)
* `0.10.0` [(0.10.0/Dockerfile)](https://github.com/31z4/storm-docker/blob/master/0.10.0/Dockerfile)
* `1.0.0`, `latest` [(1.0.0/Dockerfile)](https://github.com/31z4/storm-docker/blob/master/1.0.0/Dockerfile)

[![](https://badge.imagelayers.io/31z4/storm:latest.svg)](https://imagelayers.io/?images=31z4%2Fstorm:0.9.6,31z4%2Fstorm:0.10.0,31z4%2Fstorm:1.0.0)

# What is Apache Storm?

[Apache Storm](http://storm.apache.org/) is a free and open source distributed realtime computation system.

> [wikipedia.org/wiki/Storm_(event_processor)](https://en.wikipedia.org/wiki/Storm_(event_processor))

![](https://upload.wikimedia.org/wikipedia/commons/7/70/Storm_logo.png)

# How to use this image

## Setting up a Storm Cluster

1. Start Zookeeper

        $ docker run -d --name zookeeper jplock/zookeeper:3.4.8

2. Start Nimbus

        $ docker run -d --name nimbus --net container:zookeeper 31z4/storm:1.0.0 nimbus

3. Start Supervisor

        $ docker run -d --name supervisor --net container:nimbus 31z4/storm:1.0.0 supervisor

## Running Topologies

    $ docker run -it --net container:nimbus -v $(pwd)/storm-starter-topologies-1.0.0.jar:/topology.jar storm:1.0.0 jar /topology.jar org.apache.storm.starter.WordCountTopology topology

# License

View [license information](http://storm.apache.org/about/free-and-open-source.html) for the software contained in this image.
