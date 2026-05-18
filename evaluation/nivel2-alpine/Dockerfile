# ============================================================
# NIVEL 2A — Alpine Linux (imagen base ligera)
# Concepto: sistema base, gestor de paquetes, variables de entorno
#
# Build:  docker build -t mi-alpine .
# Run:    docker run --rm -it mi-alpine
# ============================================================

# Alpine es una distro Linux minimalista (~5MB)
# En Inception 42 está PERMITIDO como base
FROM alpine:3.19

# LABEL: metadata de la imagen
LABEL maintainer="ismherna@student.42.fr"
LABEL description="Nivel 2 - Alpine con herramientas básicas"

# ENV: define variables de entorno disponibles en build Y en runtime
ENV MI_VARIABLE="hola_42"
ENV OTRA_VAR="docker_rocks"

# RUN: ejecuta comandos durante el BUILD de la imagen
# Cada RUN crea un nuevo layer
# Buena práctica: encadenar con && y limpiar caché al final
RUN apk update && \
    apk add --no-cache \
        bash \
        curl \
        wget \
        vim && \
    apk add fastfetch --repository=https://dl-cdn.alpinelinux.org/alpine/edge/community && \
    rm -rf /var/cache/apk/*
#             ^^^^^^^^^^^^^^^^
#             limpia la caché de apk para reducir tamaño de imagen

# WORKDIR: crea el directorio y lo establece como cwd
# Equivalente a mkdir -p /app && cd /app
WORKDIR /app

# COPY: copia ficheros del host → imagen
# COPY <origen_en_host> <destino_en_imagen>
COPY info.sh /app/info.sh

# Dar permisos de ejecución
RUN chmod +x /app/info.sh

# CMD: comando por defecto (puede sobreescribirse con docker run <imagen> <otro_cmd>)
# Ejecuta el script usando sh nativo y luego abre una shell interactiva de sh
CMD ["/bin/sh", "-c", "/app/info.sh && exec /bin/sh"]
