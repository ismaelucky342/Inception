FROM alpine:3.18

RUN apk add --no-cache mariadb mariadb-client

COPY tools/init.sh /usr/local/bin/init.sh
RUN chmod +x /usr/local/bin/init.sh

RUN mkdir -p /var/lib/mysql && chown -R mysql:mysql /var/lib/mysql

ENTRYPOINT ["/usr/local/bin/init.sh"]
CMD ["/usr/bin/mysqld", "--user=mysql", "--datadir=/var/lib/mysql"]

EXPOSE 3306