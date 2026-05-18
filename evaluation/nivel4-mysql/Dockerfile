# ============================================================
# NIVEL 4A — MySQL instalado desde paquetes (sin imagen oficial)
# Concepto: VOLUME, init scripts, variables sensibles, healthcheck
#
# Build:  docker build -t mi-mysql .
# Run:    docker run --rm \
#           -e MYSQL_ROOT_PASSWORD=rootpass \
#           -e MYSQL_DATABASE=mi_db \
#           -e MYSQL_USER=mi_usuario \
#           -e MYSQL_PASSWORD=mi_pass \
#           -v mi_db_data:/var/lib/mysql \
#           -p 3306:3306 \
#           mi-mysql
# ============================================================

# IMPORTANTE para Inception: debes usar debian o alpine, NO mysql:latest
FROM debian:bullseye

LABEL maintainer="ismherna@student.42.fr"
LABEL description="Nivel 4 - MySQL sin imagen oficial"

# Instalamos MariaDB (fork libre de MySQL, compatible al 100%)
# En Inception 42 usarás MariaDB, NO MySQL oficial
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        mariadb-server \
        mariadb-client \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copiamos el script de inicialización y el entrypoint
COPY init.sql /docker-entrypoint-initdb.d/init.sql
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# VOLUME: declara un punto de montaje persistente
# Los datos de MySQL DEBEN persistir entre reinicios del contenedor
# Sin VOLUME, al borrar el contenedor pierdes todos los datos
VOLUME ["/var/lib/mysql"]

# Puerto de MySQL/MariaDB
EXPOSE 3306

# HEALTHCHECK: Docker puede verificar si el servicio está listo
# --interval=10s: comprueba cada 10 segundos
# --timeout=5s: falla si tarda más de 5s
# --retries=3: 3 fallos consecutivos = unhealthy
HEALTHCHECK --interval=10s --timeout=5s --retries=3 \
    CMD mysqladmin ping -h localhost -u root -p"${MYSQL_ROOT_PASSWORD}" || exit 1

# Usamos entrypoint personalizado para inicializar la BD
ENTRYPOINT ["/entrypoint.sh"]
