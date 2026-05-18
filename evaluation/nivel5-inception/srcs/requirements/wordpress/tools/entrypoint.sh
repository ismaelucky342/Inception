#!/bin/bash
# entrypoint.sh — descarga, configura e inicia WordPress
set -e

WP_PATH="/var/www/html"

# ── Descarga WordPress si no existe ─────────────────────────
if [ ! -f "${WP_PATH}/wp-config.php" ]; then
    echo "[WordPress] Descargando WordPress..."
    wp core download \
        --path="${WP_PATH}" \
        --locale=es_ES \
        --allow-root

    echo "[WordPress] Creando wp-config.php..."
    wp config create \
        --path="${WP_PATH}" \
        --dbname="${MYSQL_DATABASE}" \
        --dbuser="${MYSQL_USER}" \
        --dbpass="${MYSQL_PASSWORD}" \
        --dbhost="mariadb:3306" \
        --allow-root

    echo "[WordPress] Esperando a que MariaDB esté disponible..."
    until wp db check --path="${WP_PATH}" --allow-root 2>/dev/null; do
        echo "  → Esperando MariaDB..."
        sleep 3
    done

    echo "[WordPress] Instalando WordPress..."
    wp core install \
        --path="${WP_PATH}" \
        --url="https://${DOMAIN_NAME}" \
        --title="${WP_TITLE}" \
        --admin_user="${WP_ADMIN_USER}" \
        --admin_password="${WP_ADMIN_PASSWORD}" \
        --admin_email="${WP_ADMIN_EMAIL}" \
        --skip-email \
        --allow-root

    echo "[WordPress] Creando usuario adicional..."
    wp user create \
        "${WP_USER}" "${WP_USER_EMAIL}" \
        --role=author \
        --user_pass="${WP_USER_PASSWORD}" \
        --path="${WP_PATH}" \
        --allow-root

    # Permisos correctos para php-fpm
    chown -R www-data:www-data "${WP_PATH}"
    find "${WP_PATH}" -type d -exec chmod 755 {} \;
    find "${WP_PATH}" -type f -exec chmod 644 {} \;

    echo "[WordPress] ✓ Instalación completada"
fi

# ── Arranca php-fpm en foreground (PID 1) ────────────────────
echo "[WordPress] Arrancando php-fpm en foreground..."
exec php-fpm7.4 --nodaemonize
#               ^^^^^^^^^^^^
#               No daemonizar = quedar en foreground = PID 1
