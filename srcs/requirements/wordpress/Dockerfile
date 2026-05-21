FROM alpine:3.18

# php83: intérprete base
# php83-fpm: gestor de procesos FastCGI (lo que requiere el subject)
# php83-mysqli: conexión con MariaDB
# php83-phar: necesario para wp-cli
# php83-iconv / mbstring: manejo de strings en WordPress
# php83-curl: peticiones HTTP de WordPress (updates, plugins...)
# php83-dom / xml: parseo XML de WordPress
# php83-session: manejo de sesiones
# wget / unzip: para descargar WordPress
RUN apk add --no-cache \
    php \
    php-fpm \
    php-mysqli \
    php-phar \
    php-iconv \
    php-mbstring \
    php-curl \
    php-dom \
    php-xml \
    php-session \
    php-tokenizer \
    wget \
    unzip

# wp-cli: herramienta oficial para configurar WordPress por línea de comandos
# Imprescindible para instalar WP sin interfaz web (y sin hardcodear nada)
RUN wget -q https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# Configuración de php-fpm
COPY conf/www.conf /etc/php/php-fpm.d/www.conf

# Script de inicialización
COPY tools/init.sh /usr/local/bin/init.sh
RUN chmod +x /usr/local/bin/init.sh

# Directorio compartido con NGINX (volumen)
RUN mkdir -p /var/www/html

WORKDIR /var/www/html

EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/init.sh"]
CMD ["/usr/sbin/php-fpm83", "-F"]