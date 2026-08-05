*This project has been created as part of the 42 curriculum by ismherna.*

# DEV_DOC — Inception

Developer-oriented documentation: prerequisites, project setup, Makefile internals, `docker compose` usage and how data persistence is implemented. For end-user instructions, see [`USER_DOC.md`](./USER_DOC.md).

## 1. Prerequisites

- Docker Engine + the Docker Compose plugin (`docker compose`, v2 syntax — the Makefile does **not** use the legacy standalone `docker-compose` binary).
- A Linux host (developed and evaluated on a VM), root/sudo access to edit `/etc/hosts`.
- `make`.

## 2. Repository layout

```
.
├── Makefile
├── README.md
├── USER_DOC.md
├── DEV_DOC.md
├── secrets/                    # git-ignored, created locally before `make`
└── srcs/
    ├── .env                    # non-secret config (domain, DB name, WP titles/emails...)
    ├── docker-compose.yml
    └── requirements/
        ├── mariadb/
        ├── wordpress/
        ├── nginx/
        └── bonus/
            ├── redis/
            ├── ftp/
            ├── prometheus/
            ├── grafana/
            ├── adminer/
            └── static-site/
```

Each service folder under `requirements/` has its own `Dockerfile`, plus `conf/` (static config templates) and `tools/init.sh` (entrypoint script) where relevant. One Dockerfile per service, no shared/base images across services, no images pulled from Docker Hub other than `alpine`.

## 3. Local setup before first run

1. Create the secret files expected by `docker-compose.yml` (see `secrets/README.md` for the exact list and an example script). These files are git-ignored and must exist locally before `make up`.
2. Add the domain to `/etc/hosts`:
   ```
   127.0.0.1   ismherna.42.fr
   ```
3. Review/adjust `srcs/.env` if needed (domain name, DB name/user, WP titles and emails — no passwords live here, those are all in `secrets/`).

## 4. Makefile targets

| Target | What it does |
|---|---|
| `make` / `make all` | `docker compose up -d --build` — builds and starts every service |
| `make down` | `docker compose down --remove-orphans` — stops containers, keeps volumes |
| `make clean` | `make down` + force-remove all project images |
| `make fclean` | `make clean` + remove volumes, network, and prune the builder cache — full reset |
| `make re` | `make fclean` + `make up` |
| `make logs` | tail logs of every service |
| `make bonus` | shows only the status of the bonus containers |

All targets point at `srcs/docker-compose.yml` via `COMPOSE_FILE`; images/volumes to clean are declared explicitly in `IMAGES`/`VOLUMES` so `make fclean` doesn't rely on wildcards.

## 5. docker compose commands used during development

```bash
# rebuild a single service after editing its Dockerfile
docker compose -f srcs/docker-compose.yml up -d --build <service>

# shell into a running container
docker compose -f srcs/docker-compose.yml exec <service> sh

# check the substituted config actually landed inside a container
docker compose -f srcs/docker-compose.yml exec static-site cat /var/www/html/index.html

# inspect a named volume's mountpoint
docker volume inspect srcs_wp_data
```

## 6. Data persistence

Persistence is implemented with named Docker volumes (declared at the bottom of `docker-compose.yml`, driver `local`), mounted into the host under the evaluated learner's home directory:

| Volume | Mounted in container at | Used by |
|---|---|---|
| `wp_data` | `/var/www/html` | wordpress, nginx (read), ftp |
| `db_data` | `/var/lib/mysql` | mariadb |
| `redis_data` | `/var/lib/redis` | redis |
| `prometheus_data` | `/var/lib/prometheus` | prometheus |
| `grafana_data` | `/var/lib/grafana` | grafana |

`wp_data` is intentionally shared between `wordpress`, `nginx` (serves the static PHP/theme files) and `ftp` (uploads land directly where WordPress serves them from). WordPress's `init.sh` is idempotent: it only downloads WordPress / creates `wp-config.php` / runs `wp core install` if those steps haven't already happened, so restarting the stack does not reset the site or overwrite existing content.

## 7. Networking

All services share a single user-defined bridge network (`inception`) declared in `docker-compose.yml`, so containers reach each other by service name (`mariadb`, `wordpress`, `prometheus`, etc.) without any port publishing needed between them. Only the services that need to be reached from outside the VM publish a port to the host (`nginx:443`, `adminer:8081`, `grafana:3000`, `ftp:20/21/10000-10100`, `static-site:8080`); everything else (`mariadb`, `wordpress`, `redis`, `prometheus`) is reachable only from inside the `inception` network via `expose`.

## 8. Adding/modifying a service

1. Create `srcs/requirements/<name>/Dockerfile` (+ `conf/`, `tools/init.sh` as needed), based on `alpine` (currently pinned to the penultimate stable branch, `3.23`).
2. Add the service block to `srcs/docker-compose.yml`: `build`, `container_name`, `image: inception_<name>` (must match the service name), `networks: [inception]`, and either `expose` (internal-only) or `ports` (reachable from the host).
3. If it needs secrets or non-secret config, wire them via `secrets:` / `env_file: .env` like the existing services.
4. If it should show up in the bonus status panel, add a row in `srcs/requirements/bonus/static-site/html/index.html` and update the `make bonus` grep pattern in the `Makefile`.
