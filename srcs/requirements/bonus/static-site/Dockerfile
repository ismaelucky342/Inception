# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: ismherna <ismherna@student.42madrid.com    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2026/03/12 00:02:52 by ismherna          #+#    #+#              #
#    Updated: 2026/06/15 00:04:37 by ismherna         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

FROM alpine:3.18

# Instalar nginx
RUN apk add --no-cache nginx

# Crear directorio para el sitio
RUN mkdir -p /var/www/html

# Copiar archivos del sitio
COPY html/ /var/www/html/

# Configuración de nginx
COPY conf/nginx.conf /etc/nginx/http.d/default.conf

# Script de inicialización
COPY tools/init.sh /usr/local/bin/init.sh
RUN chmod +x /usr/local/bin/init.sh

# Puerto
EXPOSE 8080

# Comando de inicio
CMD ["/usr/local/bin/init.sh"]
