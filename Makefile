#!make
CHAMELEON_ENV ?= ./conf/portal/.chameleon_env
COMPOSE_ENV ?= ./conf/camino/$(shell cat .env)
include $(CHAMELEON_ENV) $(COMPOSE_ENV)
DOCKER_COMPOSE :=  docker-compose -f $(COMPOSE_FILE) --env-file=$(COMPOSE_ENV)
DB_BACKUP_FILE := /var/www/chameleon/dbbackup/chameleon-$(shell date --iso=seconds).mysql

.PHONY: stop
stop:
	$(DOCKER_COMPOSE) stop $(service)
.PHONY: start
start:
	$(DOCKER_COMPOSE) start $(service)

.PHONY: down
down:
	$(DOCKER_COMPOSE) down $(service)

.PHONY: up
up:
	$(DOCKER_COMPOSE) up -d $(service)

.PHONY: pull
pull:
	$(DOCKER_COMPOSE) pull $(service)

.PHONY: restart
restart:
	$(DOCKER_COMPOSE) stop $(service)
	$(DOCKER_COMPOSE) up -d $(service)
	$(DOCKER_COMPOSE) restart nginx

.PHONY: deploy
deploy:
	$(DOCKER_COMPOSE) pull $(service)
	$(DOCKER_COMPOSE) stop $(service)
	$(DOCKER_COMPOSE) up -d $(service)
	$(DOCKER_COMPOSE) restart nginx

.PHONY: migrate
migrate:
	docker run --rm -it --net=$(DOCKER_NETWORK) \
		--env-file=conf/portal/.chameleon_env $(PORTAL_TAG) \
		python manage.py migrate

.PHONY: collectstatic
collectstatic:
	$(DOCKER_COMPOSE) exec $(service) python manage.py collectstatic --noinput

.PHONY: dbbackup
dbbackup:
	mysqldump -u $(DB_USER) -h $(DB_HOST) $(DB_NAME) --password="$(DB_PASSWORD)" > $(DB_BACKUP_FILE)
