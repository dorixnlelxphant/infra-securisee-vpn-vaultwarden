#!/bin/bash
# Sauvegarde locale de Vaultwarden (VPS) — rotation 7 jours
# Cron : 0 2 * * * /usr/local/bin/backup_vaultwarden_local.sh

DATE=$(date +"%Y-%m-%d_%H-%M")
SOURCE="/opt/vaultwarden/data"
DEST="/var/backups/vaultwarden"
BACKUP_NAME="vaultwarden_${DATE}.tar.gz"

# Création de la sauvegarde
tar -czf "$DEST/$BACKUP_NAME" "$SOURCE"

# Suppression des backups de plus de 7 jours
find "$DEST" -type f -name "vaultwarden_*.tar.gz" -mtime +7 -delete
