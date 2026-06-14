# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    init.sh                                            :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: ismherna <ismherna@student.42madrid.com    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2026/03/12 00:03:17 by ismherna          #+#    #+#              #
#    Updated: 2026/06/15 00:04:37 by ismherna         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#!/bin/sh

# Crear directorio de datos si no existe
mkdir -p /var/lib/redis

# Asegurar permisos correctos
chown -R redis:redis /var/lib/redis

# Iniciar Redis
redis-server --bind 0.0.0.0 --appendonly yes --dir /var/lib/redis
