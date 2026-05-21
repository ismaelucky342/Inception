#!/bin/sh

# Crear directorio de datos si no existe
mkdir -p /var/lib/grafana

# Asegurar permisos correctos
chown -R grafana:grafana /var/lib/grafana

# Iniciar Grafana
grafana-server --homepath=/usr/share/grafana --config=/etc/grafana/grafana.ini
