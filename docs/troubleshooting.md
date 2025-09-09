# Troubleshooting 🛠

Common issues and how to fix them.

---

## Apache Shows Debian Default Page Instead of MISP
**Cause:** Apache's default site is still enabled and catching requests.  
**Fix:**
```bash
sudo a2dissite 000-default
sudo a2ensite misp
sudo systemctl reload apache2
```

---

## `_cake_core_ cache was unable to write` Error
**Cause:** Cache directories missing or not writable by `www-data`.  
**Fix:**
```bash
sudo mkdir -p /var/www/MISP/app/tmp/cache/{persistent,models,views}
sudo chown -R www-data:www-data /var/www/MISP/app/tmp
sudo chmod -R 755 /var/www/MISP/app/tmp
```

---

## `Database connection "MysqlObserverExtended" is missing`
**Cause:** `$default` in `database.php` points to wrong DB credentials, or `$MysqlObserverExtended` block is missing/broken.  
**Fix:**
- Ensure both `$default` and `$MysqlObserverExtended` use the same valid DB user/password.
- `$MysqlObserverExtended` block should be inside `class DATABASE_CONFIG` and syntactically correct.

---

## Composer Warnings About Abandoned Packages
These are informational and usually safe to ignore.  
If you want to update them:
```bash
cd /var/www/MISP/app
sudo -u www-data composer update
```

---

## Plugin Crashes During DB Updates
**Cause:** Some plugins (like `SysLogLogable`) try to connect before the schema is ready.  
**Fix:** Temporarily comment out the plugin in `bootstrap.php`, run updates, then re‑enable it.

---

If you hit an issue not listed here, check the [MISP GitHub Issues](https://github.com/MISP/MISP/issues) or open a new one with detailed logs.
