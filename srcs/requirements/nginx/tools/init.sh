# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    init.sh                                            :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: ismherna <ismherna@student.42madrid.com    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2026/03/12 00:02:31 by ismherna          #+#    #+#              #
#    Updated: 2026/06/15 00:04:37 by ismherna         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#!/bin/sh

# Generar certificado SSL autofirmado si no existe
if [ ! -f /etc/nginx/ssl/nginx.crt ]; then
    echo "[init] Generando certificado SSL autofirmado..."
    mkdir -p /etc/nginx/ssl

    openssl req -x509 -nodes \
        -days 365 \
        -newkey rsa:2048 \
        -keyout /etc/nginx/ssl/nginx.key \
        -out    /etc/nginx/ssl/nginx.crt \
        -subj   "/C=ES/ST=Madrid/L=Madrid/O=42/CN=${DOMAIN_NAME}"

    echo "[init] Certificado generado."
fi

exec "$@"