FROM alpine:3.18

RUN apk add --no-cache nginx openssl

COPY conf/nginx.conf /etc/nginx/http.d/default.conf

COPY tools/init.sh /usr/local/bin/init.sh
RUN chmod +x /usr/local/bin/init.sh

RUN mkdir -p /var/www/html

EXPOSE 443

ENTRYPOINT ["/usr/local/bin/init.sh"]
CMD ["nginx", "-g", "daemon off;"]