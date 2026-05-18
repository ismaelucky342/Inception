#!/bin/bash
# entrypoint.sh — inicializa MariaDB si es la primera vez
# Este script es el PID 1 del contenedor

set -e  # Sale inmediatamente si cualquier comando falla

# ── Validación de variables requeridas ──────────────────────
if [ -z "$MYSQL_ROOT_PASSWORD" ]; then
    echo "ERROR: MYSQL_ROOT_PASSWORD no está definida"
    exit 1
fi

MYSQL_DATABASE=${MYSQL_DATABASE:-""}
MYSQL_USER=${MYSQL_USER:-""}
MYSQL_PASSWORD=${MYSQL_PASSWORD:-""}

# ── Primera ejecución: inicializar directorio de datos ───────
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo ">>> Primera ejecución: inicializando base de datos..."

    # mysql_install_db crea la estructura inicial del sistema de datos
    mysql_install_db --user=mysql --datadir=/var/lib/mysql --skip-test-db

    # Iniciamos MySQL temporalmente para configurarlo
    mysqld_safe --skip-networking &
    MYSQL_PID=$!

    # Esperamos a que MySQL esté listo
    echo ">>> Esperando a que MariaDB arranque..."
    for i in $(seq 1 30); do
        if mysqladmin ping --silent 2>/dev/null; then
            break
        fi
        sleep 1
    done

    echo ">>> Configurando seguridad básica..."
    mysql -u root <<-EOSQL
        -- Borra usuarios anónimos
        DELETE FROM mysql.user WHERE User='';
        -- Borra la BD de test
        DROP DATABASE IF EXISTS test;
        -- Establece contraseña de root
        ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
        -- Permite conexión remota de root (necesario para docker-compose)
        CREATE USER IF NOT EXISTS 'root'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
        GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
	EOSQL

    # Crea BD y usuario si se han especificado
    if [ -n "$MYSQL_DATABASE" ]; then
        echo ">>> Creando base de datos: $MYSQL_DATABASE"
        mysql -u root -p"${MYSQL_ROOT_PASSWORD}" -e "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
    fi

    if [ -n "$MYSQL_USER" ] && [ -n "$MYSQL_PASSWORD" ]; then
        echo ">>> Creando usuario: $MYSQL_USER"
        mysql -u root -p"${MYSQL_ROOT_PASSWORD}" <<-EOSQL
            CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
            GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
            FLUSH PRIVILEGES;
		EOSQL
    fi

    # Ejecuta scripts de inicialización si existen
    for f in /docker-entrypoint-initdb.d/*.sql; do
        echo ">>> Ejecutando: $f"
        mysql -u root -p"${MYSQL_ROOT_PASSWORD}" < "$f"
    done

    # Para el MySQL temporal
    kill $MYSQL_PID
    wait $MYSQL_PID 2>/dev/null || true

    echo ">>> ✓ Inicialización completada"
fi

# ── Arranque normal en foreground (PID 1) ───────────────────
echo ">>> Arrancando MariaDB en foreground..."
exec mysqld --user=mysql --bind-address=0.0.0.0
#    ^^^^
#    exec reemplaza este script con mysqld
#    → mysqld se convierte en PID 1 (requerido por Inception)
