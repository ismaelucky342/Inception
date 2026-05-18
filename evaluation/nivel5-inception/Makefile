# Makefile — Inception 42
# Uso: make all | make down | make clean | make fclean | make re

# Login de 42 (cámbialo)
LOGIN		= ismherna

# Directorios de volúmenes en el host
DATA_DIR	= /home/$(LOGIN)/data
MYSQL_DIR	= $(DATA_DIR)/mysql
WP_DIR		= $(DATA_DIR)/wordpress

COMPOSE		= docker compose -f srcs/docker-compose.yml --env-file srcs/.env

.PHONY: all build up down start stop clean fclean re logs ps

# ── all: crea dirs + build + arrancar ─────────────────────
all: dirs build up

# ── Crea directorios de datos en el host ──────────────────
dirs:
	@mkdir -p $(MYSQL_DIR) $(WP_DIR)
	@echo "✓ Directorios creados: $(DATA_DIR)"

# ── Construir imágenes ────────────────────────────────────
build:
	@echo ">>> Construyendo imágenes..."
	$(COMPOSE) build --no-cache
	@echo "✓ Imágenes construidas"

# ── Arrancar servicios en background ─────────────────────
up:
	@echo ">>> Arrancando servicios..."
	$(COMPOSE) up -d
	@echo "✓ Stack levantado"
	@echo "  → Accede a: https://$(LOGIN).42.fr"

# ── Parar y eliminar contenedores ────────────────────────
down:
	$(COMPOSE) down

# ── Solo parar (sin borrar) ───────────────────────────────
stop:
	$(COMPOSE) stop

# ── Ver logs de todos los servicios ──────────────────────
logs:
	$(COMPOSE) logs -f

# ── Estado de los contenedores ────────────────────────────
ps:
	$(COMPOSE) ps

# ── Limpieza: borra contenedores e imágenes ───────────────
clean: down
	@echo ">>> Eliminando imágenes..."
	docker rmi mariadb wordpress nginx 2>/dev/null || true
	@echo "✓ Limpieza completada"

# ── Limpieza total: también borra volúmenes y datos ───────
fclean: clean
	@echo ">>> Eliminando volúmenes Docker..."
	$(COMPOSE) down -v 2>/dev/null || true
	@echo ">>> Eliminando datos del host..."
	sudo rm -rf $(DATA_DIR)
	@echo "✓ Limpieza total completada"

# ── Rebuild completo ──────────────────────────────────────
re: fclean all
