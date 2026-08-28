#!/bin/sh
# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    init.sh                                            :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: ismherna <ismherna@student.42madrid.com    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2026/03/12 00:04:00 by ismherna          #+#    #+#              #
#    Updated: 2026/06/15 00:04:37 by ismherna         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#!/bin/sh

mkdir -p /run/nginx

# Iniciar PHP-FPM
php-fpm -D

# Iniciar NGINX en primer plano
nginx -g "daemon off;"