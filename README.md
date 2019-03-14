# Learning Locker version 2 in Docker

It is a dockerized version of Learning Locker (LL) version 2 based on the installation guides at http://docs.learninglocker.net/guides-custom-installation/

It is was forked from https://github.com/michzimny/learninglocker2-docker. In the topic __Why did I forked__ I will explain my motivations

## Architecture

For LL's architecture consult http://docs.learninglocker.net/overview-architecture/

This section is about the architecture coming out of this dockerization.

Official images of Mongo, Redis, and xAPI service are used.
Additionally, build creates two Docker images: nginx and app.
LL application services are to be run on containers based on the app image.

File docker-compose.yml describes the relation between services.
A base configuration consists of 7 containers that are run using the above-mentioned images
(LL application containers - api, ui, and worker - are run using image app).

The origin service ui expects service api to work on localhost,
however in this dockerized version the both services are run in separate containers.
To make connections between those services work, socat process is run within ui container to forward local tcp connections to api container.

## Usage

### Development

* open a terminal session (Terminal, iTerm, etc)
* go to the project (`cd learninglocker2-docker`)
* type the command `make run`. In the first time, this command will take to long time (download images, mount volumes, etc).
* If all goes to plan, you will see it in terminal session:
    ```
    ui_1      |  ---
    ui_1      |  ==> ✅  Learning Locker is running, talking to API server on 8080.
    ui_1      |  ==> 💻  Open http://localhost in a browser to view the app.
    ui_1      |  ---
    ui_1      |
    ```
* open your browser and type http://localhost. The Learning locker login page should appears.
* open a new terminal session
* go to the project
* type de command `make add-admin`. This command will create a user with login `admin@test.com`, password `lrs123` and organization `MyOrganization`

When you finish to work, press CTRL+C to closse container session and type `make down`

### Production

There are two possible ways to do it:
* __you have a docker swarm or k8 in your infra__
In this case, you or your DevOps expertise should be using Traeffic or Aws Route 53 to handle request, so you don't need to use `nginx` container. You/DevOps expertise will use the docker-compose.yml as a reference to create a docker-stack.yml/podfile. Moreover, probraly you will edit `.env` file to use Mongodb and Redis as SaaS and to configure AWS S3, CloudWatch, SQS.

    It is all just a hint of what the infra configuration should look like. You are free to setup it as you want

* __you have a standalone machine somewhere__
Preparing a remote machine for the first time, put all project files in this machine and run the command `docker-compose up -d`

In both scenarios, before start up the project, YOU HAVE TO edit `.env` file and set DOCKER_TAG to the last git commit (SHA-1) to make sure you are versioning your image.

### SSL/TLS certs

In the https://github.com/michzimny/learninglocker2-docker version there are instruction to set SSL. IMPORTANT: you have to copy nginx.conf.template from https://github.com/michzimny/learninglocker2-docker to nginx works fine with https

### Backups

https://blog.ssdnodes.com/blog/docker-backup-volumes/

## Upgrading

In app/Dockerfile, git tag of LL application is declared.
In docker-compose.yml, image tag of xAPI service is declared.
The versions (tags) in use can be easily adjusted as needed.

After upgrading these versions, you shall usually proceed as follows:

```
make down
make run
```

Open a new terminal session, go to the project and type `docker-compose exec api yarn migrate`

## Destroying
to remove all project data, image and volumes, open a terminal session, go to the project folder and type de command `make destroy`

## Why did I forked it?
* I had to adjust to my infra (aws)
* To use env variables in many situations to avoid to rebuild images
* simply the start up in local mode (in my opinion)
