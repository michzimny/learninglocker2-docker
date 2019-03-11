# Learning Locker version 2 in Docker

It is a dockerized version of Learning Locker (LL) version 2 based on the installation guides at http://docs.learninglocker.net/guides-custom-installation/

## Architecture

For LL's architecture consult http://docs.learninglocker.net/overview-architecture/

This section is about the architecture coming out of this dockerization.

Official images of Mongo, Redis, and xAPI service are used.
Additionally, build creates two Docker images: nginx and app. 
LL application services are to be run on containers based on the app image. 

File docker-compose.yml describes the relation between services. 
A base configuration consists of 7 containers that are run using the above-mentioned images 
(LL application containers - api, ui, and worker - are run using image app).

The only persistent locations are directories in $DATA_LOCATION (see below), 
which are mounted as volumes to Mongo container and app-based containers.

The origin service ui expects service api to work on localhost, 
however in this dockerized version the both services are run in separate containers. 
To make connections between those services work, socat process is run within ui container to forward local tcp connections to api container.

## Usage

To build the images:

```
./build-dev.sh
```

To configure adjust settings in .env:

* DOCKER_TAG - git commit (SHA-1) to be used ("dev" for images built by build-dev.sh)
* DATA_LOCATION - location on Docker host where volumes are created
* DOMAIN_NAME - domain name as the instance is to be accessed from the world
* APP_SECRET - LL's origin setting: Unique string used for hashing, Recommended length - 256 bits
* SMTP_* - SMTP connection settings (for TLS config, see [here](https://nodemailer.com/smtp/#tls-options))

To run the services:

```
docker-compose up
```

Open the site and accept non-trusted SSL/TLS certs (see below for trusted certs).

To create a new user and organisation for the site:

```
docker-compose exec api node cli/dist/server createSiteAdmin [email] [organisation] [password]
```

## Production usage

### Deployment

Preparing a remote machine for the first time, put .env file to the machine and adjust the settings as given above.

To deploy a new version (git commit) to the machine, 
set DOCKER_TAG in .env to the git commit (SHA-1),
copy docker-compose.yml of the git commit to the machine 
(see the SSL/TLS notice below),
and just call the command:

```
docker-compose up -d
```

### SSL/TLS certs

Mount cert files to nginx container adding a section in docker-compose.yml:

```
     volumes:
        - "/path-to-certs-on-docker-host/fullchain.pem:/root/ssl/fullchain.pem:ro"
        - "/path-to-certs-on-docker-host/privkey.pem:/root/ssl/privkey.pem:ro"
```

### Backups

Backup $DATA_LOCATION, i.e. the Docker volumes: Mongo's data and app's storage. 

## Upgrading

In app/Dockerfile, git tag of LL application is declared.
In docker-compose.yml, image tag of xAPI service is declared.
The versions (tags) in use can be easily adjusted as needed.

After upgrading these versions, you shall usually proceed as follows:

```
docker-compose pull
docker-compose stop xapi worker ui api nginx
docker-compose run --rm api yarn migrate
docker-compose up
```

