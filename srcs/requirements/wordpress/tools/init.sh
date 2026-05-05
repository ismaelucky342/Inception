#!/bin/sh
# ─────────────────────────────────────────────────────
# init.sh — Inicialización de WordPress con WP-CLI
# ─────────────────────────────────────────────────────

WP_PATH="/var/www/html"

# ── Leer secrets desde /run/secrets/ ────────────────────
MYSQL_PASSWORD=$(cat /run/secrets/db_password)
WP_ADMIN_USER=$(cat /run/secrets/credentials | head -1)
WP_ADMIN_PASSWORD=$(cat /run/secrets/credentials | tail -1)

# ── 1. Descargar WordPress si no está instalado ──────────
if [ ! -f "${WP_PATH}/wp-login.php" ]; then
    echo "[wp] Descargando WordPress..."
    wp core download \
        --path="${WP_PATH}" \
        --locale=en_US \
        --allow-root
fi

# ── 2. Crear wp-config.php si no existe ─────────────────
if [ ! -f "${WP_PATH}/wp-config.php" ]; then
    echo "[wp] Creando wp-config.php..."
    wp config create \
        --path="${WP_PATH}" \
        --dbname="${MYSQL_DATABASE}" \
        --dbuser="${MYSQL_USER}" \
        --dbpass="${MYSQL_PASSWORD}" \
        --dbhost="mariadb:3306" \
        --allow-root
fi

# ── 3. Esperar a que MariaDB esté lista ──────────────────
echo "[wp] Esperando a MariaDB..."
until wp db check --path="${WP_PATH}" --allow-root 2>/dev/null; do
    sleep 2
done
echo "[wp] MariaDB lista."

# ── 4. Instalar WordPress si no está instalado ───────────
if ! wp core is-installed --path="${WP_PATH}" --allow-root 2>/dev/null; then
    echo "[wp] Instalando WordPress..."

    wp core install \
        --path="${WP_PATH}" \
        --url="https://${DOMAIN_NAME}" \
        --title="${WP_TITLE}" \
        --admin_user="${WP_ADMIN_USER}" \
        --admin_password="${WP_ADMIN_PASSWORD}" \
        --admin_email="${WP_ADMIN_EMAIL}" \
        --allow-root

    wp user create \
        "${WP_USER}" "${WP_USER_EMAIL}" \
        --role=author \
        --user_pass="${WP_USER_PASSWORD}" \
        --path="${WP_PATH}" \
        --allow-root

    echo "[wp] WordPress instalado con dos usuarios."
fi

# ── 5. Permisos correctos para NGINX ─────────────────────
chown -R www-data:www-data "${WP_PATH}"

echo "[wp] Iniciando PHP-FPM..."
exec "$@"