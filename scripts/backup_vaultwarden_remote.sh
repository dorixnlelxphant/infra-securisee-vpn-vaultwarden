#!/bin/bash
# Sauvegarde distante de Vaultwarden vers un serveur de stockage (rsync/SSH)
# Cron : 30 2 * * * /usr/local/bin/backup_vaultwarden_remote.sh

DATE=$(date +"%Y-%m-%d_%H-%M")
SOURCE="/opt/vaultwarden/data"
TMP="/tmp/vaultwarden_${DATE}.tar.gz"
REMOTE_USER="VOTRE_USER"
REMOTE_IP="IP_SERVEUR_BACKUP"
REMOTE_PORT="SSH_PORT"
REMOTE_DIR="/home/VOTRE_USER/vault-save"
SSH_KEY="/home/VOTRE_USER/.ssh/id_ed25519"

# Création archive locale temporaire
tar -czf "$TMP" "$SOURCE"

# Envoi vers le serveur distant
rsync -av -e "ssh -p $REMOTE_PORT -i $SSH_KEY" "$TMP" \
  "$REMOTE_USER@$REMOTE_IP:$REMOTE_DIR/"

# Nettoyage du fichier temporaire local
rm -f "$TMP"

# Rotation distante : suppression des backups de plus de 7 jours
ssh -i "$SSH_KEY" -p "$REMOTE_PORT" "$REMOTE_USER@$REMOTE_IP" \
  "find $REMOTE_DIR -type f -name 'vaultwarden_*.tar.gz' -mtime +7 -delete"
