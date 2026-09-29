# Procédure d'installation complète

> Toutes les valeurs sensibles (IP, domaines, séquences, clés) sont **génériques**. Remplace-les par les tiennes.

## 1. Sécurisation initiale du serveur

```bash
# Mise à jour du système
sudo apt update && sudo apt upgrade -y

# Installation et configuration du pare-feu UFW
sudo apt install -y ufw
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow 51820/udp      # WireGuard
sudo ufw deny 443
sudo ufw enable
sudo ufw status verbose
```

## 2. Port Knocking (knockd)

```bash
sudo apt install -y knockd
sudo nano /etc/knockd.conf
```

Voir [`configs/knockd/knockd.conf.example`](../configs/knockd/knockd.conf.example).

```bash
sudo systemctl enable knockd
sudo systemctl start knockd

# Test : séquence de knock puis connexion SSH
knock -v -4 example.local PORT1 PORT2 PORT3 && ssh user@example.local -p SSH_PORT
```

## 3. VPN WireGuard

```bash
sudo apt install -y wireguard

# Génération des clés serveur
wg genkey | tee privatekey | wg pubkey > publickey

# Configuration
sudo nano /etc/wireguard/wg0.conf   # voir configs/wireguard/wg0.conf.example

# Activation
sudo systemctl enable wg-quick@wg0
sudo systemctl start wg-quick@wg0
ip a       # vérifier l'interface wg0
```

## 4. Docker & Vaultwarden

```bash
# Docker : suivre la doc officielle https://docs.docker.com/engine/install/debian/
systemctl status docker

sudo mkdir -p /opt/vaultwarden
cd /opt/vaultwarden
sudo nano docker-compose.yml     # voir configs/docker/docker-compose.yml.example

sudo docker compose up -d
sudo docker ps
```

## 5. HTTPS avec Nginx

```bash
sudo apt install -y nginx openssl

# Certificat auto-signé
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout /etc/nginx/ssl/vaultwarden.key \
  -out    /etc/nginx/ssl/vaultwarden.crt

# Virtual host  (voir configs/nginx/vaultwarden.conf.example)
sudo nano /etc/nginx/sites-available/vaultwarden
sudo ln -s /etc/nginx/sites-available/vaultwarden /etc/nginx/sites-enabled/
sudo rm /etc/nginx/sites-enabled/default
sudo nginx -t
sudo systemctl restart nginx
```

Accès : `https://10.66.66.1` (disponible **uniquement via le tunnel VPN**).

## 6. Sauvegardes

Voir [`docs/sauvegarde-3-2-1.md`](sauvegarde-3-2-1.md) et le dossier [`scripts/`](../scripts).
