# Usa una imagen base de Debian estable (como requiere el proyecto)
FROM debian:bookworm-slim

# Instala MariaDB y wget (para descargar dependencias si fuera necesario)
RUN apt-get update && apt-get install -y mariadb-server \
    && rm -rf /var/lib/apt/lists/*

# Copia el script de inicialización y lo hace ejecutable
COPY tools/init.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/init.sh

# Especifica dónde estará la base de datos (para el volumen)
RUN mkdir -p /var/lib/mysql

# CMD se ejecuta si no hay un ENTRYPOINT o si el ENTRYPOINT es solo un script
# Usaremos nuestro script init.sh como ENTRYPOINT y luego el comando del daemon.
ENTRYPOINT ["/usr/local/bin/init.sh"]

# El comando final para que el contenedor permanezca vivo
CMD ["/usr/sbin/mysqld"]

# Puerto interno de MariaDB
EXPOSE 3306