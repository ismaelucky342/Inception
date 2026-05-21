FROM alpine:3.18

# Instalar Prometheus
RUN apk add --no-cache prometheus wget

# Crear directorio para datos
RUN mkdir -p /etc/prometheus /var/lib/prometheus && \
    chown -R nobody:nogroup /var/lib/prometheus

# Copiar configuración
COPY conf/prometheus.yml /etc/prometheus/prometheus.yml

# Permisos
RUN chmod 644 /etc/prometheus/prometheus.yml

# Script de inicialización
COPY tools/init.sh /usr/local/bin/init.sh
RUN chmod +x /usr/local/bin/init.sh

# Puerto de Prometheus
EXPOSE 9090

# Comando de inicio
CMD ["/usr/local/bin/init.sh"]
