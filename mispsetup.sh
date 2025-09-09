#!/bin/bash
set -e
export PATH=$PATH:/usr/sbin

MISP_USER="misp"
MISP_PASS="StrongPasswordHere"
MISP_BASE="/var/www/MISP"
MISP_HOSTNAME="misp.local"

# 1. System update & essentials
apt update && apt upgrade -y
apt install -y curl gnupg lsb-release apt-transport-https sudo git composer apache2 \
    libapache2-mod-php mariadb-server mariadb-client \
    php php-cli php-mysql php-mbstring php-xml php-bcmath php-zip php-gd php-intl php-curl php-redis php-ldap \
    redis-server python3 python3-pip python3-venv python3-dev libpq5 libjpeg-dev zlib1g-dev \
    libxslt1-dev libmagic1 libffi-dev libpq-dev libssl-dev ed

# 2. DB setup
systemctl enable --now mariadb
mysql -u root <<EOF
DROP USER IF EXISTS '${MISP_USER}'@'localhost';
CREATE DATABASE IF NOT EXISTS misp;
CREATE USER '${MISP_USER}'@'localhost' IDENTIFIED BY '${MISP_PASS}';
GRANT ALL PRIVILEGES ON misp.* TO '${MISP_USER}'@'localhost';
FLUSH PRIVILEGES;
EOF

# 3. Apache setup
a2enmod rewrite headers ssl
systemctl enable --now apache2
systemctl enable --now redis-server

# 4. Clone MISP
if [ ! -d "${MISP_BASE}" ]; then
    git clone https://github.com/MISP/MISP.git ${MISP_BASE}
fi
cd ${MISP_BASE}
git submodule update --init --recursive
chown -R www-data:www-data ${MISP_BASE}

# 5. Composer deps
cd ${MISP_BASE}/app
sudo -u www-data composer config allow-plugins.php-http/discovery true
sudo -u www-data composer install --no-dev

# 6. Config templates
cd ${MISP_BASE}/app/Config
cp -a bootstrap.default.php bootstrap.php
cp -a database.default.php database.php
cp -a core.default.php core.php
cp -a config.default.php config.php

# 7. Disable SysLogLogable temporarily
sed -i "s/CakePlugin::load('SysLogLogable'/\/\/CakePlugin::load('SysLogLogable'/" bootstrap.php

# 8. Set $default DB creds to misp user
sed -i "s/'login' => .*/'login' => '${MISP_USER}',/" database.php
sed -i "s/'password' => .*/'password' => '${MISP_PASS}',/" database.php

# 9. Inject MysqlObserverExtended block with ed
ed -s database.php <<'EOF'
/];/
a
    public $MysqlObserverExtended = array(
        'datasource' => 'Database/Mysql',
        'persistent' => false,
        'host' => 'localhost',
        'login' => 'misp',
        'password' => 'StrongPasswordHere',
        'database' => 'misp',
        'prefix' => '',
        'encoding' => 'utf8'
    );
.
w
q
EOF

# 10. Import base schema
mysql -u ${MISP_USER} -p${MISP_PASS} misp < ${MISP_BASE}/INSTALL/MYSQL.sql

# 11. Create cache dirs
mkdir -p ${MISP_BASE}/app/tmp/cache/{persistent,models,views}
chown -R www-data:www-data ${MISP_BASE}/app/tmp
chmod -R 755 ${MISP_BASE}/app/tmp

# 12. Apache vhost
cat >/etc/apache2/sites-available/misp.conf <<APACHECONF
<VirtualHost *:80>
    ServerAdmin admin@${MISP_HOSTNAME}
    DocumentRoot ${MISP_BASE}/app/webroot
    # ServerName ${MISP_HOSTNAME}
    <Directory ${MISP_BASE}/app/webroot>
        Options -Indexes
        AllowOverride all
        Require all granted
    </Directory>
</VirtualHost>
APACHECONF

# Enable MISP site and disable default site quietly
a2ensite misp >/dev/null
a2dissite 000-default >/dev/null

# Reload Apache to apply changes
systemctl reload apache2
echo "[INFO] Apache sites configured and reloaded — continuing install..."

# 13. Bring DB schema fully up to date BEFORE JSON updates
echo "[INFO] Attempting database schema upgrade..."
if sudo -u www-data ${MISP_BASE}/app/Console/cake upgrade; then
    echo "[INFO] Database schema upgraded via 'cake upgrade'."
elif sudo -u www-data ${MISP_BASE}/app/Console/cake Admin runUpdates; then
    echo "[INFO] Database schema upgraded via 'Admin runUpdates'."
elif sudo -u www-data ${MISP_BASE}/app/Console/cake Admin updateDatabase; then
    echo "[INFO] Database schema upgraded via 'Admin updateDatabase'."
else
    echo "[WARN] No known DB upgrade command succeeded — check MISP version."
fi

# 14. Run initial MISP update tasks with plugin disabled
sudo -u www-data ${MISP_BASE}/app/Console/cake Admin updateWarningLists || true
sudo -u www-data ${MISP_BASE}/app/Console/cake Admin updateTaxonomies || true
sudo -u www-data ${MISP_BASE}/app/Console/cake Admin updateJSON || true

# 15. Re-enable SysLogLogable
sed -i "s/\/\/CakePlugin::load('SysLogLogable'/CakePlugin::load('SysLogLogable'/" bootstrap.php

# 16. Final perms
chown -R www-data:www-data ${MISP_BASE}

echo "=== MISP install complete ==="
echo "Access via: http://<your-server-ip> (or set DNS/hosts for ${MISP_HOSTNAME})"
echo "Default login: admin@admin.test / admin"
