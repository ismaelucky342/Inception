# ============================================================
# NIVEL 3A — Servidor HTTP con Python
# Concepto: proceso en foreground, EXPOSE, mapeo de puertos
#
# Build:  docker build -t mi-python-http .
# Run:    docker run --rm -p 8080:8000 mi-python-http
# Web:    http://localhost:8080
# ============================================================

FROM debian:bullseye

LABEL maintainer="ismherna@student.42.fr"
LABEL description="Nivel 3 - servidor HTTP Python en foreground"

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        python3 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /var/www/html

# Copiamos el contenido web estático
COPY index.html /var/www/html/index.html

# EXPOSE: documenta qué puerto usa el contenedor
# ⚠️  EXPOSE solo documenta, NO abre el puerto automáticamente
#    Para publicarlo: docker run -p HOST_PORT:CONTAINER_PORT
EXPOSE 8000

# ENTRYPOINT + CMD juntos:
#   ENTRYPOINT define el ejecutable (no sobreescribible fácilmente)
#   CMD define los argumentos por defecto (sobreescribible)
#
# Equivalente a ejecutar: python3 -m http.server 8000
#
# CRÍTICO PARA INCEPTION: el proceso debe correr en FOREGROUND
# Python -m http.server NO se daemoniza → perfecto como PID 1
ENTRYPOINT ["python3", "-m", "http.server"]
CMD ["8000"]
