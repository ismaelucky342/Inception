# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: ismherna <ismherna@student.42madrid.com    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2026/03/12 00:04:00 by ismherna          #+#    #+#              #
#    Updated: 2026/06/15 00:04:37 by ismherna         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

FROM alpine:3.18

# Instalar NGINX, PHP y dependencias
RUN apk add --no-cache \
    nginx \
    php \
    php-fpm \
    php-pdo \
    php-pdo_mysql \
    php-pdo_pgsql \
    php-pdo_sqlite \
    wget

# Crear directorio para Adminer
RUN mkdir -p /var/www/html

# Descargar Adminer
RUN wget -q https://www.adminer.org/latest.php -O /var/www/html/index.php

# Configuración de PHP-FPM
RUN mkdir -p /etc/php/php-fpm.d && \
    echo "[www]" > /etc/php/php-fpm.d/adminer.conf && \
    echo "listen = /run/php-fpm.sock" >> /etc/php/php-fpm.d/adminer.conf && \
    echo "listen.owner = nobody" >> /etc/php/php-fpm.d/adminer.conf && \
    echo "listen.group = nogroup" >> /etc/php/php-fpm.d/adminer.conf && \
    echo "user = nobody" >> /etc/php/php-fpm.d/adminer.conf && \
    echo "group = nogroup" >> /etc/php/php-fpm.d/adminer.conf && \
    echo "pm = dynamic" >> /etc/php/php-fpm.d/adminer.conf && \
    echo "pm.max_children = 5" >> /etc/php/php-fpm.d/adminer.conf && \
    echo "pm.start_servers = 1" >> /etc/php/php-fpm.d/adminer.conf && \
    echo "pm.min_spare_servers = 1" >> /etc/php/php-fpm.d/adminer.conf && \
    echo "pm.max_spare_servers = 3" >> /etc/php/php-fpm.d/adminer.conf

# Configuración de NGINX
COPY conf/adminer.conf /etc/nginx/http.d/default.conf

# Script de inicialización
COPY tools/init.sh /usr/local/bin/init.sh
RUN chmod +x /usr/local/bin/init.sh

# Puerto NGINX
EXPOSE 8081

# Comando de inicio
CMD ["/usr/local/bin/init.sh"]
