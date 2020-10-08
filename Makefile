#!make
CHAMELEON_ENV ?= ./conf/portal/.chameleon_env
COMPOSE_ENV ?= ./conf/camino/$(shell cat .env)
include $(CHAMELEON_ENV) $(COMPOSE_ENV)
DOCKER_COMPOSE :=  docker-compose -f $(COMPOSE_FILE) --env-file=$(COMPOSE_ENV)
DB_BACKUP_PATH ?= /var/www/chameleon/dbbackup
DB_BACKUP_FILE = $(DB_BACKUP_PATH)/chameleon-$(shell date --iso=seconds).mysql

.DEFAULT_GOAL := help
.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| sort \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: stop
stop: ## Stop the service(s) specified by `service` var (default all).
	$(DOCKER_COMPOSE) stop $(service)

.PHONY: start
start: ## Start the service(s) specified by `service` var (default all).
	$(DOCKER_COMPOSE) start $(service)

.PHONY: down
down: ## Tear down the service(s) specified by `service` var (default all).
	$(DOCKER_COMPOSE) down $(service)

.PHONY: up
up: ## Bring up the service(s) specified by `service` var (default all).
	$(DOCKER_COMPOSE) up -d $(service)

.PHONY: pull
pull: ## Pull images for the service(s) specified by `service` var (default all).
	$(DOCKER_COMPOSE) pull $(service)

.PHONY: restart
restart: ## Restart the service(s) specified by `service` var (default all).
	$(DOCKER_COMPOSE) restart $(service)

.PHONY: deploy
deploy: ## Pull images and recreate the service(s) specified by `service` var (default all).
	$(DOCKER_COMPOSE) pull $(service)
	$(DOCKER_COMPOSE) up -d $(service)

.PHONY: portal-deploy
portal-deploy: ## Performs a full portal deploy, including the celery service. Includes DB migrations and static file collection post-deploy.
	$(DOCKER_COMPOSE) pull portal celery
	$(DOCKER_COMPOSE) up -d portal celery
	# TODO: not sure why this is really necessary.
	$(DOCKER_COMPOSE) restart nginx
	$(DOCKER_COMPOSE) exec portal python manage.py migrate
	$(DOCKER_COMPOSE) exec portal python manage.py collectstatic --noinput

.PHONY: migrate
portal-migrate: ## Run DB migrations on the portal service.
	$(DOCKER_COMPOSE) exec portal python manage.py migrate

.PHONY: collectstatic
portal-collectstatic: ## Collect static assets for the portal service.
	$(DOCKER_COMPOSE) exec portal python manage.py collectstatic --noinput

.PHONY: dbbackup
dbbackup: ## Create a new DB dump to `DB_BACKUP_PATH`.
	mysqldump -u $(DB_USER) -h $(DB_HOST) $(DB_NAME) --password="$(DB_PASSWORD)" > $(DB_BACKUP_FILE)
