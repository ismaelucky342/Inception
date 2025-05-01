# Inception
<p align="center">
  <img src="https://github.com/user-attachments/assets/3d4d4c9c-4602-4250-8721-80c2c64e0080" width="300">
</p>

## Project Overview

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

## How to Use

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
├── .env
├── secrets/          # Stores credentials (ignored by Git)
├── srcs/
│   ├── requirements/
│   │   ├── nginx/
│   │   ├── wordpress/
│   │   ├── mariadb/
│   │   ├── adminer/
│   │   ├── redis/     # Bonus
│   │   ├── ftp/       # Bonus
│   │   └── static/    # Bonus
│   └── docker-compose.yml
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

## 🧩 Extras & Conclusion

This project was an excellent opportunity to explore container orchestration with Docker. It strengthened my understanding of Linux networking, service isolation, and automated deployments. Managing service intercommunication, volume persistence, and securing endpoints were particularly instructive.

The bonus implementation allowed me to push the infrastructure further by introducing real-world use cases like Redis caching, FTP deployment, and serving a separate portfolio site.

Overall, **Inception** served as a comprehensive introduction to DevOps practices and microservice-style architectures.
