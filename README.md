# MISP One‑Shot Installer 🚀

A single script to go from a **fresh Debian 13 host** to a fully functional [MISP](https://www.misp-project.org/) instance — LAN‑accessible, plugin‑ready, and snapshot‑safe.

This installer automates the entire process:
- Installs all required packages (including `ed` for safe PHP injection)
- Configures MariaDB with a dedicated `misp` user
- Injects `MysqlObserverExtended` datasource into `database.php` without syntax errors
- Disables `SysLogLogable` until after DB updates to prevent migration crashes
- Creates cache directories with correct permissions
- Configures Apache to serve MISP at the server’s IP (no `/MISP` path)
- Disables the default Apache site so you don’t see the Debian placeholder page
- Runs initial MISP update tasks
- Leaves you with a reproducible, snapshot‑ready baseline

---

## 📋 Requirements

- Fresh **Debian 13** install
- Root or sudo privileges
- Internet access for package installation

---

## ⚡ Quick Start

```bash
git clone https://github.com/YOURUSERNAME/misp-one-shot.git
cd misp-one-shot
chmod +x misp_install.sh
sudo ./misp_install.sh
