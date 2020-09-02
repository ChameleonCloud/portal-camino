#!make
ENV_FILE ?= ./conf/camino/$(shell cat .env)
include $(ENV_FILE)
DOCKER_COMPOSE :=  docker-compose -f $(COMPOSE_FILE) --env-file=$(ENV_FILE)

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
	$(DOCKER_COMPOSE) exec $(service) python manage.py migrate

.PHONY: collectstatic
collectstatic:
	$(DOCKER_COMPOSE) exec $(service) python manage.py collectstatic --noinput