# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: ismherna <ismherna@student.42madrid.com    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
# **************************************************************************** #

COMPOSE_FILE = srcs/docker-compose.yml
COMPOSE_PARALLEL_LIMIT = 1
VOLUMES = db_data wp_data redis_data prometheus_data grafana_data
IMAGES  = inception_mariadb inception_wordpress inception_nginx inception_redis \
          inception_ftp inception_prometheus inception_grafana inception_adminer \
          inception_static_site

all: up

up:
	@echo "--- Starting all services ---"
	docker-compose -f $(COMPOSE_FILE) up -d --build

down:
	@echo "--- Stopping all services (keeping volumes) ---"
	docker-compose -f $(COMPOSE_FILE) down --remove-orphans

clean: down
	@echo "--- Removing project images ---"
	@for img in $(IMAGES); do \
		docker rmi -f $$img 2>/dev/null || true; \
	done

fclean: clean
	@echo "--- Full clean: volumes, network, dangling images and builder cache ---"
	@docker-compose -f $(COMPOSE_FILE) down -v --rmi all --remove-orphans 2>/dev/null || true
	@for vol in $(VOLUMES); do \
		docker volume rm $$vol 2>/dev/null || true; \
	done
	@docker network rm inception 2>/dev/null || true
	@docker builder prune -f
	@echo "Cleanup complete."

re: fclean up

logs:
	docker-compose -f $(COMPOSE_FILE) logs -f

bonus:
	@echo "--- Bonus services status ---"
	@docker-compose -f $(COMPOSE_FILE) ps | grep -E 'redis|ftp|grafana|prometheus|adminer|static-site' || echo "Bonus services not running"

.PHONY: all up down clean fclean re logs bonus
