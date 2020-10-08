# Portal Docker Compose Repo

Dependencies:

- [Docker](https://docs.docker.com/)
- [Docker Compose](https://docs.docker.com/compose/)
- [Docker Hub](https://hub.docker.com/orgs/chameleoncloud/repositories)
- [GNU Make](https://www.gnu.org/software/make/)

### Manage/Track Deployments for portal and supporting services

This repo is used to manage and deploy portal and supporting services.
Each environment has a dedicated compose and env file to track image versions.

Setup:
Clone this repo to `/opt/`

At the root of the cloned project create the env file `.env` and add the name of the environment file to be used to manage deployments. The env files are named according the deployment environment they manage, like `dev.env, prod.env`.

Ex. To manage and deploy dev, use the filename `dev.env`, this file will be passed to docker-compose with [`--env-file=./conf/camino/dev.env`](https://docs.docker.com/compose/environment-variables/)

### Deploy a new portal image in dev or prod:

1. Update portal image tag as needed in `./conf/camino/dev.env` or `./conf/camino/prod.env`
2. SSH to host and switch to portal account, `su - portal`
3. Navigate to camino repo `cd /opt/portal-camino`
4. Update repo with latest changes `git pull`
5. Deploy changes using make: `make portal-deploy`. This pulls the new image and restarts the service, then additionally runs DB migrations and re-collects static assets.

To back-up the database at any point, run `make dbbackup`, this creates a dbdump of the curren database and stores it in `DB_BACKUP_PATH`, defaulting to `/var/www/chameleon/dbbackup/`.

### Update SSL Certificates and Keys

To update certificates and keys, place the certificate and key in the location indicated in the docker-compose file matching the environment where the cert will be updated
To update production certificates for chameleoncloud.org, the docker-compose.yml shows the files that should be updated below:

```yaml
  nginx:
    image: nginx
    volumes:
      - /etc/ssl/certs/chameleon.bundle.crt:/etc/ssl/certs/portal.cer
      - /etc/ssl/certs/www.chameleoncloud.org.key:/etc/ssl/private/portal.key
```

- Update `/etc/ssl/certs/chameleon.bundle.crt` with the new portal cert and any intermmediate certificates
- Update `/etc/ssl/certs/www.chameleoncloud.org.key` with the new key
- After updating the certificate and key, restart nginx with `make restart service=nginx`

### Using `make` to manage individual services

Most docker-compose commands are exposed as Make targets:

```shell
# Restart all services
make restart
# Or, just restart two services
make restart service="portal celery"
# Pull image for nginx
make pull service="nginx"
# Tear down all servies
make down
# Bring up all services
make up
# Bring up just two services
make up service="portal celery"
```

To see all supported operations, invoke `make` without any args, or specify
`make help`.

<br /><br /><br /><br /><br />
_por necesidad o aventura, todo descubrimiento nace con el inicio de un viaje sin fin, el camino hacia la frontera_
