# Quick Start Guide

## Schnellstart für neue Geräte

### Schritt 1: WireGuard-Config erstellen

```bash
ssh hetzner "wg-qr-generator.sh <gerätename>"
```

Beispiele:
- `ssh hetzner "wg-qr-generator.sh iphone15"`
- `ssh hetzner "wg-qr-generator.sh surface-pro"`
- `ssh hetzner "wg-qr-generator.sh ipad-air"`

### Schritt 2: Config auf Gerät importieren

**Handy/Tablet:**
- QR-Code mit WireGuard App scannen

**Mac/Windows:**
```bash
scp hetzner:/tmp/<gerätename>.conf ~/Downloads/
```
Dann in WireGuard App importieren

### Schritt 3: Proxy konfigurieren

#### Mac
```bash
networksetup -setwebproxy "Wi-Fi" 10.200.0.1 8080
networksetup -setsecurewebproxy "Wi-Fi" 10.200.0.1 8080
networksetup -setwebproxystate "Wi-Fi" on
networksetup -setsecurewebproxystate "Wi-Fi" on
```

#### Windows
Einstellungen → Netzwerk & Internet → Proxy:
- Adresse: `10.200.0.1`
- Port: `8080`

#### Android/iOS
WLAN-Einstellungen → Proxy → Manuell:
- Server: `10.200.0.1`
- Port: `8080`

### Schritt 4: Testen

```bash
curl https://api.ipify.org
# Sollte 185.213.155.212 zeigen (Mullvad DE)
```

## Proxy umschalten

### Mullvad VPN (Standard)
```bash
# Mac
networksetup -setwebproxy "Wi-Fi" 10.200.0.1 8080
networksetup -setsecurewebproxy "Wi-Fi" 10.200.0.1 8080
```

Port: 8080
IP: 185.213.155.212 (Deutschland, Mullvad)

### Hetzner direkt
```bash
# Mac
networksetup -setsocksfirewallproxy "Wi-Fi" 10.200.0.1 1080
```

Port: 1080 (SOCKS5)
IP: 65.21.198.220 (Deutschland, Hetzner)

### Proxy deaktivieren
```bash
# Mac
networksetup -setwebproxystate "Wi-Fi" off
networksetup -setsecurewebproxystate "Wi-Fi" off
networksetup -setsocksfirewallproxystate "Wi-Fi" off
```

## Wichtige IPs

| Service | IP/Port | Ausgehende IP |
|---------|---------|---------------|
| Mullvad HTTP | 10.200.0.1:8080 | 185.213.155.212 (DE) |
| Hetzner SOCKS5 | 10.200.0.1:1080 | 65.21.198.220 (DE) |
| WireGuard Server | 65.21.198.220:51820 | - |

## Troubleshooting

```bash
# WireGuard verbunden?
wg show

# Proxy erreichbar?
curl --proxy http://10.200.0.1:8080 https://api.ipify.org

# Mullvad Container läuft?
ssh docker "docker ps | grep mullvad"
```

Mehr Details: siehe [README.md](hetzner/README.md)
