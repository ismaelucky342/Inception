*This project has been created as part of the 42 curriculum by ismherna.*

# Inception
<p align="center">
  <img src="https://github.com/user-attachments/assets/3d4d4c9c-4602-4250-8721-80c2c64e0080" width="300">
</p>

## Description

**Inception** is a DevOps project that consists of building a fully functional web infrastructure using **Docker** and **Docker Compose**, without relying on pre-built images (except Alpine or Debian). The goal is to create a secure, modular, and maintainable architecture that runs inside containers, following strict rules and best practices regarding service separation, data persistence, security, and automation.

The platform must be accessible through a locally mapped domain:

```
<login>.42.fr → 127.0.0.1
```

---

## Services and Architecture

The infrastructure is composed of the following services, each containerized and built with a custom Dockerfile:

- **Nginx:** Acts as a reverse proxy. Configured to support HTTPS (TLS/SSL) with self-signed certificates using OpenSSL. Handles traffic to WordPress and Adminer.
- **WordPress + PHP-FPM:** A CMS platform for publishing content. Runs on top of PHP-FPM and communicates with the MariaDB database.
- **MariaDB:** Relational database server used by WordPress. Initialization scripts set up the database, user credentials, and permissions securely.
- **Adminer:** A lightweight database management tool for interacting with MariaDB via a web interface.
- **Redis** *(Bonus):* Added as a caching layer for WordPress to improve performance and reduce load on the database.
- **FTP Server** *(Bonus):* Allows file uploads to WordPress via FTP. Secured with authentication.
- **Static Website** *(Bonus):* A personal portfolio or homepage hosted as a separate service, served by Nginx or another static file server.

---

## Security & Requirements

- Each service runs in its own container.
- Services do **not** use the `latest` tag.
- Dockerfiles are built from scratch (except Alpine/Debian base).
- TLS (HTTPS) is enabled and enforced via Nginx.
- Volumes are used to ensure data persistence across restarts.
- `.env` file is used for environment variables and secrets.
- Only local networks and ports are exposed as needed.

---

## Instructions

### 1. Prerequisites

- Docker & Docker Compose installed.
- Modify your `/etc/hosts` file to map the domain:

```
127.0.0.1 <your_login>.42.fr
```

### 2. Setup

```bash
make
```

This command builds and launches all the containers using Docker Compose.

### 3. Stop & Clean

```bash
make down
```

Stops all services and removes containers, volumes, and networks.

---

## Bonus Features

- **Redis caching** for improved WordPress performance.
- **FTP server** for secure file transfers to the WordPress container.
- **Static personal website** container, separate from WordPress.
- Docker healthchecks configured where appropriate.
- Basic hardening: permissions, reduced base layers, non-root users (where applicable).

---

## Directory Structure

```
.
├── Makefile
├── README.md
├── USER_DOC.md
├── DEV_DOC.md
├── secrets/              # Stores credentials (ignored by Git, created locally before `make`)
└── srcs/
    ├── .env              # non-secret config, tracked by Git
    ├── docker-compose.yml
    └── requirements/
        ├── nginx/
        ├── wordpress/
        ├── mariadb/
        └── bonus/
            ├── redis/
            ├── ftp/
            ├── prometheus/
            ├── grafana/
            ├── adminer/
            └── static-site/
```

---

## ✅ Evaluation Checklist

- [ ]  All services are containerized using custom Dockerfiles.
- [ ]  Domain `login.42.fr` resolves locally.
- [ ]  TLS/SSL is configured using OpenSSL.
- [ ]  WordPress can connect to MariaDB with persistent data.
- [ ]  Adminer allows DB management.
- [ ]  Bonus services are functional (Redis, FTP, Static Site).
- [ ]  `.env` is respected and used.
- [ ]  `make` and `make down` work as expected.

---

## Resources

- [`USER_DOC.md`](./USER_DOC.md) — end-user / admin guide (start/stop the stack, access WordPress and the admin panel, manage credentials, basic checks).
- [`DEV_DOC.md`](./DEV_DOC.md) — developer guide (prerequisites, setup, Makefile usage, docker compose commands, data persistence).
- [Docker documentation](https://docs.docker.com/)
- [Docker Compose documentation](https://docs.docker.com/compose/)
- [WordPress + WP-CLI documentation](https://developer.wordpress.org/cli/commands/)
- [Alpine Linux packages](https://pkgs.alpinelinux.org/packages)

### How AI was used

<!-- TODO(ismherna): personaliza este párrafo con lo que realmente hiciste, es lo que te van a preguntar en la defensa. -->
AI tools (Claude) were used during this project as a support resource, mainly for:
- Debugging specific errors in Dockerfiles, `docker-compose.yml` and shell init scripts (e.g. interpreting error messages, suggesting fixes to test).
- Reviewing configuration files (NGINX, PHP-FPM, vsftpd) against best practices before applying changes manually.
- Drafting and formatting this documentation (README, USER_DOC.md, DEV_DOC.md) from notes taken while building the project.

All architecture decisions, the Dockerfiles, the docker-compose configuration and the service integration were designed, written and tested manually by the author. AI suggestions were reviewed, understood and adapted rather than copy-pasted directly, in line with the 42 policy on AI usage.

---

## 🧩 Extras & Conclusion

This project was an excellent opportunity to explore container orchestration with Docker. It strengthened my understanding of Linux networking, service isolation, and automated deployments. Managing service intercommunication, volume persistence, and securing endpoints were particularly instructive.

The bonus implementation allowed me to push the infrastructure further by introducing real-world use cases like Redis caching, FTP deployment, and serving a separate portfolio site.

Overall, **Inception** served as a comprehensive introduction to DevOps practices and microservice-style architectures.
