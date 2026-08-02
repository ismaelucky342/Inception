#!/bin/sh
# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    init.sh                                            :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: ismherna <ismherna@student.42madrid.com    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2026/03/12 00:02:59 by ismherna          #+#    #+#              #
#    Updated: 2026/06/15 00:04:37 by ismherna         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# Copiar los assets estáticos y sustituir DOMAIN_NAME en el HTML antes de servirlo
cp -r /etc/nginx/site-template/. /var/www/html/
envsubst '${DOMAIN_NAME}' < /etc/nginx/site-template/index.html > /var/www/html/index.html

# Iniciar NGINX en foreground como PID 1
exec nginx -g "daemon off;"
