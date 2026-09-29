#!/bin/bash
# Externalisation cloud vers MEGA (depuis le serveur de backup) — rotation 7 jours
# Cron : 0 4 * * * /home/VOTRE_USER/backup_vaultwarden_mega.sh
# Prérequis : mega-cmd installé + mega-login effectué

SOURCE="/home/VOTRE_USER/vault-save"
DEST="/vaultwarden"
LOG="/home/VOTRE_USER/vaultwarden-mega.log"
RETENTION_DAYS=7

echo "[$(date '+%Y-%m-%d %H:%M:%S')] === Début sauvegarde MEGA ===" >> "$LOG"

# Suppression du message PSA de MEGA
mega-psa --discard > /dev/null 2>&1

# Upload uniquement des fichiers PAS encore présents sur MEGA
for FILE in "$SOURCE"/vaultwarden_*.tar.gz; do
  FILENAME=$(basename "$FILE")
  if mega-ls "$DEST/$FILENAME" > /dev/null 2>&1; then
    echo "[...] Déjà présent, ignoré : $FILENAME" >> "$LOG"
  else
    echo "[...] Upload : $FILENAME" >> "$LOG"
    mega-put "$FILE" "$DEST/" >> "$LOG" 2>&1
  fi
done

# Rotation : suppression des fichiers de plus de 7 jours
NOW=$(date +%s)
mega-ls "$DEST" | grep 'vaultwarden_.*\.tar\.gz' | while read -r file; do
  FILE_DATE=$(echo "$file" | sed 's/vaultwarden_\([0-9]*\)_.*/\1/')
  FILE_TS=$(date -d "$FILE_DATE" +%s 2>/dev/null)
  if [[ -n "$FILE_TS" ]]; then
    AGE=$(( (NOW - FILE_TS) / 86400 ))
    if [[ "$AGE" -gt $RETENTION_DAYS ]]; then
      echo "[...] Suppression (${AGE}j) : $file" >> "$LOG"
      mega-rm "$DEST/$file" >> "$LOG" 2>&1
    fi
  fi
done

echo "[$(date '+%Y-%m-%d %H:%M:%S')] === Fin sauvegarde MEGA ===" >> "$LOG"
