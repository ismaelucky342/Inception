# Makefile
COMPOSE_FILE = srcs/docker-compose.yml

# Target principal: Levantar la infraestructura
all: up

# Target para construir la imagen de MariaDB
build_mariadb:
	@echo "--- Building MariaDB Image ---"
	docker-compose -f $(COMPOSE_FILE) build mariadb

# Target para levantar el servicio MariaDB (en modo detached)
up_mariadb: build_mariadb
	@echo "--- Starting MariaDB Container ---"
	docker-compose -f $(COMPOSE_FILE) up -d mariadb

# Targets generales (útiles para el flujo de trabajo)
up:
	@echo "--- Starting all services (up) ---"
	docker-compose -f $(COMPOSE_FILE) up -d --build

down:
	@echo "--- Stopping and removing all containers, networks, and volumes ---"
	docker-compose -f $(COMPOSE_FILE) down -v

# Target para limpiar volúmenes y reiniciar
re: down up

# Targets BONUS
bonus:
	@echo "--- Bonus services status ---"
	@echo " Redis (Cache)"
	@echo " FTP Server"
	@echo " Grafana + Prometheus (Monitoring)"
	@echo " Adminer (Database UI)"
	@echo " Static Website"
	@docker-compose -f $(COMPOSE_FILE) ps | grep -E 'redis|ftp|grafana|prometheus|adminer|static-site|cadvisor' || echo "Bonus services not running"

logs:
	@docker-compose -f $(COMPOSE_FILE) logs -f

clean:
	@echo "--- Cleaning up docker resources ---"
	@docker system prune -f
	@echo "✓ Cleaned"