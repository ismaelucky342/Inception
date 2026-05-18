# ============================================================
# NIVEL 1 — hello-world desde cero
# Concepto: qué es una imagen, un layer y un contenedor
#
# Build:  docker build -t mi-hello .
# Run:    docker run --rm mi-hello
# ============================================================

# FROM scratch = imagen vacía absoluta, sin OS, sin shell
# Aquí meteríamos un binario estático si fuera real.
# Usamos busybox como truco para tener algo ejecutable.
FROM busybox:latest

# LABEL es metadata de la imagen (aparece en docker inspect)
LABEL maintainer="ismherna@student.42.fr"
LABEL description="Nivel 1 - imagen más básica posible"

# CMD es el comando por defecto al hacer docker run
# Solo imprime un mensaje y el contenedor muere (exit 0)
CMD ["echo", "Hola desde mi primer contenedor Docker!"]
