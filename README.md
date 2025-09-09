# Post‑Install Checklist ✅

Follow this checklist after running `misp_install.sh` to confirm your MISP instance is healthy and ready for use.

---

## 1. Web UI Access
- Open a browser and go to:
  ```
  http://<your-server-ip>/
  ```
- Log in with:
  ```
  admin@admin.test / admin
  ```
- Change the default password immediately under **Administration → List Users**.

---

## 2. Server Settings & Maintenance
- Navigate to **Administration → Server Settings & Maintenance**.
- Confirm all indicators are **green**.
- If any are red/orange:
  - Click the setting name for guidance.
  - Apply the recommended fix.
  - Refresh the page to confirm the change.

---

## 3. Update Core Data
Run these commands to ensure your instance has the latest definitions:

```bash
sudo -u www-data /var/www/MISP/app/Console/cake Admin updateWarningLists
sudo -u www-data /var/www/MISP/app/Console/cake Admin updateTaxonomies
sudo -u www-data /var/www/MISP/app/Console/cake Admin updateJSON
```

---

## 4. Enable Plugins
- Go to **Administration → Plugin Settings**.
- Enable any plugins you need (e.g., `SysLogLogable` should now work without DB errors).
- Save changes and reload the page.

---

## 5. Snapshot for Rollback Safety
If running in a VM or container:
- Shut down the instance cleanly.
- Take a snapshot or image.
- Label it clearly (e.g., `MISP_Deb13_CleanInstall_YYYYMMDD`).

---

## 6. Optional Hardening
- Configure HTTPS with a valid TLS certificate.
- Restrict access to trusted IP ranges.
- Set up regular backups for the database and `/var/www/MISP`.

---

Your MISP instance is now ready for production or lab use.
