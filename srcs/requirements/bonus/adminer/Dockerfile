# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: ismherna <ismherna@student.42madrid.com    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2026/03/12 00:04:00 by ismherna          #+#    #+#              #
#    Updated: 2026/08/28 16:56:20 by ismherna         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

FROM alpine:3.23

# Instalar NGINX, PHP-FPM y módulos requeridos por Adminer
RUN apk add --no-cache \
    nginx \
    php \
    php-fpm \
    php-session \
    php-mysqli \
    php-pdo \
    php-pdo_mysql \
    wget

# Crear enlace simbólico genérico para php-fpm
RUN ln -sf /usr/sbin/php-fpm* /usr/sbin/php-fpm

# Crear directorio para Adminer
RUN mkdir -p /var/www/html /run/nginx

# Descargar Adminer
RUN wget -q https://www.adminer.org/latest.php -O /var/www/html/index.php

# Configurar PHP-FPM para escuchar en el puerto TCP 9000
RUN FPM_POOL_DIR=$(ls -d /etc/php*/php-fpm.d 2>/dev/null | head -n 1) && \
    rm -rf ${FPM_POOL_DIR}/* && \
    echo "[www]" > ${FPM_POOL_DIR}/adminer.conf && \
    echo "user = nobody" >> ${FPM_POOL_DIR}/adminer.conf && \
    echo "group = nogroup" >> ${FPM_POOL_DIR}/adminer.conf && \
    echo "listen = 127.0.0.1:9000" >> ${FPM_POOL_DIR}/adminer.conf && \
    echo "pm = dynamic" >> ${FPM_POOL_DIR}/adminer.conf && \
    echo "pm.max_children = 5" >> ${FPM_POOL_DIR}/adminer.conf && \
    echo "pm.start_servers = 1" >> ${FPM_POOL_DIR}/adminer.conf && \
    echo "pm.min_spare_servers = 1" >> ${FPM_POOL_DIR}/adminer.conf && \
    echo "pm.max_spare_servers = 3" >> ${FPM_POOL_DIR}/adminer.conf

# Copiar configuración de NGINX y script de inicio
COPY conf/adminer.conf /etc/nginx/http.d/default.conf
COPY tools/init.sh /usr/local/bin/init.sh
RUN chmod +x /usr/local/bin/init.sh

EXPOSE 8081

CMD ["/usr/local/bin/init.sh"]