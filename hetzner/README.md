# Hetzner WireGuard + Mullvad VPN Setup

Dokumentation für das WireGuard-Setup mit Mullvad VPN über Hetzner Server.

## Übersicht

```
Mac/Windows/Mobile
       ↓ (WireGuard)
Hetzner Server (10.200.0.1)
       ↓ (Port-Forwarding)
Docker VM (192.168.122.222)
       ↓ (Gluetun Container)
Mullvad VPN (Frankfurt, DE)
       ↓
Internet (deutsche IP)
```

## Komponenten

### 1. Hetzner WireGuard Server
- **IP**: 65.21.198.220
- **WireGuard Interface**: wg0
- **Internes Netz**: 10.200.0.0/24
- **Port**: 51820

### 2. Docker VM
- **IP (intern)**: 192.168.122.222
- **IP (WG-Netz)**: 10.10.10.30
- **Installation**: /opt/docker/mullvad

### 3. Mullvad VPN Container (Gluetun)
- **HTTP Proxy**: 192.168.122.222:8080
- **Ausgehende IP**: 185.213.155.212 (Mullvad Frankfurt)
- **Container**: mullvad-gluetun

### 4. Port-Forwarding (Hetzner → Docker VM)
- **Service**: mullvad-proxy.service
- **Weiterleitung**: 10.200.0.1:8080 → 192.168.122.222:8080

## Client-Konfiguration

### Neue WireGuard-Clients erstellen

Für einfache WireGuard-Verbindungen (Handys, Tablets, etc.):

```bash
ssh hetzner "wg-qr-generator.sh <client-name>"
```

**Beispiele:**
```bash
ssh hetzner "wg-qr-generator.sh pixel10pro"
ssh hetzner "wg-qr-generator.sh ipad-sven"
ssh hetzner "wg-qr-generator.sh surface-tablet"
```

Das Script:
- Generiert automatisch Keys
- Findet nächste freie IP (10.200.0.x)
- Fügt Client zum Server hinzu
- Zeigt QR-Code zum Scannen
- Speichert Config in `/tmp/<client-name>.conf`

### Mac Setup

**1. WireGuard installieren:**
```bash
brew install wireguard-tools
```

**2. Konfiguration erstellen:**
```bash
ssh hetzner "wg-qr-generator.sh macbook-sven"
scp hetzner:/tmp/macbook-sven.conf ~/Downloads/
```

**3. WireGuard App nutzen:**
- WireGuard App aus App Store installieren
- Config-Datei importieren
- Verbindung aktivieren

**4. HTTP-Proxy konfigurieren:**

Für Mullvad VPN (deutsche IP):
```bash
networksetup -setsocksfirewallproxystate "Wi-Fi" off
networksetup -setwebproxy "Wi-Fi" 10.200.0.1 8080
networksetup -setsecurewebproxy "Wi-Fi" 10.200.0.1 8080
networksetup -setwebproxystate "Wi-Fi" on
networksetup -setsecurewebproxystate "Wi-Fi" on
```

Für direkte Hetzner-IP (ohne Mullvad):
```bash
networksetup -setwebproxystate "Wi-Fi" off
networksetup -setsecurewebproxystate "Wi-Fi" off
networksetup -setsocksfirewallproxy "Wi-Fi" 10.200.0.1 1080
networksetup -setsocksfirewallproxystate "Wi-Fi" on
```

**5. Proxy deaktivieren:**
```bash
networksetup -setwebproxystate "Wi-Fi" off
networksetup -setsecurewebproxystate "Wi-Fi" off
networksetup -setsocksfirewallproxystate "Wi-Fi" off
```

### Windows Setup

**1. WireGuard installieren:**
- Download: https://www.wireguard.com/install/
- Installer ausführen

**2. Konfiguration erstellen:**
```bash
ssh hetzner "wg-qr-generator.sh windows-desktop"
scp hetzner:/tmp/windows-desktop.conf ~/Downloads/
```

**3. Config importieren:**
- WireGuard App öffnen
- "Import tunnel(s) from file" → windows-desktop.conf auswählen
- "Activate" klicken

**4. Proxy konfigurieren:**

Windows-Einstellungen:
```
Einstellungen → Netzwerk & Internet → Proxy
```

**Manueller Proxy:**
- Proxyserver verwenden: **Ein**
- Adresse: **10.200.0.1**
- Port: **8080**
- Nicht verwenden für: `localhost;127.0.0.1;*.local`

**PowerShell (automatisch):**
```powershell
# HTTP-Proxy aktivieren (Mullvad)
netsh winhttp set proxy proxy-server="http=10.200.0.1:8080;https=10.200.0.1:8080" bypass-list="localhost;127.0.0.1"

# Proxy deaktivieren
netsh winhttp reset proxy
```

### Android Setup

**Option 1: Mullvad App (EMPFOHLEN)**
1. Mullvad VPN App aus Play Store installieren
2. Account-Nummer eingeben
3. Server auswählen (Germany)
4. Verbinden

**Option 2: WireGuard + Proxy**
1. WireGuard App aus Play Store installieren
2. QR-Code scannen:
   ```bash
   ssh hetzner "wg-qr-generator.sh pixel10pro"
   ```
3. Verbindung aktivieren
4. WLAN-Proxy konfigurieren:
   - Einstellungen → Netzwerk & Internet → Internet → [WLAN] → Erweitert
   - Proxy: **Manuell**
   - Hostname: **10.200.0.1**
   - Port: **8080**

**Hinweis:** Proxy-Einstellung gilt nur für WLAN, nicht für Mobilfunk!

### iOS/iPadOS Setup

**1. WireGuard App installieren:**
- App Store: "WireGuard"

**2. Config erstellen und importieren:**
```bash
ssh hetzner "wg-qr-generator.sh iphone-sven"
```

**3. QR-Code scannen:**
- WireGuard App öffnen
- "+" → "QR-Code erstellen oder scannen"
- QR-Code scannen

**4. Proxy konfigurieren:**
- Einstellungen → WLAN → [Dein WLAN] → (i) → HTTP-Proxy → Manuell
- Server: **10.200.0.1**
- Port: **8080**

## IP-Adressen Übersicht

| Client | WireGuard IP | Beschreibung |
|--------|--------------|--------------|
| Hetzner Server | 10.200.0.1 | WireGuard Server |
| Mac M3 | 10.200.0.10 | Sven's MacBook |
| Pixel 10 Pro | 10.200.0.11 | Sven's Handy |
| *verfügbar* | 10.200.0.12+ | Weitere Clients |

## Proxy-Übersicht

| Proxy | Adresse | Ausgehende IP | Verwendung |
|-------|---------|---------------|------------|
| HTTP (Mullvad) | 10.200.0.1:8080 | 185.213.155.212 (DE) | Standard |
| SOCKS5 (Hetzner) | 10.200.0.1:1080 | 65.21.198.220 (DE) | Alternative |

## Mullvad Container verwalten

### Status prüfen
```bash
ssh docker "cd /opt/docker/mullvad && docker compose ps"
ssh docker "docker logs mullvad-gluetun --tail 50"
```

### Container neustarten
```bash
ssh docker "cd /opt/docker/mullvad && docker compose restart"
```

### Container stoppen/starten
```bash
ssh docker "cd /opt/docker/mullvad && docker compose stop"
ssh docker "cd /opt/docker/mullvad && docker compose start"
```

### Mullvad-Server wechseln

**1. Neue Config von Mullvad herunterladen:**
- https://mullvad.net/en/account/wireguard-config
- Land: Germany
- Stadt: Frankfurt/Berlin/Düsseldorf
- Alle Server auswählen

**2. Config auf Docker VM kopieren:**
```bash
scp ~/Downloads/de-fra-wg-002.conf docker:/opt/docker/mullvad/mullvad.conf
```

**3. Container neustarten:**
```bash
ssh docker "cd /opt/docker/mullvad && docker compose restart"
```

## WireGuard-Clients verwalten

### Client entfernen
```bash
# Peer Public Key herausfinden
ssh hetzner "sudo wg show wg0"

# Client entfernen (Public Key aus obiger Ausgabe)
ssh hetzner "sudo wg set wg0 peer <PUBLIC_KEY> remove && sudo wg-quick save wg0"
```

### Alle Clients anzeigen
```bash
ssh hetzner "sudo wg show wg0"
```

### WireGuard-Server neustarten
```bash
ssh hetzner "sudo systemctl restart wg-quick@wg0"
```

## Troubleshooting

### Keine Verbindung zum Proxy

**Prüfen:**
```bash
# 1. WireGuard verbunden?
wg show

# 2. Hetzner Server erreichbar?
ping 10.200.0.1

# 3. Proxy läuft?
ssh hetzner "sudo systemctl status mullvad-proxy"

# 4. Mullvad Container läuft?
ssh docker "docker ps | grep mullvad"
```

**Proxy testen:**
```bash
# Von Mac aus
curl --proxy http://10.200.0.1:8080 https://api.ipify.org
# Sollte 185.213.155.212 zeigen

# Direkt vom Hetzner
ssh hetzner "curl --proxy http://192.168.122.222:8080 https://api.ipify.org"
```

### Mullvad Container startet nicht

```bash
# Logs anschauen
ssh docker "docker logs mullvad-gluetun --tail 100"

# Container neu erstellen
ssh docker "cd /opt/docker/mullvad && docker compose down && docker compose up -d"
```

### WireGuard auf Hetzner funktioniert nicht

```bash
# Status prüfen
ssh hetzner "sudo systemctl status wg-quick@wg0"

# Interface prüfen
ssh hetzner "sudo wg show wg0"

# Neustarten
ssh hetzner "sudo systemctl restart wg-quick@wg0"
```

## Backup

### WireGuard-Konfiguration sichern
```bash
# Server Config
scp hetzner:/etc/wireguard/wg0.conf ~/backup/hetzner-wg0.conf

# Mullvad Config
scp docker:/opt/docker/mullvad/mullvad.conf ~/backup/mullvad.conf
scp docker:/opt/docker/mullvad/docker-compose.yml ~/backup/mullvad-docker-compose.yml
```

## Nützliche Befehle

```bash
# Aktuelle öffentliche IP anzeigen
curl https://api.ipify.org

# Mit Proxy testen
curl --proxy http://10.200.0.1:8080 https://api.ipify.org

# WireGuard Status
wg show

# Alle aktiven WireGuard-Interfaces
sudo wg show all

# Routing-Tabelle anzeigen
netstat -rn | grep utun
```

## Sicherheitshinweise

1. **Nie** die WireGuard Private Keys öffentlich teilen
2. **Nie** die Mullvad Account-Nummer öffentlich posten
3. Regelmäßig Mullvad Credits kaufen (läuft nach Zeit ab)
4. Bei Problemen: Client entfernen und neu erstellen

## Support

Bei Fragen oder Problemen:
- Mullvad Support: https://mullvad.net/help
- WireGuard Docs: https://www.wireguard.com/quickstart/
