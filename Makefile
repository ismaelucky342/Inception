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

# Target para limpiar volúmenes y reiniciar (MUY ÚTIL)
re: down up