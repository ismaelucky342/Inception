# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: ismherna <ismherna@student.42madrid.com    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2026/03/12 00:02:37 by ismherna          #+#    #+#              #
#    Updated: 2026/06/15 00:04:37 by ismherna         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

FROM alpine:3.23

RUN apk add --no-cache mariadb mariadb-client

# Corregir la config por defecto de Alpine: desactivar skip-networking
# para que MariaDB escuche por TCP, no solo por socket unix.
RUN sed -i '/^skip-networking/s/^/# Disabled for Inception: /' /etc/my.cnf.d/mariadb-server.cnf && \
    printf '\n# Inception: permitir conexiones TCP\n[mysqld]\nbind-address = 0.0.0.0\nport = 3306\n' >> /etc/my.cnf.d/mariadb-server.cnf

COPY tools/init.sh /usr/local/bin/init.sh
RUN chmod +x /usr/local/bin/init.sh

RUN mkdir -p /var/lib/mysql /run/mysqld && chown -R mysql:mysql /var/lib/mysql /run/mysqld

ENTRYPOINT ["/usr/local/bin/init.sh"]
CMD ["/usr/bin/mysqld", "--user=mysql", "--datadir=/var/lib/mysql"]

EXPOSE 3306