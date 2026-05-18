# ============================================================
# Inception — MariaDB
# Reglas 42: FROM debian:bullseye (NO imagen oficial mariadb)
#            penúltima versión estable de debian
# ============================================================

FROM debian:bullseye

LABEL maintainer="ismherna@student.42.fr"

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        mariadb-server \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copia scripts de configuración e inicialización
COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY tools/entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

# Los datos de MariaDB persisten en este volumen
EXPOSE 3306

ENTRYPOINT ["/entrypoint.sh"]
