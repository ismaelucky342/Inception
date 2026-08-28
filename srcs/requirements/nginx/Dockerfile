# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: ismherna <ismherna@student.42madrid.com    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2026/03/12 00:02:27 by ismherna          #+#    #+#              #
#    Updated: 2026/08/28 17:00:30 by ismherna         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

FROM alpine:3.23

RUN apk add --no-cache nginx openssl gettext

# Copiar la plantilla de configuración
COPY conf/nginx.conf /etc/nginx/templates/default.conf.template

COPY tools/init.sh /usr/local/bin/init.sh
RUN chmod +x /usr/local/bin/init.sh

# Crear el directorio y asignar permisos para el usuario nginx/nobody
RUN mkdir -p /var/www/html /run/nginx && \
    chown -R nginx:nginx /var/www/html

EXPOSE 443
RUN chown -R nginx:nginx /run/nginx

ENTRYPOINT ["/usr/local/bin/init.sh"]
CMD ["nginx", "-g", "daemon off;"]