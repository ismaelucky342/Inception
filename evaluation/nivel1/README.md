# Nivel 1 — hello-world

## ¿Qué aprende aquí?

- Qué es una imagen Docker (plantilla de solo lectura)
- Qué es un contenedor (instancia en ejecución de una imagen)
- El ciclo de vida más básico: build → run → exit

## Comandos

```bash
# Construir la imagen (crea un "paquete" llamado mi-hello)
docker build -t mi-hello .

# Ejecutar el contenedor (--rm lo borra al terminar)
docker run --rm mi-hello

# Ver la imagen creada
docker images mi-hello

# Ver los layers de la imagen
docker history mi-hello

# Inspeccionar metadata
docker inspect mi-hello
```

## ¿Qué pasa por dentro?

```
docker build -t mi-hello .
      │
      ▼
Lee Dockerfile línea a línea
      │
      ├── FROM busybox   → descarga imagen base (layer 1)
      ├── LABEL ...      → añade metadata (no crea layer)
      └── CMD [...]      → registra comando por defecto
      │
      ▼
Imagen: mi-hello (≈1.5MB)

docker run --rm mi-hello
      │
      ▼
Crea contenedor desde imagen
      │
      ▼
Ejecuta CMD: echo "Hola..."
      │
      ▼
Imprime mensaje → exit 0 → contenedor se destruye (--rm)
```

## Conceptos clave

| Término | Qué es |
|---------|--------|
| Imagen | Plantilla inmutable con capas (layers) |
| Contenedor | Proceso aislado que usa una imagen |
| Layer | Cada instrucción RUN/COPY crea una capa |
| FROM scratch | Imagen vacía total (0 bytes) |
| --rm | Borra el contenedor al terminar |
