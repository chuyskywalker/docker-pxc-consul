# Percona Xtradb Cluster & Consul Service Discovery

This example will:

1. Build a consul master, a demo application, and as many PXC nodes as you'd like
1. Utilize service discovery "sidecars" to integrate the PXC nodes into Consul (this keeping a clean separation of a "pure" PXC container)
1. Utilize the service discovery DNS system too:
   1. Pull nodes into the cluster (after the 1st starts)
   1. Randomly query mysql servers from the application

## Consul

https://www.consul.io/

An opinonated distributed application for service discover, health checks, and K/V store. We're going to use it to coordinate discovery or peer Percona nodes as well as locating random targets within the percona cluster for the application.

## PXC (Percona Xtradb Cluster)

https://www.percona.com/software/mysql-database/percona-xtradb-cluster

A derivative MySQL with many performance enhancements that integrates Galera for multi-master, synchronous replication. Meaning: read/write to any node with ACID guarantees.

## Rough overview

Get everything built with `01-build-all.sh`. Feel free to inspect the Dockerfiles, everything is _relatively_ straight forward, but some quirks are noted in the `Dockerfile`s and `start.sh`s as needed.

Next, run `02-start-consul.sh` to get our service discover, health check system up and running. This will also provide a web ui which can be accessed by browsing to the IP for you host at port `8501`, for example `http://192.168.1.50:8501/`.

Now, let's get the app up with `03-start-app.sh`. The app is a really, really simple [reactphp](http://reactphp.org/) app because it requires very little to implement (and because I know PHP best and could bang it out). Once started, you can visit that application at port `32875`.

At this point, the app will be quite empty. No servers, no DNS records, can't connect to mysql. Well, yeah, we haven't started any nodes yet!

So, run `04-start-pxcnode.sh 1`. Note the `1` there, it's important -- you're starting the first node. You can check out consul or the application and `F5` bomb your keyboard to watch for it to come up. It's usually pretty quick though, so you might miss it.

Now for the real fun! `04-start-pxcnode.sh 2` -- that'll start a second node, which will discover the first node (thanks consul!) and join the cluster. Then, as it automatically grabs all the latest data, once it's done the health check will go green (consul again) and the app will start seeing it as a viable, randomly discovered host for mysql connections.

You can continue adding nodes as you wish and watch as they all come up and spread the read/write load further.
