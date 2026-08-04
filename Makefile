.PHONY: up down infra monitoring data apps homepage caddy portainer

up: 
	./compose/scripts/up.sh

down:
	./compose/scripts/down.sh

stop:
	./compose/scripts/stop.sh

infra:
	./compose/scripts/up.sh infrastructure

monitoring:
	./compose/scripts/up.sh monitoring

data:
	./compose/scripts/up.sh data

apps:
	./compose/scripts/up.sh applications

homepage:
	docker compose -f compose/infrastructure/homepage/docker-compose.yml up -d

caddy:
	docker compose -f compose/infrastructure/caddy/docker-compose.yml up -d

portainer:
	docker compose -f compose/infrastructure/portainer/docker-compose.yml up -d