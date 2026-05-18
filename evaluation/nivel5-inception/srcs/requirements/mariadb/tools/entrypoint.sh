#!/bin/bash
# entrypoint.sh — inicializa MariaDB para Inception 42
set -e

# Asegura que el directorio del socket existe
mkdir -p /run/mysqld
chown mysql:mysql /run/mysqld

# ── Primera inicialización ───────────────────────────────────
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "[MariaDB] Inicializando base de datos por primera vez..."

    mysql_install_db --user=mysql --datadir=/var/lib/mysql --skip-test-db

    # Arranca temporalmente sin red
    mysqld_safe --skip-networking --socket=/run/mysqld/mysqld.sock &
    TEMP_PID=$!

    # Espera a que el socket esté disponible
    for i in $(seq 1 30); do
        [ -S /run/mysqld/mysqld.sock ] && break
        sleep 1
    done

    echo "[MariaDB] Configurando usuarios y base de datos..."
    mysql --socket=/run/mysqld/mysqld.sock -u root <<-EOSQL
        FLUSH PRIVILEGES;
        ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
        CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`
            CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
        CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%'
            IDENTIFIED BY '${MYSQL_PASSWORD}';
        GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
        FLUSH PRIVILEGES;
	EOSQL

    # Para el proceso temporal
    kill $TEMP_PID
    wait $TEMP_PID 2>/dev/null || true
    echo "[MariaDB] ✓ Inicialización completada"
fi

# ── Arranque final como PID 1 ────────────────────────────────
echo "[MariaDB] Arrancando en foreground..."
exec mysqld --user=mysql
