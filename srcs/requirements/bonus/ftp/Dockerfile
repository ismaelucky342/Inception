FROM alpine:3.18

# Instalar vsftpd (FTP server)
RUN apk add --no-cache vsftpd

# Crear usuario FTP
RUN addgroup -g 1001 ftpuser && \
    adduser -D -u 1001 -G ftpuser -h /var/www/html ftpuser && \
    echo "ftpuser:Melman@20142010" | chpasswd

# Configuración vsftpd
RUN mkdir -p /etc/vsftpd && \
    echo "listen=YES" > /etc/vsftpd/vsftpd.conf && \
    echo "listen_ipv6=NO" >> /etc/vsftpd/vsftpd.conf && \
    echo "anonymous_enable=NO" >> /etc/vsftpd/vsftpd.conf && \
    echo "local_enable=YES" >> /etc/vsftpd/vsftpd.conf && \
    echo "write_enable=YES" >> /etc/vsftpd/vsftpd.conf && \
    echo "local_umask=022" >> /etc/vsftpd/vsftpd.conf && \
    echo "dirmessage_enable=YES" >> /etc/vsftpd/vsftpd.conf && \
    echo "use_localtime=YES" >> /etc/vsftpd/vsftpd.conf && \
    echo "xferlog_enable=YES" >> /etc/vsftpd/vsftpd.conf && \
    echo "connect_from_port_20=YES" >> /etc/vsftpd/vsftpd.conf && \
    echo "secure_chroot_dir=/var/run/vsftpd/empty" >> /etc/vsftpd/vsftpd.conf && \
    echo "pam_service_name=vsftpd" >> /etc/vsftpd/vsftpd.conf && \
    echo "rsa_cert_file=/etc/ssl/certs/vsftpd.crt" >> /etc/vsftpd/vsftpd.conf && \
    echo "rsa_private_key_file=/etc/ssl/private/vsftpd.key" >> /etc/vsftpd/vsftpd.conf && \
    echo "ssl_enable=NO" >> /etc/vsftpd/vsftpd.conf && \
    echo "pasv_enable=YES" >> /etc/vsftpd/vsftpd.conf && \
    echo "pasv_min_port=10000" >> /etc/vsftpd/vsftpd.conf && \
    echo "pasv_max_port=10100" >> /etc/vsftpd/vsftpd.conf && \
    mkdir -p /var/run/vsftpd/empty

# Permisos del directorio WordPress
RUN mkdir -p /var/www/html && \
    chown -R ftpuser:ftpuser /var/www/html

# Script de inicialización
COPY tools/init.sh /usr/local/bin/init.sh
RUN chmod +x /usr/local/bin/init.sh

# Puerto FTP
EXPOSE 20 21 10000-10100

# Comando de inicio
CMD ["/usr/local/bin/init.sh"]
