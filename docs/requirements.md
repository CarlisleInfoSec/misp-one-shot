# Requirements

## Supported OS
- Debian 13 (fresh install recommended)

## Hardware
- **CPU:** 2+ cores
- **RAM:** 4 GB minimum (8 GB recommended)
- **Disk:** 20 GB free space

## Network
- Internet access for package installation
- Open ports:
  - 80/tcp (HTTP)
  - 443/tcp (HTTPS, if enabled)
  - 6379/tcp (Redis, optional internal use)

## Privileges
- Root or sudo access

## Notes
- Script assumes no existing Apache or MariaDB configuration conflicts.
- For existing stacks, use `--no-apache` or `--no-db` flags.
