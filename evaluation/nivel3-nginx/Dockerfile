# ============================================================
# NIVEL 3C — Nginx con configuración propia
# Concepto: configuración personalizada, usuario non-root, señales
#
# Build:  docker build -t mi-nginx .
# Run:    docker run --rm -p 8080:80 mi-nginx
# Web:    http://localhost:8080
# ============================================================

FROM debian:bullseye

LABEL maintainer="ismherna@student.42.fr"
LABEL description="Nivel 3 - Nginx con conf custom, base de Inception"

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        nginx \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copiamos nuestra configuración de nginx (reemplaza la de defecto)
COPY nginx.conf /etc/nginx/nginx.conf

# Copiamos el contenido web
COPY html/ /var/www/html/

EXPOSE 80

# CRÍTICO: nginx -g "daemon off;"
# Por defecto nginx se daemoniza (va al background) y el proceso
# principal termina → el contenedor se cierra inmediatamente.
# "daemon off" lo mantiene en foreground como PID 1.
#
# Este es el patrón que usarás en Inception para todos los servicios.
CMD ["nginx", "-g", "daemon off;"]
