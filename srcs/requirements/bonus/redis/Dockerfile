FROM alpine:3.18

# Instalar Redis
RUN apk add --no-cache redis

# Crear directorio para datos
RUN mkdir -p /var/lib/redis && chown -R redis:redis /var/lib/redis

# Script de inicialización
COPY tools/init.sh /usr/local/bin/init.sh
RUN chmod +x /usr/local/bin/init.sh

# Puerto de Redis
EXPOSE 6379

# Comando de inicio
CMD ["/usr/local/bin/init.sh"]
