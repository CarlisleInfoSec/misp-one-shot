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
- Runs schema migrations to match the current MISP code
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
```

When the script finishes, access MISP at:

```
http://<your-server-ip>/
```

Default login:
```
admin@admin.test / admin
```

---

## 🛠 Post‑Install Checklist

After logging in:

1. Go to **Administration → Server Settings & Maintenance**
2. Confirm all indicators are green
3. Update warning lists, taxonomies, and galaxies if needed:
   ```bash
   sudo -u www-data /var/www/MISP/app/Console/cake Admin updateWarningLists
   sudo -u www-data /var/www/MISP/app/Console/cake Admin updateTaxonomies
   sudo -u www-data /var/www/MISP/app/Console/cake Admin updateJSON
   ```
4. Take a VM snapshot for rollback safety

---

## 📂 Project Structure

```
misp-one-shot/
├── misp_install.sh           # Main installer script
├── README.md                 # This file
├── LICENSE                   # MIT License
└── docs/
    ├── post_install_checklist.md
    ├── troubleshooting.md
    └── architecture_overview.md
```

---

## 🤝 Contributing

Pull requests are welcome!  
If you find a bug or want to add a feature, open an issue first to discuss what you’d like to change.

---

## 📜 License

MIT License

Copyright (c) 2025 YOUR NAME

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights  
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell  
copies of the Software, and to permit persons to whom the Software is  
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in  
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR  
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,  
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE  
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER  
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,  
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN  
THE SOFTWARE.
