#!/bin/sh
# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    init.sh                                            :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: ismherna <ismherna@student.42madrid.com    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2026/03/12 00:02:22 by ismherna          #+#    #+#              #
#    Updated: 2026/06/15 00:04:37 by ismherna         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #
# ─────────────────────────────────────────────────────
# init.sh — Inicialización de WordPress con WP-CLI
# ─────────────────────────────────────────────────────

WP_PATH="/var/www/html"

# ── Leer secrets desde /run/secrets/ ────────────────────
MYSQL_PASSWORD=$(cat /run/secrets/db_password)
WP_ADMIN_USER=$(cat /run/secrets/credentials | head -1)
WP_ADMIN_PASSWORD=$(cat /run/secrets/credentials | tail -1)
WP_USER_PASSWORD=$(cat /run/secrets/wp_user_password)

# ── Fijar límite de memoria para wp-cli (evita "Allowed memory size exhausted") ──
export WP_CLI_PHP_ARGS="-d memory_limit=512M"

# ── 1. Descargar WordPress si no está instalado ──────────
if [ ! -f "${WP_PATH}/wp-login.php" ]; then
    echo "[wp] Descargando WordPress..."
    wp core download \
        --path="${WP_PATH}" \
        --locale=en_US \
        --allow-root
fi

# ── 2. Esperar a que MariaDB esté lista ──────────────────
echo "[wp] Esperando a MariaDB..."
export MYSQL_USER MYSQL_PASSWORD MYSQL_DATABASE
until php -r 'mysqli_report(MYSQLI_REPORT_OFF); $m=@new mysqli("mariadb", getenv("MYSQL_USER"), getenv("MYSQL_PASSWORD"), getenv("MYSQL_DATABASE")); exit($m->connect_errno ? 1 : 0);' 2>/dev/null; do
    sleep 2
done
echo "[wp] MariaDB lista."

# ── 3. Crear wp-config.php si no existe ─────────────────
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