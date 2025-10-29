#!/bin/bash

# Este script debe ser capaz de inicializar la BD si es la primera vez.

# Inicia el servicio MariaDB en modo seguro en background
/usr/bin/mysqld_safe --datadir='/var/lib/mysql' &

# Espera a que el servidor de BD esté listo
sleep 10 

# Crea la base de datos, el usuario y otorga permisos, usando variables de entorno
# NOTA: Debes usar las variables de entorno que docker-compose inyectará.

# 1. Configurar la contraseña de ROOT
mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"
mysql -u root -p"${MYSQL_ROOT_PASSWORD}" -e "FLUSH PRIVILEGES;"

# 2. Crear la base de datos de WordPress
mysql -u root -p"${MYSQL_ROOT_PASSWORD}" -e "CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};"

# 3. Crear el usuario de WordPress (accesible desde cualquier host %) y otorgar privilegios
mysql -u root -p"${MYSQL_ROOT_PASSWORD}" -e "CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
mysql -u root -p"${MYSQL_ROOT_PASSWORD}" -e "GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';"

# 4. Limpieza y Aplicación de Privilegios
mysql -u root -p"${MYSQL_ROOT_PASSWORD}" -e "DELETE FROM mysql.user WHERE User='';" # Elimina usuarios anónimos
mysql -u root -p"${MYSQL_ROOT_PASSWORD}" -e "DROP DATABASE IF EXISTS test;"
mysql -u root -p"${MYSQL_ROOT_PASSWORD}" -e "FLUSH PRIVILEGES;"

# Detener el servidor temporal (para que el CMD tome el control final)
mysqladmin -u root -p"${MYSQL_ROOT_PASSWORD}" shutdown
# El CMD final (/usr/sbin/mysqld) se ejecutará automáticamente después del ENTRYPOINT.