#!/bin/bash
# entrypoint.sh — genera certificado TLS y arranca nginx
set -e

SSL_DIR="/etc/nginx/ssl"
CERT="${SSL_DIR}/inception.crt"
KEY="${SSL_DIR}/inception.key"
CONF="/etc/nginx/nginx.conf"

# ── Genera certificado self-signed si no existe ──────────────
if [ ! -f "$CERT" ] || [ ! -f "$KEY" ]; then
    echo "[Nginx] Generando certificado TLS self-signed..."
    mkdir -p "$SSL_DIR"

    openssl req -x509 -nodes -days 365 \
        -newkey rsa:2048 \
        -keyout "$KEY" \
        -out "$CERT" \
        -subj "/C=ES/ST=Madrid/L=Madrid/O=42Madrid/CN=${DOMAIN_NAME}"
    #          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    #          CN = Common Name = debe coincidir con el dominio

    echo "[Nginx] ✓ Certificado generado: ${DOMAIN_NAME}"
fi

# ── Sustituye variables de entorno en nginx.conf ─────────────
# envsubst reemplaza ${DOMAIN_NAME} por su valor real
envsubst '${DOMAIN_NAME}' < "$CONF" > /tmp/nginx.conf
cp /tmp/nginx.conf "$CONF"

# ── Valida la configuración antes de arrancar ─────────────────
echo "[Nginx] Validando configuración..."
nginx -t

# ── Arranca nginx en foreground (PID 1) ──────────────────────
echo "[Nginx] Arrancando en foreground (TLS only, puerto 443)..."
exec nginx -g "daemon off;"
