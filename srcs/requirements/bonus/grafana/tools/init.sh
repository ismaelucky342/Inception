# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    init.sh                                            :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: ismherna <ismherna@student.42madrid.com    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2026/03/12 00:03:34 by ismherna          #+#    #+#              #
#    Updated: 2026/06/15 00:04:37 by ismherna         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#!/bin/sh

# Crear directorio de datos si no existe
mkdir -p /var/lib/grafana

# Asegurar permisos correctos
chown -R grafana:grafana /var/lib/grafana

# Iniciar Grafana
grafana-server --homepath=/usr/share/grafana --config=/etc/grafana/grafana.ini
