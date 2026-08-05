# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: ismherna <ismherna@student.42madrid.com    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2026/03/12 00:03:38 by ismherna          #+#    #+#              #
#    Updated: 2026/06/15 00:04:37 by ismherna         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

FROM alpine:3.23

# Instalar dependencias
RUN apk add --no-cache grafana

# Crear directorio para datos
RUN mkdir -p /var/lib/grafana && \
    chown -R grafana:grafana /var/lib/grafana

# Provisionar Prometheus como datasource automáticamente
RUN mkdir -p /etc/grafana/provisioning/datasources
COPY conf/datasource.yml /etc/grafana/provisioning/datasources/datasource.yml

# Script de inicialización
COPY tools/init.sh /usr/local/bin/init.sh
RUN chmod +x /usr/local/bin/init.sh

# Puerto de Grafana
EXPOSE 3000

# Comando de inicio
CMD ["/usr/local/bin/init.sh"]
