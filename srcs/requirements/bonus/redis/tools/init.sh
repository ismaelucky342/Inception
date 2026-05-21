#!/bin/sh

# Crear directorio de datos si no existe
mkdir -p /var/lib/redis

# Asegurar permisos correctos
chown -R redis:redis /var/lib/redis

# Iniciar Redis
redis-server --bind 0.0.0.0 --appendonly yes --dir /var/lib/redis
