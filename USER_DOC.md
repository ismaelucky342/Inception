*This project has been created as part of the 42 curriculum by ismherna.*

# USER_DOC — Inception

Guide for the end user / administrator of the infrastructure: how to start and stop it, how to reach the website and the admin panel, how credentials are managed, and how to do basic health checks. For anything related to how the project is built or developed, see [`DEV_DOC.md`](./DEV_DOC.md).

## 1. Requirements before starting

- Docker and the Docker Compose plugin installed and running.
- Your machine's `/etc/hosts` must resolve the project domain to your local machine:

```
127.0.0.1   ismherna.42.fr
```

## 2. Starting the stack

From the root of the repository:

```bash
make
```

This builds every image and starts all containers (mandatory + bonus services) in the background via `docker compose`. The first start takes longer because WordPress, the database and the bonus services are being provisioned.

To check that everything is up:

```bash
docker compose -f srcs/docker-compose.yml ps
```

All services should show as `running`/`healthy`.

## 3. Stopping the stack

```bash
make down
```

Stops and removes the containers **without** deleting the data (named volumes are kept, so WordPress and the database stay intact for the next `make`).

If you also want to remove volumes, images and the network (full reset):

```bash
make fclean
```

## 4. Accessing the website

- Main site (WordPress, over HTTPS only): `https://ismherna.42.fr`
  - `http://ismherna.42.fr` will not work — port 80 is not exposed on purpose (mandatory requirement).
  - The certificate is self-signed, so your browser will show a security warning the first time. This is expected; accept/continue.
- Status panel with links to every bonus service: `http://ismherna.42.fr:8080`

## 5. Accessing the WordPress admin panel

1. Go to `https://ismherna.42.fr/wp-admin`.
2. Log in with the administrator account created from `secrets/credentials.txt` (username on the first line, password on the second line). The admin username intentionally does **not** contain "admin"/"Admin", per project requirements.
3. A second, non-admin WordPress user (author role) is also created automatically at startup, using `WP_USER` / `secrets/wp_user_password.txt` — useful for testing comments/permissions without full admin rights.

## 6. Managing credentials

All passwords are provided as Docker secrets, read from plain-text files in the (git-ignored) `secrets/` folder — never hardcoded in Dockerfiles or committed to git:

| File | Used by | Content |
|---|---|---|
| `db_password.txt` | MariaDB / WordPress | password of the WordPress MySQL user |
| `db_root_password.txt` | MariaDB | root password |
| `credentials.txt` | WordPress | 2 lines: admin username, admin password |
| `wp_user_password.txt` | WordPress | password of the second (author) user |
| `ftp_password.txt` | FTP | password of `ftpuser` |
| `grafana_admin_password.txt` | Grafana | Grafana admin password |

To rotate a password: stop the stack, edit the corresponding file in `secrets/`, then start again with `make re` (this recreates the containers; note that WordPress only re-runs its install step if the site isn't already installed — for a full reset, use `make fclean` first).

## 7. Other bonus services

All bonus services and their access points are also listed on the status panel (`http://ismherna.42.fr:8080`):

| Service | Access | Notes |
|---|---|---|
| Adminer | `http://ismherna.42.fr:8081` | Login with the MariaDB credentials above; server = `mariadb` |
| Grafana | `http://ismherna.42.fr:3000` | Login `admin` / `secrets/grafana_admin_password.txt`; Prometheus is pre-provisioned as a datasource |
| FTP | `ftp ismherna.42.fr` (use a proper FTP client, not a browser — modern browsers no longer support `ftp://` links) | User `ftpuser` / `secrets/ftp_password.txt`, points at the WordPress volume |
| Redis | internal only, no direct access needed (used automatically by WordPress as a cache) | — |
| Prometheus | internal only, `http://prometheus:9090` from inside the `inception` network | scraped by Grafana |

## 8. Basic checks

- **Is everything running?** `docker compose -f srcs/docker-compose.yml ps` — all containers should be `Up`.
- **Bonus services status only:** `make bonus`.
- **Logs of everything (live):** `make logs`, or for a single service: `docker compose -f srcs/docker-compose.yml logs -f <service_name>`.
- **Is WordPress reachable?** Open `https://ismherna.42.fr` in a browser — you should see the site, not the WordPress install wizard.
- **Is data persistent?** Add a comment or edit a page in WordPress, then `make down && make` — the change should still be there.
