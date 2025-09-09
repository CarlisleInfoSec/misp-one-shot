# MISP One‑Shot Installer 🚀

This project provides a **single script** to go from a clean Debian 13 host to a fully functional [MISP](https://www.misp-project.org/) instance — LAN‑accessible, plugin‑ready, and snapshot‑safe.

## Features
- Installs all required packages (including `ed` for safe PHP injection)
- Configures MariaDB with a dedicated `misp` user
- Injects `MysqlObserverExtended` datasource into `database.php` without syntax errors
- Disables `SysLogLogable` until after DB updates to prevent migration crashes
- Creates cache directories with correct permissions
- Configures Apache to serve MISP at the server’s IP (no `/MISP` path)
- Disables the default Apache site so you don’t see the Debian placeholder page
- Runs initial MISP update tasks
- Leaves you with a reproducible, snapshot‑ready baseline

## Quick Start

```bash
git clone https://github.com/YOURUSERNAME/misp-one-shot.git
cd misp-one-shot
chmod +x misp_install.sh
sudo ./misp_install.sh
```

Once complete, access MISP at:
http://<your-server-ip>/

Default login:
admin@admin.test / admin

Requirements

    Fresh Debian 13 install

    Root or sudo privileges

    Internet access for package installation
