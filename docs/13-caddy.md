# Caddy Reverse Proxy

## Objective

Deploy Caddy as the reverse proxy for the Gneiss homelab.

Responsibilities:

- Friendly URLs for all services
- Single entry point for the homelab
- HTTP during initial development
- HTTPS with an internal CA later
- Configuration stored in Git

---

# Architecture

```
Client
    │
    ▼
+-------------+
|    Caddy    |
|   Port 80   |
+-------------+
      │
      ├────────► Homepage   (3000)
      ├────────► CasaOS     (8099)
      ├────────► Portainer  (9443)
      ├────────► Grafana
      ├────────► Airflow
      ├────────► MinIO
      ├────────► Jellyfin
      └────────► ...
```

---

# Repository Layout

```
compose/
└── infrastructure/
    └── caddy/
        ├── docker-compose.yml
        ├── .env.example
        ├── .gitignore
        ├── README.md
        └── config/
            └── Caddyfile
```

Persistent data:

```
/mnt/storage/Gneiss/
└── infrastructure/
    └── caddy/
        ├── data/
        └── config/
```

---

# Docker Compose

```yaml
services:
  caddy:
    image: caddy:2.10
    container_name: caddy
    restart: unless-stopped

    ports:
      - "80:80"
      - "443:443"

    volumes:
      - ./config/Caddyfile:/etc/caddy/Caddyfile:ro
      - /mnt/storage/Gneiss/infrastructure/caddy/data:/data
      - /mnt/storage/Gneiss/infrastructure/caddy/config:/config

    extra_hosts:
      - "host.docker.internal:host-gateway"

    security_opt:
      - no-new-privileges:true

    networks:
      - gneiss-infra

networks:
  gneiss-infra:
    name: gneiss-infra
```

---

# Current Caddyfile

```caddy
{
    debug
}

http://home.gneiss {
    reverse_proxy host.docker.internal:3000
}

http://casa.gneiss {
    reverse_proxy host.docker.internal:8099
}

http://portainer.gneiss {
    reverse_proxy https://host.docker.internal:9443 {
        transport http {
            tls_insecure_skip_verify
        }
    }
}
```

---

# Local DNS

Each client machine requires local hostname mappings.

Mac/Linux:

```
/etc/hosts
```

Example:

```
192.168.1.9    home.gneiss
192.168.1.9    casa.gneiss
192.168.1.9    portainer.gneiss
```

Windows:

```
C:\Windows\System32\drivers\etc\hosts
```

---

# Homepage Configuration

Homepage validates incoming hostnames.

When using Caddy, Homepage must allow the custom hostname.

```
HOMEPAGE_ALLOWED_HOSTS=home.gneiss,192.168.1.9,localhost
```

---

# Portainer

Portainer already serves HTTPS.

Proxy configuration:

```caddy
reverse_proxy https://host.docker.internal:9443 {
    transport http {
        tls_insecure_skip_verify
    }
}
```

---

# CasaOS

CasaOS originally occupied port 80.

Port changed to:

```
8099
```

Proxy target:

```
http://host.docker.internal:8099
```

---

# Known Issues

## Browser keeps redirecting to HTTPS

Cause:

Previously the site was configured with TLS.

Browsers cache HTTPS redirects and HSTS.

Symptoms:

- curl works
- Incognito works
- Normal browser redirects to HTTPS

Resolution:

- Open an Incognito window
- Clear browser HSTS/cache for the domain
- Or wait for cached policies to expire

---

## Host validation failed

Homepage rejects unknown Host headers.

Solution:

```
HOMEPAGE_ALLOWED_HOSTS=home.gneiss,192.168.1.9,localhost
```

---

## Caddy only listening on :443

Incorrect:

```caddy
home.gneiss {
    ...
}
```

Even with:

```caddy
{
    auto_https off
}
```

Caddy still creates an HTTPS listener for bare hostnames.

Correct HTTP configuration:

```caddy
http://home.gneiss {
    ...
}
```

---

## Verifying Configuration

Validate configuration:

```bash
docker exec caddy caddy validate --config /etc/caddy/Caddyfile
```

View adapted configuration:

```bash
docker exec caddy caddy adapt --pretty --config /etc/caddy/Caddyfile
```

View logs:

```bash
docker logs -f caddy
```

Check listening ports:

```bash
docker exec caddy netstat -tln
```

---

# Future Improvements

- Enable HTTPS with `tls internal`
- Trust Caddy root CA on all devices
- Replace `/etc/hosts` with a local DNS server (AdGuard Home or Technitium)
- Organize routes into individual site configuration files
- Automatic wildcard certificates for local services (internal CA)

---

# Final URLs

Homepage

```
http://home.gneiss
```

CasaOS

```
http://casa.gneiss
```

Portainer

```
http://portainer.gneiss
```

---

# Lessons Learned

- Keep infrastructure configuration in Git.
- Store runtime data under `/mnt/storage/Gneiss/infrastructure`.
- Use HTTP during the initial build phase to simplify debugging.
- Migrate the entire homelab to HTTPS in one step after all services are deployed.
- For HTTP virtual hosts in Caddy, explicitly prefix the site with `http://`. Bare hostnames default to HTTPS behavior.