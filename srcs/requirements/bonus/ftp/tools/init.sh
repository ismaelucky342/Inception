# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    init.sh                                            :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: ismherna <ismherna@student.42madrid.com    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2026/03/12 00:03:47 by ismherna          #+#    #+#              #
#    Updated: 2026/06/15 00:04:37 by ismherna         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#!/bin/sh

# Asegurar permisos correctos
chown -R ftpuser:ftpuser /var/www/html
chmod -R 755 /var/www/html

# Iniciar vsftpd
/usr/sbin/vsftpd /etc/vsftpd/vsftpd.conf
