# Politique de sauvegarde 3-2-1 & restauration

## Principe : la règle 3-2-1

| Critère | Implémentation |
|---------|----------------|
| **3 copies** | Locale + distante + cloud |
| **2 supports** | VPS + serveur distant |
| **1 externalisée** | Cloud (MEGA) |

## Objectifs (modèle DICAN)

- **Disponibilité** : restauration rapide du service en cas d'incident (PRA).
- **Intégrité** : garantir que les données ne sont ni altérées ni corrompues.
- **Confidentialité** : accès sécurisés (VPN, transferts chiffrés SSH).
- **Authenticité / Non-répudiation** : traçabilité via journaux d'exécution.

## Périmètre sauvegardé

- Base de données Vaultwarden (comptes, coffres-forts)
- Données persistantes du conteneur (`/opt/vaultwarden/data`)
- Configurations (`/etc/wireguard/`, `/etc/nginx/`, `docker-compose.yml`)

## Planification (cron)

| Heure | Type de sauvegarde | Script |
|-------|--------------------|--------|
| 02h00 | Locale (VPS) | `backup_vaultwarden_local.sh` |
| 02h30 | Distante (rsync/SSH) | `backup_vaultwarden_remote.sh` |
| 04h00 | Cloud (MEGA) | `backup_vaultwarden_mega.sh` |

Rétention : **7 jours** (rotation automatique).

## Procédure de restauration

### Restauration locale
```bash
docker compose down
tar -xvzf backup.tar.gz -C /opt/vaultwarden/
docker compose up -d
```

### Depuis le serveur distant
```bash
rsync -avz -e 'ssh -p SSH_PORT' user@serveur:/backup/ ./
# puis restaurer comme en local
```

### Depuis MEGA
```bash
mega-get /vaultwarden/backup.tar.gz
# puis restaurer comme en local
```

### Vérification
- Accès HTTPS fonctionnel via VPN
- Connexion utilisateur possible
- Données restaurées correctement
