# Kubernetes Outline

> This is a very short outline of Kubernetes and container orchestration. To be updated.

***

## Table of Content

* [Container Orchestration](#container-orchestration)
* [What is Kubernetes](#what-is-kubernetes)
* [Terms](#terms)
* [Kubernetes Components](#kubernetes-components)
* [Master vs Worker Nodes](#master-vs-worker-nodes)
* [Commands](#commands)
* [Resources](#resources)

***

## Container Orchestration

If you have a docker host running multiple containers and there are more users coming to your server and you want to scale up more containers, you need to add more docker hosts and deploy containers to manage higher load.  
If one of the containers went faulty, who will replace this container with new container!  
If entire node went down, how the containers move to the other available nodes!  
If you need to deploy new container to all docker hosts, who will take care of that!

The one who can manage all of these activity we call container orchestrator.

Container Orchestration service providers:

* [Docker Swarm](./docker-outline.md)
* Kubernetes
* [OpenShift](./openshift-outline.md)
* Nomad

Kubernetes can do:

* Deployment (Deploy containers on multiple docker hosts)
* Scaling (Create more containers to handle the load)
* Monitoring (In case of any failures occur on docker containers)

***

## What is Kubernetes

Kubernetes is an open-source **container orchestration tool** responsible for automating deployment, scaling, and management of containerized applications. It was originally designed by Google and is now maintained by the Cloud Native Computing Foundation.

You can get Kubernetes on-premises or on cloud platforms google, azure or aws.

From feature perspective, it's one of the most extensive platforms. It does stateless, stateful, batch work, long running, security, storage, networking, serverless, function as a service, machine learning, there's a lot. It can do all of that on cloud or on-premises or even on your laptop.

k8s: 8 is the replacement of in-between 8 characters.

Unlike docker, Kubernetes doesn't care about low level stuff like docker stop, start or delete. It cares about high level stuff, scheduling, scaling, healing, updating...

It's issuing commands to docker telling when to stop containers and how to run them...

Each node contains _Docker runtime_ and _k8s Agent_ and there is one k8s control plane to control the nodes.

When you build your application on top of k8s, and you use cloud infrastructure, it's easy to migrate from one cloud provider to another unless your apps is tightly coupled with the cloud provider.

* k8s on cloud:
  * AWS EKS
  * Azure AKS
  * Google GKE
  * or build you own
* k8s on-premises
  * build you own

***

## Terms

* **Nodes** (Minions): is a machine, virtual or physical where kubernetes is installed. It's a worker machine and it's where kubernetes will run docker containers.
* **Cluster**: Set of nodes grouped together. What if one node failed, so your applications will be down. If your node fails, your application still accessible from other nodes. Multiple nodes help in sharing loads as well.
* **Master**: another node with kubernetes installed on it and configured as a master. Master watches the nodes and is responsible for container orchestration.

***

## Kubernetes Components

* API server. (Act as frontend for kubernetes. Users and CLIs talks to API server)
* etcd. (Distributed key-value store to store all data required to manage the cluster)
* Kubelet. (The agent that runs on each node in the cluster. It makes sure the containers running on its node as expected)
* Container Runtime. (Underlying software that is used to run containers, in our case it's docker. There's other runtimes like rkt and CRI-O)
* Controller. (The brain behind orchestration. Noticing when endpoints or node goes down. Take decision to bring up new containers in such cases)
* Schedular. (Distributing work of containers across multiple nodes)

***

## Master vs Worker Nodes

* Master has `kube-apiserver`.
* Master has `etcd`.
* Master has `controller`.
* Master has `schedular`.
* Node has `kubelet` agent.
* Node has `container runtime`. In our case `docker`.

***

## Commands

`kubectl` abbreviation for Kube Control.

* `minikube status` check status of kubernetes.
* `kubectl apply -f deployment.yml`
* `kubectl apply -f service.yml`
* `kubectl apply -f ingress.yml`
* `kubectl get pods`
* `kubectl get service`
* `kubectl get ingress`
* If you change number of replicas in `deployment.yml` to 5 and run `kubectl apply -f deployment.yml` it will increase the number of service automatically. If you stop one service `kubectl delete pod xyz111` you will still see 5 services is running, run `kubectl get pods` to check.
* Rolling updates: Now if you need to update your application version from v1 to v2, just update the docker image, run `kubectl apply -f deployment.yml` then kubernetes will role the update one node per time until all nodes are updated.

Other Commands:

* `kubectl run hello-minikube` deploy an application in the cluster.
* `kubectl cluster-info` view information of the cluster.
* `kubectl get nodes` list all the nodes out of the cluster.

***

## Resources

* [Play with Docker](https://play-with-docker.com)
* [Play with k8s](https://play-with-k8s.com)
