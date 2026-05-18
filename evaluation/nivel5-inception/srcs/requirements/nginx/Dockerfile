# ============================================================
# Inception — Nginx con TLS propio
# Requisitos 42:
#   - Solo puerto 443 (HTTPS)
#   - TLSv1.2 o TLSv1.3 únicamente
#   - Certificado self-signed (openssl)
#   - Proxy a WordPress via FastCGI (php-fpm)
# ============================================================

FROM debian:bullseye

LABEL maintainer="ismherna@student.42.fr"

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        nginx \
        openssl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copia configuración de nginx
COPY conf/nginx.conf /etc/nginx/nginx.conf

COPY tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Solo puerto HTTPS (regla de Inception)
EXPOSE 443

ENTRYPOINT ["/entrypoint.sh"]
