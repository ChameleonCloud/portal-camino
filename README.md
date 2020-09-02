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

Ex. To manage and deploy dev, use the filename `dev.env`, this file will be passed to docker-compose with [`--env-file=./conf/camino/dev.env`](https://docs.docker.com/compose/environment-variables/)

To update a service, check in the new image tag, or use latest automatically pull in latest changes.

Manage deployments and other compose actions with make like,

restart all services: `make restart`

restart the portal: `make restart service=portal`

pull images for all services: `make pull`

pull images for portal: `make pull service=portal`







_por necesidad o aventura, todo descubrimiento nace con el inicio de un viaje sin fin, el camino hacia la frontera_