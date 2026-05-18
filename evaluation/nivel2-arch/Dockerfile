# ============================================================
# NIVEL 2C — Arch Linux
# Concepto: rolling release, pacman, filosofía KISS
#
#     Arch Linux NO está permitida como base del proyecto.
#     Este ejemplo es EDUCATIVO para entender distintos
#     gestores de paquetes y filosofías de distro.
#
# Build:  docker build -t mi-arch .
# Run:    docker run --rm -it mi-arch
# ============================================================

# archlinux:base = imagen oficial mínima de Arch (~140MB)
# A diferencia de Alpine (~5MB) o Debian (~70MB):
#   - No tiene versión fija: es rolling release
#   - El tag :base solo trae pacman y lo esencial
#   - El tag :base-devel trae además gcc, make, etc.
FROM archlinux:base

# LABEL: metadata de la imagen
LABEL maintainer="tu_login@student.42.fr"
LABEL description="Nivel 2C - Arch Linux con pacman"

# ENV: variables disponibles en build Y en runtime
ENV MI_VARIABLE="hola_42"
ENV OTRA_VAR="I_use_arch_btw"
#                ^^^^^^^^

# ── Diferencias clave respecto a Alpine y Debian ─────────────
#
# Alpine usa:  apk update && apk add --no-cache <pkg>
# Debian usa:  apt-get update && apt-get install -y <pkg>
# Arch usa:    pacman -Syu --noconfirm <pkg>
#
# -S  = sync (instalar / actualizar)
# -y  = actualiza la base de datos de paquetes (como apt update)
# -u  = actualiza todos los paquetes instalados (upgrade)
# --noconfirm = no pregunta confirmación (equivalente a -y en apt)
#
# Arch combina update + upgrade en un solo paso: -Syu
# En Debian serían dos comandos separados: apt-get update && apt-get upgrade
#
# IMPORTANTE: en Arch es OBLIGATORIO hacer -Syu juntos, nunca solo -Sy
# (solo actualizar la BD sin actualizar paquetes rompe dependencias)

RUN pacman -Syu --noconfirm && \
    pacman -S --noconfirm --needed \
        bash \
        curl \
        wget \
        vim \
        which \
        procps-ng \
        fastfetch \
    && pacman -Scc --noconfirm
#      ^^^^^^^^^^^
#      Limpia la caché de pacman (equivalente a rm /var/cache/apk/* en Alpine
#      o rm /var/lib/apt/lists/* en Debian)
#      -Scc = limpia TODA la caché (paquetes descargados + base de datos)

# WORKDIR: crea /app y lo establece como directorio de trabajo
# Mismo comportamiento que en Alpine y Debian
WORKDIR /app

# COPY: igual en todas las distros — Docker abstrae el FS
COPY info.sh /app/info.sh

RUN chmod +x /app/info.sh

# CMD: igual en todas las distros
# Ejecuta el script informativo y luego nos lanza una shell interactiva de Bash
CMD ["/bin/bash", "-c", "/app/info.sh && exec /bin/bash"]

# ── Comparativa de gestores de paquetes ──────────────────────
#
#  Distro   │ Gestor  │ Instalar          │ Actualizar BD  │ Limpiar caché
#  ─────────┼─────────┼───────────────────┼────────────────┼──────────────
#  Alpine   │ apk     │ apk add --no-cache│ apk update     │ rm /var/cache/apk/*
#  Debian   │ apt-get │ apt-get install -y│ apt-get update │ rm /var/lib/apt/lists/*
#  Arch     │ pacman  │ pacman -S         │ pacman -Sy     │ pacman -Scc
#  Fedora   │ dnf     │ dnf install -y    │ dnf check-upd. │ dnf clean all
#  openSUSE │ zypper  │ zypper install    │ zypper refresh │ zypper clean
