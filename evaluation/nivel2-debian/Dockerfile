# ============================================================
# NIVEL 2B — Debian Bullseye Slim
# Concepto: imagen base más cercana a lo que usarás en Inception
#
# Build:  docker build -t mi-debian .
# Run:    docker run --rm -it mi-debian
# ============================================================

# debian:bullseye = Debian 11 (la versión recomendada para Inception)
# :slim = variante reducida sin paquetes extra
# En Inception 42 DEBES usar esta (o alpine) como base
FROM debian:bullseye

LABEL maintainer="ismherna@student.42.fr"
LABEL description="Nivel 2 - Debian Bullseye (base de Inception)"

# ARG: variable SOLO disponible durante el build (no en runtime)
# Diferencia clave con ENV: ARG no persiste en la imagen final
ARG BUILD_DATE="desconocida"
ARG VERSION="1.0"

ENV APP_ENV="development"
ENV APP_VERSION=$VERSION

# apt-get: gestor de paquetes de Debian/Ubuntu
# Siempre: update primero, instalar después, limpiar al final
# DEBIAN_FRONTEND=noninteractive evita prompts interactivos
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        bash \
        curl \
        wget \
        vim \
        procps \
        net-tools \
        neofetch \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
#              ^^^^^^^^^^^^^^^^^^
#              limpia el caché de apt (reduce imagen ~30-50MB)

WORKDIR /app

COPY info.sh /app/info.sh
RUN chmod +x /app/info.sh

# Diferencia CMD vs ENTRYPOINT:
# CMD    → puede sobreescribirse al hacer: docker run imagen OTRO_COMANDO
# ENTRYPOINT → siempre se ejecuta, CMD son sus argumentos por defecto
# Ejecuta el script de Debian y luego nos lanza una shell interactiva de Bash
CMD ["/bin/bash", "-c", "/app/info.sh && exec /bin/bash"]