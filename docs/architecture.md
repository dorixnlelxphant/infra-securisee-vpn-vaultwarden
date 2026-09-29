# Architecture technique & plan d'adressage

## Vue d'ensemble

Le serveur principal est un **VPS sous Debian** exposé sur Internet. Son accès SSH est protégé par **port knocking** (knockd) et un **pare-feu UFW**. **WireGuard** crée un tunnel VPN chiffré entre le client et le VPS. **Vaultwarden** est déployé via Docker, accessible uniquement depuis le tunnel VPN en HTTPS (Nginx). Les sauvegardes suivent une stratégie **3-2-1** : locale sur le VPS, distante sur un serveur de stockage via rsync, et cloud sur MEGA.

## Plan d'adressage (exemple)

| Machine | IP | Rôle |
|---------|-----|------|
| VPS | `VOTRE_IP_PUBLIQUE` | Serveur principal |
| Serveur de backup | `IP_SERVEUR_BACKUP` | Serveur de stockage distant |
| Réseau VPN | `10.66.66.0/24` | Tunnel sécurisé WireGuard |
| Vaultwarden (interne) | `10.66.66.1` | Service interne (accessible via VPN) |

## Flux réseau

| Flux | Port / Protocole | Description |
|------|------------------|-------------|
| VPN WireGuard | UDP 51820 | Tunnel chiffré client ↔ VPS |
| SSH | TCP (port non standard) | Ouvert **dynamiquement** après port knocking |
| HTTPS Vaultwarden | TCP 443 (sur `wg0`) | Accès applicatif, VPN uniquement |
| Sauvegarde distante | TCP (SSH/rsync) | Vers le serveur de backup |

## Principes de sécurité appliqués

- **Réduction de la surface d'attaque** : pare-feu restrictif (`deny incoming` par défaut), SSH masqué par port knocking.
- **Chiffrement des communications** : VPN WireGuard + TLS (Nginx).
- **Isolation des services** : Vaultwarden en conteneur, écoute locale uniquement (`127.0.0.1:8080`).
- **Authentification forte** : clés cryptographiques WireGuard, clés SSH pour les sauvegardes.
- **Redondance des données** : règle 3-2-1.
