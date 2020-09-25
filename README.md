# Portal Docker Compose Repo

Dependencies:
[Docker](https://docs.docker.com/)
[Docker Compose](https://docs.docker.com/compose/)
[Docker Hub](https://hub.docker.com/orgs/taccwma/repositories)
[GNU Make](https://www.gnu.org/software/make/)

### Manage/Track Deployments for portal and supporting services

This repo is used to manage and deploy portal and supporting services.
Each environment has a dedicated compose and env file to track image versions.

Setup:
Clone this repo to `/opt/`

At the root of the cloned project create the env file `.env` and add the name of the environment file to be used to manage deployments. The env files are named according the deployment environment they manage, like `dev.env, prod.env`.

Ex. To manage and deploy dev, use the filename `dev.env`, this file will be passed to docker-compose with [`--env-file=./conf/camino/prod.env`](https://docs.docker.com/compose/environment-variables/)

### Deploy a new portal image in dev or prod:

1. Update portal image tag as needed in `./conf/camino/dev.env` or `./conf/camino/dev.env` 
2. SSH to host and switch to portal account, `su - portal`
3. Navigate to camino repo `cd /opt/portal-camino`
4. Update repo with latest changes `git pull`
5. Deploy changes using make, `make deploy service=portal`  this pulls the new image and restarts the service
6. If changes include static content like JS or CSS, run `make collectstatic service=portal`
7. If model changes require database updates, run migrations with `make migrate service=portal`

To back-up the database at any point, run `make dbbackup`, this creates a dbdump of the curren database and stores it in `/var/www/chameleon/dbbackup/`

### Update SSL Certificates and Keys
To update certificates and keys, place the certificate and key in the location indicated in the docker-compose file matching the environment where the cert will be updated
To update production certificates for chameleoncloud.org, the docker-compose.yml shows the files that should be updated below:
```
  nginx:
    image: nginx
    volumes:
      - /etc/ssl/certs/chameleon.bundle.crt:/etc/ssl/certs/portal.cer
      - /etc/ssl/certs/www.chameleoncloud.org.key:/etc/ssl/private/portal.key
```

- Update `/etc/ssl/certs/chameleon.bundle.crt` with the new portal cert and any intermmediate certificates  
- Update `/etc/ssl/certs/www.chameleoncloud.org.key` with the new key
- After updating the certificate and key, restart nginx with `make restart service=nginx`

### Using `make` to manage portal services

restart all services: `make restart`

restart the portal: `make restart service=portal`

pull images for all services: `make pull`

pull images for portal: `make pull service=portal`
<br />
##### Command List

Stops all running containers/services, optional `service={service}`  
``` 
  make stop
```

Starts all containers/services, optional `service={service}`  
This command will fail if container hasn't been created for a service  
```
  make start
 ```

Stops and deletes all containers managed by the compose file, optional `service={service}`  
```
  make down
 ```

Starts services, creates new container if none exists, optional `service={service}`  
```
  make up
```

Pull new service images if available, optional `service={service}`  
```
  make pull
```

Restarts all services, creating new containers as needed, optional `service={service}`  
```
  make restart
```

Pulls new images and restarts services, creating new containers for updated images, optional `service={service}`  
```
  make deploy
```

Runs django migrations in portal  
```
  make migrate service=portal
```

Runs django's collectstatic in portal  
```
  make collectstatic service=portal
```

Makes backup of current database and places it in, `/var/www/chameleon/dbbackup/`  
```
  make dbbackup
```
<br /><br /><br /><br /><br />
  
  
  
  
  
  
_por necesidad o aventura, todo descubrimiento nace con el inicio de un viaje sin fin, el camino hacia la frontera_
