# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: ismherna <ismherna@student.42madrid.com    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2026/03/12 00:02:27 by ismherna          #+#    #+#              #
#    Updated: 2026/06/15 00:04:37 by ismherna         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

FROM alpine:3.23

RUN apk add --no-cache nginx openssl gettext

# La conf se copia como plantilla: DOMAIN_NAME se sustituye en runtime (init.sh)
COPY conf/nginx.conf /etc/nginx/templates/default.conf.template

COPY tools/init.sh /usr/local/bin/init.sh
RUN chmod +x /usr/local/bin/init.sh

RUN mkdir -p /var/www/html

EXPOSE 443

ENTRYPOINT ["/usr/local/bin/init.sh"]
CMD ["nginx", "-g", "daemon off;"]