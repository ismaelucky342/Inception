#!/bin/sh

# Asegurar permisos correctos
chown -R ftpuser:ftpuser /var/www/html
chmod -R 755 /var/www/html

# Iniciar vsftpd
/usr/sbin/vsftpd /etc/vsftpd/vsftpd.conf
