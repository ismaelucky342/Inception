# ============================================================
# Inception — WordPress con php-fpm
# php-fpm = FastCGI Process Manager: gestiona procesos PHP
# Nginx le pasa las peticiones .php via socket/TCP
# ============================================================

FROM debian:bullseye

LABEL maintainer="ismherna@student.42.fr"

# php-fpm: el gestor de procesos PHP (no apache)
# wp-cli: herramienta de línea de comandos para WordPress
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        php7.4-fpm \
        php7.4-mysql \
        php7.4-curl \
        php7.4-gd \
        php7.4-mbstring \
        php7.4-xml \
        php7.4-zip \
        wget \
        curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Instala wp-cli (herramienta para configurar WP desde línea de comandos)
RUN wget -q https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    -O /usr/local/bin/wp \
    && chmod +x /usr/local/bin/wp

# Configuración de php-fpm: escucha en puerto 9000 (no en socket unix)
COPY conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf

COPY tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# WordPress sirve desde aquí (volumen compartido con nginx)
WORKDIR /var/www/html

# php-fpm escucha peticiones FastCGI en este puerto
EXPOSE 9000

ENTRYPOINT ["/entrypoint.sh"]
