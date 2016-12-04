# Workshop Guide: Docker Multi Host
## Background Knowledge Required / Suggested
* WebLogic Architecture
* WebLogic Scripting Tool (WLST)
* Linux

## Feature Overview

Docker is a platform that enables users to build, package, ship and run distributed applications. Docker users package up their applications, and any dependent libraries or files, into a Docker image. Docker images are portable artifacts that can be distributed across Linux environments. Images that have been distributed can be used to instantiate containers where applications can run in isolation from other applications running in other containers on the same host operating system. Docker 1.9 introduced the overlay network, this provides the ability to network together containers running in different hosts or VM.

## Workshop Overview

As part of the Docker Multi-Host Workshop, in this document you will see how to create a WebLogic domain with servers running in Docker containers distributed in different VMs.  In this Docker environment the WebLogic servers running in the cluster have all the HA properties of a WebLogic Server cluster like session replication, singleton service migration to name two. We will create two Docker images using the WebLogic install image and WebLogic domain image created in the previous workshop. We will use a couple of custom Dockerfiles, the WebLogic domain image will be extended to create an application image. We will use some Docker tools to help us in the creation of this environment Docker Machine, Docker Swarm, Consul, Docker Overlay Network, and Registry. The Docker Machine will start a Virtual Box with the Docker Engine running inside. Every Docker Machine will participate in a Docker Swarm cluster which are all networked with the Docker Overlay network.  The Registry allows us to push our images and then very easily from outside the VM using scripts run containers from these images. All this will be achieved using custom scripts and Dockerfiles.   

### Requirements / Prerequisites
* Computer with 8GB RAM and 2-4 cores
* VirtualBox 4.2.4+
* Linux VM with Docker 1.9+ and Git installed

### Tips
* Allocate at least 4GB RAM to the VM, if not more
* Allocate at least 2 cores to the VM, if not more

## Steps
### Get Oracle Docker Images
This lab document assumes you have created the WebLogic 12.2.1 Install image and the WebLogic Domain Image as described in the workshop. Feel free to use any location you prefer.

    $ git clone --depth=1 https://github.com/oracle/docker-images.git 

#### WebLogic Install image and WebLogic Domain image
You should have 3 images already running in your machine the Oracle Linux Image, WebLogic Install image, and the WebLogic Domain image.  These images have been created following the instructions from the workshop.

We now have a new image **oracle/serverjre:8**, this image is built by extending the Oracle Linux image.  The WebLogic install image will extend the **oracle/serverjre:8**.

![](images/02_oracle_jdk_buildimage.png)

To see the base images used in this workshop run the command,

    $ docker images

![](images/03_WLS_images.png)    


### Dockerfiles
Under the **samples** directory we have subdirectories that contain Dockerfiles that serve as examples to build WebLogic Domain images, WebLogic Application Images, Apache Webtier Images, and scripts to build a WebLogic Domain in a multi host environment.

![](images/05_samples_dir_ls.png)

This project offers a couple of Dockerfiles to create the Application image. The Application image **1221-appdeploy** extends a WebLogic Domain image to deploy the application **sample** to servers running in a WebLogic 12.2.1 domain. This Dockerfile can be easily change to extend a WebLogic 12.1.3 Domain image. 

### Application Images
To give users an idea on how to create the Application images from a custom Dockerfile to extend the WebLogic Domain image, we provide samples under the folder '~/docker-images/OracleWebLogic/samples/1221-appdeploy'.  The best way to create your own, or extend domains is by using WebLogic Scripting Tool. The WLST script used to deploy the **sample** application and create the **1221-appdeploy** image is '~/docker-images/OracleWebLogic/samples/1221-appdeploy/container-scripts/app-deploy.py'. This script by default deploys the sample application to all servers in the domain. You can deploy your own applications by modifying the WLST scripts, or create a new one with WLST.

To try building the WebLogic **appdeploy** Application image:

    $ cd ~/docker-images/OracleWebLogic/samples/1221-appdeploy
    $ docker build -t 1221-appdeploy .

Like before, you can open the Dockerfile in another terminal window to see the definition of the build steps Docker is running.

![](images/04_appdeploy.png)

In steps 1 through 4 above, we extend the **1221-domain** image, define application name, name of the war file, and location where it should be copied. 
Like before, you can open the Dockerfile in another terminal window to see the definition of the build steps Docker is running.

### Apache Plugin Web Tier Images
The Apache Plugin will provide us the ability to load balance traffic to WebLogic Managed servers in a WebLogic cluster.  Each Managed server is running in its own Docker container, the Apache Plugin Web tier is also running inside of its own Docker container.  In this project we take advantage of the Apache Plugin Web tier to load balance traffic to Managed servers running in containers in a multi host environment.

To give users an idea on how to create the Apache Plugin Web tier images from a custom Dockerfile, we provide samples under the folder '~/docker-images/OracleWebLogic/samples/1221-webtier-apache'.  The best way to create your own, is edit the Dockerfile and the weblogic.conf file to fit your environment.  
In the Dockerfile we extend the **httpd:2.4** image, and install the Apache Plugin. To try building the WebLogic **webtier** image:

    $ cd ~/docker-images/OracleWebLogic/samples/1221-webtier-apache
    $ docker build -t webtier .

Like before, you can open the Dockerfile in another terminal window to see the definition of the build steps Docker is running.

![](images/06_webtier_image.png)
 
The image is successfully built, belonging to the repository **webtier**, and tag **latest**.  When the image is created, it will be reflected when we do a `docker images`

![](images/07_all_images.png)

### Building WebLogic Multi Host Environment
To make it easy to build a multi host environment we take advantage of the following tools Docker Machine, Docker Swarm, Docker Overlay Network, Docker Compose, Docker Registry, and Consul.

**Docker Machine**: Docker Machine is a tool that lets you install Docker Engine on virtual hosts, and manage the hosts with docker-machine commands.

**Docker Swarm**: Docker Swarm is native clustering for Docker. It turns a pool of Docker hosts into a single, virtual Docker host. Because Docker Swarm serves the standard Docker API, any tool that already communicates with a Docker daemon can use Swarm to transparently scale to multiple hosts. 

**Docker Overlay Network**: Dockers Overlay network driver supports multi-host networking natively out-of-the-box, while still providing better container isolation.

**Docker Compose**: Compose is a tool for defining and running multi-container Docker applications. With Compose, you use a Compose file to configure your application services. Then, using a single command, you create and start all the services from your configuration.

**Docker Registry**: The Registry is a stateless, highly scalable server side application that stores and lets you distribute Docker images.

**Consul**: Consul makes it simple for services to register themselves and to discover other services via a DNS or HTTP interface.

To give users an idea on how to create a WebLogic Server Domain in a Multi Host environment we have scripts under '~/docker-images/OracleWebLogic/samples/1221-multihost' directory.  The **bootstrap.sh** script starts 2 Docker Machines the **weblogic-orchestrator** and **weblogic-master** . The **weblogic-orchestrator** Docker Machine has the **Docker Registry** running, where we register the images we need to run containers from, and the **Consul** to help us start services. The **weblogic-master** Docker Machine has the **Docker Swarm, the Overlay Network, and the WebLogic Admin Server container** running in the VM. 
After starting the two Docker machines, the **1221-appdeploy** image is pushed into the registry running in the **weblogic-orchestrator** machine.  Finally the bootstrap script calls post-bootstrap script.

![](images/09_bootstrap_vi.png)

The '~/docker-images/OracleWebLogic/samples/1221-multihost/post-bootstrap.sh' script runs an Admin server Docker Container in the weblogic-master machine from the **app-deploy** image that has been pushed to the registry.

![](images/10_post_bootstrap_vi.png)

After running the bootstrap.sh script successfully, we can see the two Docker machines running  using the `docker-machine ls` command.

![](images/11_docker_machine_after_bootstrap.png)

If we ssh into the weblogic-orchestrator machine by running `docker-machine ssh weblogic-orchestrator` command we can see the registry, consul images, and containers running in this machine.  Use the commands `docker images` to see images and `docker ps` to see containers.

![](images/12_orchestrator.png)


If we ssh into the weblogic-master machine by running `docker-machine ssh weblogic-master` command and do `docker ps` we see the Admin server container running and the swarm.

![](images/13_master.png)

Every virtual machine that is part of the Docker Swarm will be networked together with the **Overlay network**.  Every container running in the VM will be able to communicate with any other container running in a different VM in the Docker Swarm.  This allows us to run the WebLogic servers in many different VMs and distribute the WLS domain or cluster across several VMs.  Let's take a look at the Docker networks and we can inspect the **Overlay network** by running `docker inspect` using the overlay network name.  Run commands:

    $ docker network ld
    $ docker network inspect weblogic-net 
   
![](images/14_network_inspect.png)

Open the Admin Console by using the ip address of the weblogic-master machine and port 8001, http://192.168.99.101:8001/consolee.  View the Admin server running, and the deployed **sample** application.

![](images/15_console_login.png)
![](images/16_console_admin_server.png)
![](images/17_console_deployment.png)

Next we will start a new VM where the managed servers will run. Simply call the '~/docker-images/OracleWebLogic/samples/1221-multihost/create-machine.sh' script. This script will create a new Docker machine, in this project we will run two WebLogic Managed servers.  The new Docker machine will be part of the Docker Swarm and the Managed server containers running in this VM will be able to network via the Overlay network with other containers in the Swarm.  After running the **create-machine.sh** script we see the Docker Machines running by invoking `docker-machine ls`, we can see a third Docker Machine **weblogic-gv082o**.

![](images/18_create_machine.png)

Now that the machine is up, we will start Managed Server containers from the app-deploy image.  Invoke '~/docker-images/OracleWebLogic/samples/1221-multihost/create-container.sh' script. If you want the Managed server container to be started in a particular Docker machine provide the machine name as parameter `./create-container.sh weblogic-gv082o`, otherwise the container will be started in any of the Docker Machines in the Swarm.

![](images/19_create_container.png)

![](images/21_start_managed_servers.png)


Look at the Managed server container running on Docker Machine weblogic-gv082o, ssh onto the machine `docker-machine ssh weblogic-gv082o` and do `docker ps` to see the containers running on the machine.

![](images/20_ms_containers.png)

The entire WebLogic domain has been started and the **sample** application is deployed to the cluster. We will start the **Apache Plugin Web tier** running in its own container.  The Apache Plugin will load balance invocations to the **sample** application across Managed servers in the cluster. 
The '~/docker-images/OracleWebLogic/samples/1221-multihost/start-webtier.sh' script discovers all Managed servers running in the Swarm, creates the string WEBLOGIC_CLUSTER, pushes the **webtier** image to the registry, and starts a webtier container on the **weblogic-master** machine.  The WEBLOGIC_CLUSTER string is set as an environment parameter, when starting the Apache Web tier container the value is set in the **weblogic.conf** file.  Also note that the Apache Web tier container is bound to port 80 of the **weblogic-master** machine.

![](images/22_start_webtier.png)
![](images/23_start_webtier2.png)

After invoking the script '~/docker-images/OracleWebLogic/samples/1221-multihoststart-webtier.sh', find the **Apache Web tier** container running in the **weblogic-master** machine.

![](images/24_start_webtier_running.png)

Go into **weblogic-master** machine `docker-machine ssh weblogic-master` and run `docker ps`, see the newly created **Apache Web tier** container running.

![](images/25_webtier_container_onmaster.png)

Call the sample application deployed to the WebLogic cluster via the **Apache Web tier**, in your browser use the ip address of the **weblogic-master** machine and port 80, http://192.168.99.101:80/sample.

![](images/26_call_sample.png)

### Clean Up
Clean Docker Machines running, call script '~/docker-images/OracleWebLogic/samples/1221-multihost/destroy-all-machines.sh'

    $ ./destroy-all-machines.sh

Verify the Docker images that exist currently:  

    $ docker images

 
Use the `docker rmi` command to delete each of these Docker images

    $ docker rmi <IMAGE ID>

### More Information
* [New WebLogic Server Running on Docker in Multi-Host Environments ](https://blogs.oracle.com/WebLogicServer/entry/new)

* [White Paper - Oracle  WebLogic Server on Docker Containers](http://www.oracle.com/technetwork/middleware/weblogic/overview/weblogic-server-docker-containers-2491959.pdf)

* [Docker on Oracle Linux](https://docs.docker.com/engine/installation/linux/oracle/)

