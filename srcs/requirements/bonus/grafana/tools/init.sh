#!/bin/sh
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

# Crear directorio de datos si no existe
mkdir -p /var/lib/grafana

# Asegurar permisos correctos
chown -R grafana:grafana /var/lib/grafana

# Password de admin desde el secret (nunca en el compose/git)
export GF_SECURITY_ADMIN_PASSWORD=$(cat /run/secrets/grafana_admin_password)

# Iniciar Grafana en foreground como PID 1
exec grafana-server --homepath=/usr/share/grafana --config=/usr/share/grafana/conf/defaults.ini
