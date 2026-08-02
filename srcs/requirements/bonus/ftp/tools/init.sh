#!/bin/sh
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

# ── Fijar contraseña del usuario FTP desde el secret (nunca en la imagen) ──
FTP_PASSWORD=$(cat /run/secrets/ftp_password)
echo "ftpuser:${FTP_PASSWORD}" | chpasswd

# Asegurar permisos correctos
chown -R ftpuser:ftpuser /var/www/html
chmod -R 755 /var/www/html

# Iniciar vsftpd en foreground como PID 1 (propaga señales de docker stop)
exec /usr/sbin/vsftpd /etc/vsftpd/vsftpd.conf
