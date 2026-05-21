#!/bin/sh

# Iniciar PHP-FPM
php-fpm -D

# Iniciar NGINX
nginx -g "daemon off;"
