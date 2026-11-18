# 🔐 Infrastructure sécurisée — VPN WireGuard, Vaultwarden & Sauvegardes 3-2-1

> Projet réalisé dans le cadre de l'épreuve **E6 – Administration des systèmes et des réseaux** du **BTS SIO option SISR** (Session 2026).

Mise en place complète d'une infrastructure sécurisée sur un serveur Linux exposé sur Internet : accès distant chiffré via VPN, hébergement d'un service sensible (gestionnaire de mots de passe) et stratégie de sauvegarde robuste.

---

## 🎯 Objectifs

- Sécuriser l'accès au serveur (pare-feu + port knocking)
- Mettre en place un **VPN WireGuard** pour un accès distant chiffré
- Déployer **Vaultwarden** (gestionnaire de mots de passe) via Docker
- Sécuriser les échanges applicatifs en **HTTPS** (reverse proxy Nginx)
- Appliquer une stratégie de **sauvegarde 3-2-1** automatisée

---

## 🧱 Architecture

> Documentation Technique dossier E6 : [`docs/Dossier_E6_Dorian-PONSADA-infra-securisee-vpn-vaultwarden.pdf`](docs/Dossier_E6_Dorian-PONSADA-infra-securisee-vpn-vaultwarden.pdf)

> Schéma détaillé : [`docs/architecture.md`](docs/architecture.md)

---

## 🛠️ Stack technique

| Composant | Rôle |
|-----------|------|
| **Debian** | Système d'exploitation du serveur (VPS) |
| **UFW** | Pare-feu (politique par défaut : `deny incoming`) |
| **knockd** | Port knocking — ouverture dynamique du port SSH |
| **WireGuard** | VPN (UDP 51820), tunnel chiffré client ↔ serveur |
| **Docker / Docker Compose** | Conteneurisation de Vaultwarden |
| **Vaultwarden** | Gestionnaire de mots de passe (compatible Bitwarden) |
| **Nginx** | Reverse proxy HTTPS (certificat auto-signé OpenSSL) |
| **rsync / cron / MEGAcmd** | Automatisation des sauvegardes 3-2-1 |

---

## 📂 Contenu du dépôt

```
.
├── docs/                         # Documentation détaillée
│   ├── architecture.md           # Schéma & plan d'adressage
│   ├── installation.md           # Procédure d'installation complète
│   └── sauvegarde-3-2-1.md       # Politique & procédure de restauration
├── configs/                      # Fichiers de configuration (exemples sanitisés)
│   ├── wireguard/wg0.conf.example
│   ├── knockd/knockd.conf.example
│   ├── nginx/vaultwarden.conf.example
│   └── docker/docker-compose.yml.example
└── scripts/                      # Scripts de sauvegarde automatisés
    ├── backup_vaultwarden_local.sh
    ├── backup_vaultwarden_remote.sh
    └── backup_vaultwarden_mega.sh
```

---

## 🔑 Compétences mises en œuvre

- Concevoir une solution d'infrastructure réseau sécurisée
- Installer, tester et déployer des services réseau (VPN, reverse proxy, conteneurs)
- Sécuriser un système Linux exposé (pare-feu, port knocking, chiffrement TLS)
- Automatiser des tâches critiques (sauvegardes, rotation, restauration)
- Appliquer la règle de sauvegarde **3-2-1** (3 copies, 2 supports, 1 hors site)

---

## ✅ Tests réalisés

- Connexion SSH via séquence de port knocking → OK
- Établissement du tunnel VPN WireGuard (ping, interface `wg0`) → OK
- Accès HTTPS à Vaultwarden **uniquement via le VPN** → OK
- Sauvegardes locales / distantes / cloud avec rotation 7 jours → OK
- Tests de restauration (intégrité des données) → OK

---

## 👤 Auteur

**Dorian Ponsada** — BTS SIO SISR 2026
Objectif : analyste SOC / cybersécurité
