# Architecture Overview 🏗

This document explains the key components deployed by `misp_install.sh` and how they fit together.

---

## 1. Operating System
- **Debian 13** (fresh install recommended)

---

## 2. Web Server
- **Apache 2**
  - Serves MISP from `/var/www/MISP/app/webroot`
  - Configured to respond on the server's IP address
  - Default Debian site disabled

---

## 3. Database
- **MariaDB**
  - Database: `misp`
  - User: `misp` (password set in `misp_install.sh`)
  - Privileges: Full access to `misp` database

---

## 4. PHP
- PHP 8.x with required extensions:
  - `mbstring`, `xml`, `bcmath`, `zip`, `gd`, `intl`, `curl`, `redis`, `ldap`

---

## 5. Redis
- Used for background jobs and caching

---

## 6. MISP Application
- Cloned from [MISP GitHub](https://github.com/MISP/MISP)
- Composer dependencies installed without dev packages
- Config files:
  - `bootstrap.php` (plugins)
  - `database.php` (DB connections)
  - `core.php` and `config.php` (core settings)

---

## 7. Customizations by Installer
- Injects `$MysqlObserverExtended` datasource into `database.php` using `ed`
- Sets `$default` and `$MysqlObserverExtended` to same DB credentials
- Disables `SysLogLogable` until after DB updates
- Creates cache directories with correct permissions
- Configures Apache vhost for LAN access

---

## 8. Access
- Web UI: `http://<server-ip>/`
- Default login: `admin@admin.test / admin` (change immediately)

---

This setup is designed for **reproducibility** and **snapshot safety** — ideal for labs, training, and production deployments.
