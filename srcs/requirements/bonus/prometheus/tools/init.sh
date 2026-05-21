#!/bin/sh

# Crear directorio de datos si no existe
mkdir -p /var/lib/prometheus

# Asegurar permisos correctos
chown -R nobody:nogroup /var/lib/prometheus

# Iniciar Prometheus
prometheus --config.file=/etc/prometheus/prometheus.yml --storage.tsdb.path=/var/lib/prometheus
