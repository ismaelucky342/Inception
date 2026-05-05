#!/bin/sh
# ─────────────────────────────────────────────
# init.sh — Inicialización de MariaDB en Alpine
# ─────────────────────────────────────────────

# ── Leer secrets desde /run/secrets/ ────────────────────
MYSQL_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)
MYSQL_PASSWORD=$(cat /run/secrets/db_password)

# 1. Inicializar el sistema de tablas solo si es la primera vez
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "[init] Primera ejecución: inicializando base de datos..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql > /dev/null
    echo "[init] Sistema de tablas creado."
fi

# 2. Arrancar MariaDB en background
mysqld --user=mysql --datadir=/var/lib/mysql --skip-networking &
MYSQL_PID=$!

# 3. Esperar hasta que el servidor acepte conexiones
echo "[init] Esperando a que MariaDB esté lista..."
until mysqladmin ping --silent 2>/dev/null; do
    sleep 1
done
echo "[init] MariaDB lista."

# 4. Configurar root, BD y usuario de WordPress
mysql -u root << EOF
UPDATE mysql.user
    SET authentication_string = PASSWORD('${MYSQL_ROOT_PASSWORD}'),
        plugin = 'mysql_native_password'
    WHERE User = 'root' AND Host = 'localhost';

DELETE FROM mysql.user WHERE User = '';

DROP DATABASE IF EXISTS test;

CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;

CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%'
    IDENTIFIED BY '${MYSQL_PASSWORD}';

GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';

FLUSH PRIVILEGES;
EOF

echo "[init] Usuarios y base de datos configurados."

# 5. Apagar el servidor temporal
mysqladmin -u root -p"${MYSQL_ROOT_PASSWORD}" shutdown

wait $MYSQL_PID
echo "[init] Servidor temporal detenido. Iniciando modo producción..."

exec "$@"