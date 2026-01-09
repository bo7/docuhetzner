# Claude Code MCP Server & Zen Model Setup Guide

## MCP Server Konfiguration

### Konfigurationsdatei
**Pfad:** `/Users/sbo/.claude.json`

### Aktuelle MCP Server (14 Server)

```json
{
  "mcpServers": {
    "github": {
      "command": "docker",
      "args": [
        "run",
        "-i",
        "--rm",
        "-e",
        "GITHUB_PERSONAL_ACCESS_TOKEN",
        "ghcr.io/github/github-mcp-server"
      ],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "YOUR_GITHUB_TOKEN"
      }
    },
    "context7": {
      "command": "npx",
      "args": ["-y", "@upstash/context7-mcp@latest"]
    },
    "memory": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-memory"],
      "env": {
        "MEMORY_STORE_PATH": "/Users/sbo/claude_memory.json"
      }
    },
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/Users/sbo/"]
    },
    "desktop-commander": {
      "command": "npx",
      "args": ["-y", "@wonderwhy-er/desktop-commander@latest"]
    },
    "ssh": {
      "command": "npx",
      "args": ["-y", "@idletoaster/ssh-mcp-server@latest"],
      "env": {
        "SSH_PRIVATE_KEY": "/Users/sbo/.ssh/id_rsa"
      }
    },
    "zen": {
      "type": "stdio",
      "command": "/Users/sbo/zen-mcp-server/.zen_venv/bin/python",
      "args": ["/Users/sbo/zen-mcp-server/server.py"],
      "env": {
        "CUSTOM_API_URL": "http://10.200.0.11:11434/v1",
        "CUSTOM_API_KEY": "",
        "CUSTOM_MODEL_NAME": "qwen3:235b",
        "CUSTOM_ALLOWED_MODELS": "qwen3:235b,qwen2.5:14b,deepseek-r1:32b,qwen3-coder:30b,llama3.2-vision:latest"
      }
    },
    "jetbrains": {
      "command": "npx",
      "args": ["-y", "@jetbrains/mcp-proxy"]
    },
    "brave-search": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-brave-search"],
      "env": {
        "BRAVE_API_KEY": "YOUR_BRAVE_API_KEY"
      }
    },
    "puppeteer": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-puppeteer"]
    },
    "sequential-thinking": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-sequential-thinking"]
    },
    "drawio-azure": {
      "command": "npm",
      "args": ["start"],
      "cwd": "/Users/sbo/drawio-azure-mcp-server",
      "env": {
        "NODE_ENV": "production"
      }
    },
    "web-search": {
      "command": "npx",
      "args": ["-y", "@anthropic-ai/mcp-web-search"]
    },
    "git": {
      "type": "stdio",
      "command": "/Users/sbo/.local/bin/uvx",
      "args": ["mcp-server-git", "--repository", "/Users/sbo/programmieren"],
      "env": {}
    }
  }
}
```

## Neuen MCP Server hinzufügen

### Schritt 1: Server zur Konfiguration hinzufügen

Bearbeite `/Users/sbo/.claude.json` und füge unter `"mcpServers"` einen neuen Eintrag hinzu:

```json
"server-name": {
  "type": "stdio",
  "command": "npx",
  "args": ["-y", "@modelcontextprotocol/server-name"],
  "env": {
    "API_KEY": "your-api-key-here"
  }
}
```

### Schritt 2: Claude Code neu starten

```bash
# Cmd+Q zum Beenden
# Claude Code neu öffnen
```

### Schritt 3: Server-Status prüfen

In Claude Code:
```
/mcp
```

### Beispiele für beliebte MCP Server

#### Filesystem Server
```json
"filesystem": {
  "command": "npx",
  "args": ["-y", "@modelcontextprotocol/server-filesystem", "/Users/sbo/Documents"]
}
```

#### PostgreSQL Server
```json
"postgres": {
  "command": "npx",
  "args": ["-y", "@modelcontextprotocol/server-postgres"],
  "env": {
    "DATABASE_URL": "postgresql://user:password@localhost:5432/dbname"
  }
}
```

#### Slack Server
```json
"slack": {
  "command": "npx",
  "args": ["-y", "@modelcontextprotocol/server-slack"],
  "env": {
    "SLACK_BOT_TOKEN": "xoxb-your-token",
    "SLACK_TEAM_ID": "T01234567"
  }
}
```

#### Google Drive Server
```json
"google-drive": {
  "command": "npx",
  "args": ["-y", "@modelcontextprotocol/server-gdrive"],
  "env": {
    "GOOGLE_CLIENT_ID": "your-client-id",
    "GOOGLE_CLIENT_SECRET": "your-client-secret"
  }
}
```

## Zen MCP Server - Neue Modelle hinzufügen

### Modell-Konfigurationsdatei
**Pfad:** `/Users/sbo/zen-mcp-server/conf/custom_models.json`

### Aktuell verfügbare Ollama-Modelle (10.200.0.11:11434)

1. **qwen3:235b** - 235B Parameter, Q4_K_M, Intelligence Score: 15
2. **qwen2.5:14b** - 14.8B Parameter, Q4_K_M, Intelligence Score: 8
3. **deepseek-r1:32b** - 32.8B Parameter, Q4_K_M, Intelligence Score: 10
4. **qwen3-coder:30b** - 30.5B Parameter, Q4_K_M, Intelligence Score: 9
5. **llama3.2-vision:latest** - 10.7B Parameter, Q4_K_M, Intelligence Score: 7
6. **llama3.2** - 128K context, Intelligence Score: 6

### Neues Modell zu Zen hinzufügen

#### Schritt 1: Modell auf Ollama-Server laden

```bash
# Auf dem Ollama-Server (10.200.0.11)
ollama pull model-name:tag
```

#### Schritt 2: Modell-Konfiguration hinzufügen

Bearbeite `/Users/sbo/zen-mcp-server/conf/custom_models.json`:

```json
{
  "model_name": "model-name:tag",
  "aliases": [
    "short-name",
    "local-shortname"
  ],
  "context_window": 32768,
  "max_output_tokens": 8192,
  "supports_extended_thinking": false,
  "supports_json_mode": true,
  "supports_function_calling": false,
  "supports_images": false,
  "max_image_size_mb": 0.0,
  "description": "Model description",
  "intelligence_score": 10
}
```

#### Schritt 3: Zen MCP Server neu starten

```bash
# Alle Zen-Prozesse beenden
ps aux | grep zen-mcp-server | grep -v grep | awk '{print $2}' | xargs kill -9

# Claude Code neu starten (Cmd+Q)
```

#### Schritt 4: Modell-Verfügbarkeit prüfen

In Claude Code mit Zen Tool:
```
zen:listmodels
```

### Modell-Parameter erklärt

- **context_window**: Maximale Token-Anzahl (Input + Output zusammen)
- **max_output_tokens**: Maximale Ausgabe-Länge
- **supports_extended_thinking**: Reasoning-Tokens (nur für spezielle Modelle)
- **supports_json_mode**: Garantiert valides JSON-Output
- **supports_function_calling**: Tool/Function Calling Support
- **supports_images**: Multimodal (Bild-Verarbeitung)
- **max_image_size_mb**: Max Bildgröße in MB
- **intelligence_score**: 1-20 Bewertung für Auto-Mode Sortierung
  - 15-20: Sehr starke Modelle (z.B. qwen3:235b)
  - 10-14: Starke Modelle (z.B. deepseek-r1:32b)
  - 5-9: Standard Modelle (z.B. qwen3-coder:30b)
  - 1-4: Leichtgewicht Modelle

### Beispiel: Neues Qwen-Modell hinzufügen

```json
{
  "model_name": "qwen2.5:72b",
  "aliases": [
    "qwen72b",
    "local-qwen72"
  ],
  "context_window": 32768,
  "max_output_tokens": 8192,
  "supports_extended_thinking": false,
  "supports_json_mode": true,
  "supports_function_calling": false,
  "supports_images": false,
  "max_image_size_mb": 0.0,
  "description": "Qwen 2.5 72B - large general purpose model on Ollama",
  "intelligence_score": 12
}
```

## Ollama Server Verwaltung

### Verfügbare Modelle anzeigen
```bash
curl -s http://10.200.0.11:11434/api/tags | python3 -m json.tool
```

### Modell testen
```bash
curl -s http://10.200.0.11:11434/api/generate -d '{
  "model": "qwen3:235b",
  "prompt": "Test",
  "stream": false
}'
```

### Modell löschen (auf Ollama-Server)
```bash
ollama rm model-name:tag
```

## Troubleshooting

### MCP Server verbindet nicht
1. Prüfe Logs: `/Users/sbo/Library/Logs/Claude/`
2. Prüfe Befehl-Pfad: `which npx` oder `which uvx`
3. Prüfe Environment-Variablen in .claude.json

### Zen Modell nicht verfügbar
1. Prüfe Ollama-Server: `curl http://10.200.0.11:11434/api/tags`
2. Prüfe custom_models.json Syntax
3. Zen-Prozesse beenden und Claude Code neu starten

### Git MCP Server fehlschlägt
- Absoluten Pfad zu uvx nutzen: `/Users/sbo/.local/bin/uvx`
- Repository-Pfad prüfen: Muss existierendes Git-Repo sein

## Quick Reference

### Wichtige Pfade
- MCP Config: `/Users/sbo/.claude.json`
- Zen Config: `/Users/sbo/zen-mcp-server/conf/custom_models.json`
- Claude Logs: `/Users/sbo/Library/Logs/Claude/`

### Nützliche Befehle
```bash
# Claude Code komplett beenden
killall Claude

# Zen Server Prozesse anzeigen
ps aux | grep zen-mcp-server

# Zen Server neu starten
ps aux | grep zen-mcp-server | grep -v grep | awk '{print $2}' | xargs kill -9

# Ollama Modelle auflisten
curl -s http://10.200.0.11:11434/api/tags
```

### Claude Code MCP Verwaltung
```
/mcp              # Server-Status anzeigen
/mcp reconnect    # Server neu verbinden
```

## Weitere MCP Server

Durchsuche das MCP Server Directory:
- https://github.com/modelcontextprotocol/servers
- https://github.com/punkpeye/awesome-mcp-servers

Beliebte Server:
- Filesystem, Git, GitHub
- PostgreSQL, MySQL, SQLite
- Slack, Discord
- Google Drive, Notion
- Brave Search, Tavily
- Puppeteer, Playwright
- AWS, Google Cloud

---

**Stand:** Januar 2026
**Ollama Server:** 10.200.0.11:11434
**Hauptmodell:** qwen3:235b (235B Parameter)
