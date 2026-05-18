# Nivel 2C — Arch Linux

> ⚠️ **Solo educativo**: Arch no está permitida en Inception 42.
> El objetivo es comparar gestores de paquetes y filosofías de distro.

## ¿Por qué Arch como ejemplo?

| Característica | Alpine | Debian | **Arch** |
|---|---|---|---|
| Tamaño base | ~5MB | ~70MB | ~140MB |
| Gestor | apk | apt-get | **pacman** |
| Libc | musl | glibc | **glibc** |
| Release model | versiones fijas | versiones fijas | **rolling** |
| Filosofía | minimalismo | estabilidad | **KISS** |
| Documentación | básica | extensa | **Arch Wiki** |

## Comandos

```bash
# Construir
docker build -t mi-arch .

# Ejecutar interactivo
docker run --rm -it mi-arch

# O entrar directamente con bash
docker run --rm -it mi-arch bash

# Instalar algo dentro del contenedor en tiempo real
docker run --rm -it mi-arch bash -c "pacman -S --noconfirm neofetch && neofetch"
```

## pacman vs apt-get vs apk

```bash
# ── Instalar un paquete ───────────────────────────────────
apk add --no-cache curl          # Alpine
apt-get install -y --no-install-recommends curl  # Debian
pacman -S --noconfirm curl       # Arch

# ── Actualizar BD + sistema ───────────────────────────────
apk update && apk upgrade        # Alpine (dos pasos)
apt-get update && apt-get upgrade -y  # Debian (dos pasos)
pacman -Syu --noconfirm          # Arch (UN solo paso, siempre juntos)

# ── Buscar un paquete ─────────────────────────────────────
apk search curl                  # Alpine
apt-cache search curl            # Debian
pacman -Ss curl                  # Arch

# ── Info de un paquete ────────────────────────────────────
apk info curl                    # Alpine
apt-cache show curl              # Debian
pacman -Si curl                  # Arch (de repositorio)
pacman -Qi curl                  # Arch (instalado localmente)

# ── Listar instalados ─────────────────────────────────────
apk info                         # Alpine
dpkg -l                          # Debian
pacman -Q                        # Arch

# ── Limpiar caché ─────────────────────────────────────────
rm -rf /var/cache/apk/*          # Alpine
apt-get clean && rm /var/lib/apt/lists/*  # Debian
pacman -Scc --noconfirm          # Arch
```

## Diferencia crucial: rolling release

En Alpine y Debian, las imágenes tienen una versión fija:
- `alpine:3.19` — siempre será Alpine 3.19
- `debian:bullseye` — siempre será Debian 11

En Arch, no hay versiones:
- `archlinux:base` — hoy puede ser distinto que mañana
- Siempre es la última versión de todos los paquetes
- Ventaja: software más nuevo
- Riesgo en producción: puede romper cosas sin avisar

## musl vs glibc

Esto es **importante** para contenedores:

- **Alpine** usa `musl libc` — más ligero, pero algunos binarios compilados
  para glibc no funcionan (ej: Oracle drivers, algunos binarios de Go, etc.)
- **Debian y Arch** usan `glibc` — estándar POSIX completo,
  máxima compatibilidad con software Linux

En Inception usas Debian por esto: máxima compatibilidad con
php-fpm, mysql, nginx, etc., sin sorpresas de compatibilidad musl.
